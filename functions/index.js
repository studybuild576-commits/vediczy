const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Configuration, OpenAIApi } = require("openai");

admin.initializeApp();

// OpenAI API key from GitHub Secrets
const configuration = new Configuration({
  apiKey: process.env.GEMINI_API_KEY,
});
const openai = new OpenAIApi(configuration);

// ===== AI Doubt Solve Function =====
exports.solveDoubt = functions.https.onCall(async (data, context) => {
  const question = data.question;
  
  const response = await openai.createChatCompletion({
    model: "gpt-4",
    messages: [{ role: "user", content: question }]
  });

  const answer = response.data.choices[0].message.content;

  await admin.firestore().collection("user_doubts").add({
    userId: context.auth?.uid || "anonymous",
    question,
    answer,
    timestamp: admin.firestore.FieldValue.serverTimestamp()
  });

  return { answer };
});

// ===== Daily SSC Current Affairs =====
exports.dailySSC = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
  const date = new Date().toISOString().split("T")[0];

  // Example: Replace with AI-generated current affairs or scraping
  const affairs = `SSC Current Affairs for ${date}: ...`;

  await admin.firestore().collection("ssc_current_affairs").add({
    title: `SSC Current Affairs - ${date}`,
    content: affairs,
    date
  });
});
