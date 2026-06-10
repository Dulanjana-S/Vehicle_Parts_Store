import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _partNameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  // List<XFile> _selectedImages = []; // List to store multiple selected images
  bool _isLoading = false;

  final List<String> _locations = [
    "Colombo",
    "Kandy",
    "Galle",
    "Jaffna",
    "Negombo",
    "Anuradhapura",
    "Polonnaruwa",
    "Ratnapura",
    "Matara",
  ]; // Example locations
  final List<String> _types = [
    'Engines',
    'Wheels',
    'Alternators',
    'Lights',
    'Batteries',
    'Chassis',
    'Seats',
    'Accessories'
  ]; // Updated types
  final List<String> _models = [
    "Toyota",
    "Honda",
    "Nissan",
    "Ford",
    "BMW",
    "Mercedes"
  ]; // Car models
  String? _selectedLocation;
  String? _selectedType;
  String? _selectedModel; // Selected car model

  @override
  void initState() {
    super.initState();
    _requestGalleryPermission(); // Automatically request gallery permission
  }

  Future<void> _requestGalleryPermission() async {
    await Permission.photos.request(); // Request gallery permission silently
  }

  // Future<void> _pickImages() async {
  //   try {
  //     final ImagePicker picker = ImagePicker();
  //     final List<XFile>? images =
  //         await picker.pickMultiImage(); // Allow multiple image selection
  //     if (images != null && images.isNotEmpty) {
  //       setState(() {
  //         _selectedImages = images;
  //       });
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to pick images: $e')),
  //     );
  //   }
  // }

  final ImagePicker imagePicker = ImagePicker();

  String? _base64Image;
  File? _image;
  XFile? _selectedImage;

  Future<void> _pickImages() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
      _base64Image = base64Encode(_image!.readAsBytesSync());
      _selectedImage = image;
    });
  }

  // Future<List<String>> _uploadImages() async {
  //   List<String> imageUrls = [];
  //   for (var image in _selectedImages) {
  //     try {
  //       // Convert the image file to binary data
  //       final bytes = await File(image.path).readAsBytes();

  //       // Generate a unique file path for each image
  //       final storageRef = FirebaseStorage.instance.ref().child(
  //           'post_images/${DateTime.now().millisecondsSinceEpoch}_${image.name}');

  //       // Upload the binary data
  //       final uploadTask = storageRef.putData(bytes);

  //       // Wait for the upload to complete
  //       final snapshot = await uploadTask.whenComplete(() {});

  //       // Retrieve the download URL
  //       final imageUrl = await snapshot.ref.getDownloadURL();
  //       imageUrls.add(imageUrl);
  //     } on FirebaseException catch (e) {
  //       // Handle Firebase-specific errors
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Firebase error: ${e.message}')),
  //       );
  //     } catch (e) {
  //       // Handle other errors
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Image upload failed: $e')),
  //       );
  //     }
  //   }

  //   // Ensure at least one image URL is uploaded
  //   if (imageUrls.isEmpty) {
  //     throw Exception('No images were uploaded. Please try again.');
  //   }

  //   return imageUrls;
  // }

  Future<void> _submitForm() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to create a post.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        // final imageUrls = await _uploadImages(); // Upload multiple images
        await FirebaseFirestore.instance.collection('posts').add({
          'partName': _partNameController.text,
          'location': _selectedLocation, // Use selected location
          'weight': _weightController.text,
          'type': _selectedType, // Use selected type
          'address': _addressController.text,
          'description': _descriptionController.text,
          'price': _priceController.text, // Add price
          'contactNumber': _contactNumberController.text, // Add contact number
          'model': _selectedModel, // Save selected car model
          'imageUrls': _base64Image, // Store list of image URLs
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid, // Associate the post with the authenticated user
        });
        if (mounted) {
          context.go('/mypost'); // Use the correct route
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD900),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),

                    // child: _selectedImages.isEmpty
                    //     ? const Center(
                    //         child: Icon(Icons.add_photo_alternate,
                    //             size: 40, color: Colors.black54),
                    //       )
                    //     : ListView.builder(
                    //         scrollDirection: Axis.horizontal,
                    //         itemCount: _selectedImages.length,
                    //         itemBuilder: (context, index) {
                    //           return Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: ClipRRect(
                    //               borderRadius: BorderRadius.circular(10),
                    //               child: Image.file(
                    //                 File(_selectedImages[index].path),
                    //                 fit: BoxFit.cover,
                    //                 width: 100,
                    //                 height: 100,
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    child: _selectedImage == null
                        ? const Center(
                            child: Icon(Icons.add_photo_alternate,
                                size: 40, color: Colors.black54),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_selectedImage!.path),
                              fit: BoxFit.cover,
                              width:120,
                              height: 120,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD900),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      buildTextField(
                          "Part Name", Icons.settings, _partNameController),
                      DropdownButtonFormField<String>(
                        value: _selectedLocation,
                        items: _locations
                            .map((location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLocation = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.location_on,
                              color: Colors.black54),
                          labelText: "Location",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                        validator: (value) =>
                            value == null ? 'Please select a location' : null,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        items: _types
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.category, color: Colors.black54),
                          labelText: "Type",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                        validator: (value) =>
                            value == null ? 'Please select a type' : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedModel,
                        items: _models
                            .map((model) => DropdownMenuItem(
                                  value: model,
                                  child: Text(model),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedModel = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.directions_car,
                              color: Colors.black54),
                          labelText: "Vehicle Model",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                        ),
                        validator: (value) =>
                            value == null ? 'Please select a car model' : null,
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                          "Price(LKR)", Icons.attach_money, _priceController),
                      buildTextField("Contact Number", Icons.phone,
                          _contactNumberController),
                      buildTextField(
                          "Weight(Kg)", Icons.line_weight, _weightController),
                      buildTextField("Address", Icons.home, _addressController),
                      buildTextField("Description", Icons.description,
                          _descriptionController,
                          maxLines: 3),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          await _submitForm();
                          if (mounted) {
                            context.go('/mypost');
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD900),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          "Post",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) =>
            value!.isEmpty ? 'This field cannot be empty' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
      ),
    );
  }
}
