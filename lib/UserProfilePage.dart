import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _aboutController = TextEditingController();
  bool _isEditingAbout = false;
  List<File> _experienceProofFiles = [];
  bool _isLookingForTeam = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialStatus();
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialStatus() async {
    final doc =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    if (doc.exists) {
      setState(() {
        _isLookingForTeam = doc.data()?['isLookingForTeam'] ?? false;
      });
    }
  }

  Future<void> _updateAboutDetails(String userId, String aboutDetails) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'aboutDetails': aboutDetails,
      });
      setState(() {
        _isEditingAbout = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('About details updated successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating about details: $e'),
        ),
      );
    }
  }

  Future<void> _uploadExperienceProofs(String userId) async {
    if (_experienceProofFiles.isNotEmpty) {
      try {
        List<String> experienceProofUrls = [];
        for (File file in _experienceProofFiles) {
          Reference storageReference = FirebaseStorage.instance.ref().child(
              'experience_proofs/${userId}_${experienceProofUrls.length}.jpg');
          UploadTask uploadTask = storageReference.putFile(file);
          TaskSnapshot taskSnapshot = await uploadTask;
          String experienceProofUrl = await taskSnapshot.ref.getDownloadURL();
          experienceProofUrls.add(experienceProofUrl);
        }

        await _firestore.collection('users').doc(userId).update({
          'experienceProofUrls': experienceProofUrls,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Experience proofs uploaded successfully'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading experience proofs: $e'),
          ),
        );
      }
    }
  }

  Future<void> _pickExperienceProofs() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _experienceProofFiles =
            pickedFiles.map((file) => File(file.path)).toList();
      });
      await _uploadExperienceProofs(_auth.currentUser!.uid);
    }
  }

  Future<void> _toggleLookingForTeam() async {
    try {
      final newStatus = !_isLookingForTeam;
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'isLookingForTeam': newStatus,
      });
      setState(() {
        _isLookingForTeam = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newStatus
              ? 'You are now visible to teams'
              : 'You are no longer visible to teams'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating team status: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          _aboutController.text = userData?['aboutDetails'] ?? '';
          List<String>? experienceProofUrls =
              userData?['experienceProofUrls']?.cast<String>();

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: userData?['profilePictureUrl'] !=
                                    null
                                ? NetworkImage(userData!['profilePictureUrl'])
                                : null,
                            child: userData?['profilePictureUrl'] == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          if (userData?['userType'] == 'Professional Player')
                            IconButton(
                              onPressed: _pickExperienceProofs,
                              icon: const Icon(Icons.upload_file),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Name: ${userData?['name'] ?? ''}',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Email: ${userData?['email'] ?? ''}',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'User Type: ${userData?['userType'] ?? ''}',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      if (userData?['userType'] == 'Professional Player')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8.0),
                            Text(
                              'Playing Position: ${userData?['playingPosition'] ?? ''}',
                              style: GoogleFonts.poppins(fontSize: 18),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Contact Details: ${userData?['contactDetails'] ?? ''}',
                              style: GoogleFonts.poppins(fontSize: 18),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _aboutController,
                              decoration: InputDecoration(
                                hintText: 'About details',
                                border: OutlineInputBorder(),
                                suffixIcon: _isEditingAbout
                                    ? IconButton(
                                        onPressed: () {
                                          _updateAboutDetails(
                                              _auth.currentUser!.uid,
                                              _aboutController.text);
                                        },
                                        icon: const Icon(Icons.check),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isEditingAbout = true;
                                          });
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                              ),
                              maxLines: null,
                              readOnly: !_isEditingAbout,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _toggleLookingForTeam,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isLookingForTeam ? Colors.green : Colors.blue,
                        ),
                        child: Text(
                          _isLookingForTeam
                              ? 'Looking for a team'
                              : 'Already in a team',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ],
                  ),
                ),
                if (experienceProofUrls != null &&
                    experienceProofUrls.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: experienceProofUrls.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Image.network(
                                          experienceProofUrls[index]),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        experienceProofUrls[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
