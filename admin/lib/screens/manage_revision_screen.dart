import 'dart:typed_data';
import 'package.flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageRevisionScreen extends StatefulWidget {
  @override
  _ManageRevisionScreenState createState() => _ManageRevisionScreenState();
}

class _ManageRevisionScreenState extends State<ManageRevisionScreen> {
  final _titleController = TextEditingController();
  PlatformFile? _pickedFile;
  UploadTask? _uploadTask;
  bool _isLoading = false;

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  Future<void> _uploadAndSave() async {
    if (_pickedFile == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a file and enter a title.')),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final path = 'revision-pdfs/${_pickedFile!.name}';
      final ref = FirebaseStorage.instance.ref().child(path);
      Uint8List fileBytes = _pickedFile!.bytes!;

      setState(() {
        _uploadTask = ref.putData(fileBytes);
      });

      final snapshot = await _uploadTask!.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Firestore mein save karein
      await FirebaseFirestore.instance.collection('Revisions').add({
        'title': _titleController.text,
        'pdfUrl': downloadUrl,
        'fileName': _pickedFile!.name,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green, content: Text('PDF uploaded successfully!')),
      );

      // Form ko reset karein
      setState(() {
        _pickedFile = null;
        _uploadTask = null;
        _titleController.clear();
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add New Revision PDF", style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 20),
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'PDF Title', border: OutlineInputBorder())),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.upload_file),
                  label: Text("Select PDF"),
                  onPressed: _selectFile,
                ),
                SizedBox(width: 10),
                Expanded(child: Text(_pickedFile?.name ?? 'No file selected')),
              ],
            ),
            SizedBox(height: 16),
            if (_uploadTask != null)
              StreamBuilder<TaskSnapshot>(
                stream: _uploadTask!.snapshotEvents,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final progress = snapshot.data!.bytesTransferred / snapshot.data!.totalBytes;
                    return LinearProgressIndicator(value: progress, minHeight: 10);
                  }
                  return SizedBox.shrink();
                },
              ),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _uploadAndSave,
                      child: Text('Upload & Save'),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16)),
                    ),
                  ),
            Divider(height: 40),
            Text("Uploaded PDFs", style: Theme.of(context).textTheme.headlineSmall),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Revisions').orderBy('createdAt', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                          title: Text(doc['title']),
                          subtitle: Text(doc['fileName']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
