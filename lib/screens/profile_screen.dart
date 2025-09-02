import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<UserCredential> _signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('Login cancelled');
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final cred = await _auth.signInWithCredential(credential);

    final uid = cred.user!.uid;
    final userDoc = _db.collection('users').doc(uid);
    final snap = await userDoc.get();
    if (!snap.exists) {
      await userDoc.set({
        'name': cred.user!.displayName ?? 'Learner',
        'photoUrl': cred.user!.photoURL,
        'email': cred.user!.email,
        'targetExam': 'SSC CGL 2025',
        'createdAt': FieldValue.serverTimestamp(),
        'xp': 0,
        'streak': 0,
        'testsGiven': 0,
        'accuracy': 0.0,
        'badges': [],
        'progress': 0.0,
      });
    }
    return cred;
  }

  Future<void> _logout() async {
    try {
      await GoogleSignIn().signOut().catchError((_) {});
      await _auth.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out')),
        );
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'Yeh action permanent hai. Aapke tests, bookmarks, progress sab delete ho sakte hain.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete permanently'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // Soft-delete Firestore profile
      await _db.collection('users').doc(user.uid).set(
        {
          'deletedAt': FieldValue.serverTimestamp(),
          'active': false,
        },
        SetOptions(merge: true),
      );

      // Delete auth user
      await user.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: user == null ? _buildLoggedOut() : _buildLoggedIn(user),
    );
  }

  Widget _buildLoggedOut() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(radius: 48, child: Icon(Icons.school, size: 40)),
          const SizedBox(height: 16),
          const Text('Welcome to SSC Prep!'),
          const SizedBox(height: 8),
          const Text('Login karke apna progress save karein.'),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () async {
              try {
                await _signInWithGoogle();
                if (mounted) setState(() {});
              } catch (e) {
                _showError(e.toString());
              }
            },
            icon: const Icon(Icons.login),
            label: const Text('Login with Google'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedIn(User user) {
    final uid = user.uid;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _db.collection('users').doc(uid).snapshots(),
      builder: (context, snap) {
        final data = snap.data?.data() ?? {};
        final name = data['name'] ?? user.displayName ?? 'Learner';
        final photoUrl = data['photoUrl'] ?? user.photoURL;
        final targetExam = data['targetExam'] ?? 'SSC CGL 2025';

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null ? const Icon(Icons.person, size: 36) : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    Text(targetExam, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: _deleteAccount,
              icon: const Icon(Icons.delete_forever_outlined),
              label: const Text('Delete account'),
            ),
          ],
        );
      },
    );
  }
}
