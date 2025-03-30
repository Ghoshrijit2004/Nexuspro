import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  File? _achievementPdf;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _nationController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  String? _profileImageUrl;
  String? _pdfUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

      setState(() {
        _firstNameController.text = data["firstName"] ?? "";
        _lastNameController.text = data["lastName"] ?? "";
        _emailController.text = data["email"] ?? "";
        _phoneController.text = data["phone"] ?? "";
        _whatsappController.text = data["whatsapp"] ?? "";
        _nationController.text = data["nation"] ?? "";
        _stateController.text = data["state"] ?? "";
        _districtController.text = data["district"] ?? "";
        _cityController.text = data["city"] ?? "";
        _pinCodeController.text = data["pinCode"] ?? "";
        _skillsController.text = data["skills"] ?? "";
        _profileImageUrl = data["profileImageUrl"];
        _pdfUrl = data["achievementPdfUrl"];
      });
    }
  }

  Future<void> _saveUserProfile() async {
    if (!_formKey.currentState!.validate()) return;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userPath = "users/${user.uid}";

    String? profileImageUrl = _profileImageUrl;
    String? pdfUrl = _pdfUrl;

    if (_profileImage != null) {
      profileImageUrl =
          await _uploadFile(_profileImage!, "$userPath/profile.jpg");
    }

    if (_achievementPdf != null) {
      pdfUrl = await _uploadFile(_achievementPdf!, "$userPath/achievement.pdf");
    }

    Map<String, dynamic> updatedData = {
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "whatsapp": _whatsappController.text,
      "nation": _nationController.text,
      "state": _stateController.text,
      "district": _districtController.text,
      "city": _cityController.text,
      "pinCode": _pinCodeController.text,
      "skills": _skillsController.text,
      "updatedAt": DateTime.now().toIso8601String(),
    };

    if (profileImageUrl != null) {
      updatedData["profileImageUrl"] = profileImageUrl;
    }

    if (pdfUrl != null) {
      updatedData["achievementPdfUrl"] = pdfUrl;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(updatedData)
        .then((_) {
      print("Profile updated successfully");
    }).catchError((error) {
      print("Error updating profile: $error");
    });

    setState(() {
      _profileImageUrl = profileImageUrl;
      _pdfUrl = pdfUrl;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Saved Successfully!')),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _achievementPdf = File(result.files.single.path!);
      });
    }
  }

  Future<String?> _uploadFile(File file, String path) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref(path);
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }

  void _viewPdf() async {
    if (_pdfUrl != null && await canLaunchUrl(Uri.parse(_pdfUrl!))) {
      await launchUrl(Uri.parse(_pdfUrl!),
          mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No PDF available to view')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null,
                    child: (_profileImageUrl == null)
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(_firstNameController, "First Name"),
                _buildTextField(_lastNameController, "Last Name"),
                _buildTextField(_emailController, "Email"),
                _buildTextField(_phoneController, "Phone Number"),
                _buildTextField(_whatsappController, "WhatsApp Number"),
                _buildTextField(_nationController, "Nation"),
                _buildTextField(_stateController, "State"),
                _buildTextField(_districtController, "District"),
                _buildTextField(_cityController, "City"),
                _buildTextField(_pinCodeController, "Pin Code"),
                _buildTextField(_skillsController, "Skills"),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _pickPdf, child: const Text("Upload PDF")),
                if (_pdfUrl != null)
                  TextButton(
                      onPressed: _viewPdf,
                      child: const Text("View Uploaded PDF")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _saveUserProfile,
                    child: const Text("Save Profile")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
