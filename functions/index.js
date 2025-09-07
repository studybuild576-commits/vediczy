const functions = require("firebase-functions");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {getStorage} = require("firebase-admin/storage");
const {DiscussServiceClient} = require("@google-ai/generativelanguage");
const {GoogleAuth} = require("google-auth-library");
const pdf = require("pdf-parse");

// Firebase Admin SDK को शुरू करें
initializeApp();

// Gemini API क्लाइंट को शुरू करें
const MODEL_NAME = "models/text-bison-001";
// 🤫 अपनी Gemini API Key को सुरक्षित रखने के लिए, हम इसे environment variable में डालेंगे
const API_KEY = process.env.GEMINI_API_KEY; 
const client = new DiscussServiceClient({
  authClient: new GoogleAuth().fromAPIKey(API_KEY),
});

/**
 * यह Cloud Function तब चलेगा जब Firebase Storage के 'tests-to-process/'
 * फोल्डर में कोई नई PDF फाइल अपलोड होगी।
 */
exports.processPdfToTest = functions.storage.object().onFinalize(async (object) => {
  const fileBucket = object.bucket; // PDF जिस बाल्टी में है
  const filePath = object.name;   // PDF का पूरा रास्ता
  const fileName = filePath.split("/").pop(); // PDF का नाम

  // सुनिश्चित करें कि यह सही फोल्डर में है
  if (!filePath.startsWith("tests-to-process/")) {
    return functions.logger.log("This is not a file to process.");
  }

  const bucket = getStorage().bucket(fileBucket);
  const file = bucket.file(filePath);

  // 1. PDF फाइल को डाउनलोड करें और उसका टेक्स्ट निकालें
  const [fileBuffer] = await file.download();
  const pdfData = await pdf(fileBuffer);
  const pdfText = pdfData.text;

  if (!pdfText) {
    return functions.logger.error("Could not extract text from PDF.");
  }

  // 2. Gemini API के लिए एक विस्तृत निर्देश (Prompt) बनाएँ
  const prompt = `
    Based on the following text extracted from a PDF, create a structured quiz.
    Extract all questions, their multiple-choice options, and the correct answer.
    The output must be a valid JSON array of objects.
    Each object in the array should have three keys:
    1. "questionText" (string): The full text of the question.
    2. "options" (array of strings): The multiple-choice options.
    3. "correctOptionIndex" (integer): The index of the correct answer in the options array (starting from 0).

    Example of the required JSON output:
    [
      {
        "questionText": "What is the capital of India?",
        "options": ["Mumbai", "New Delhi", "Chennai", "Kolkata"],
        "correctOptionIndex": 1
      }
    ]

    Here is the text to process:
    ---
    ${pdfText}
    ---
  `;

  try {
    // 3. Gemini API को कॉल करें
    const result = await client.generateMessage({
      model: MODEL_NAME,
      prompt: { text: prompt },
    });

    const responseText = result[0].candidates[0].content;
    
    // Gemini से मिले JSON को साफ़ करें
    const cleanJson = responseText.replace(/```json/g, "").replace(/```/g, "").trim();
    const questionsArray = JSON.parse(cleanJson);

    // 4. Firestore में एक नया टेस्ट बनाएँ
    const firestore = getFirestore();
    const testRef = await firestore.collection("Tests").add({
      title: `Test from: ${fileName}`,
      description: "Auto-generated from uploaded PDF.",
      examName: "Auto-Generated",
      category: "auto",
      tier: null,
      testType: "pdf-mock",
      testFormat: "full",
      isActive: true,
      createdAt: new Date(),
    });

    // 5. सभी प्रश्नों को Firestore में सेव करें
    const batch = firestore.batch();
    for (const question of questionsArray) {
      const questionRef = firestore.collection("Questions").doc();
      batch.set(questionRef, {
        testId: testRef.id,
        questionText: question.questionText,
        options: question.options,
        correctOptionIndex: question.correctOptionIndex,
        subject: "Auto-Generated",
      });
    }
    await batch.commit();

    functions.logger.log(`✅ Successfully generated ${questionsArray.length} questions for test ${testRef.id}`);
    
    // प्रोसेस होने के बाद फाइल को दूसरे फोल्डर में भेजें (वैकल्पिक)
    await file.move(`processed-tests/${fileName}`);

  } catch (error) {
    functions.logger.error("Error processing with Gemini API or saving to Firestore:", error);
    // त्रुटि होने पर फाइल को error फोल्डर में भेजें (वैकल्पिक)
    await file.move(`error-tests/${fileName}`);
  }

  return null;
});
