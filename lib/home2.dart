import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home2Page extends StatelessWidget {
  final String category;

  const Home2Page({super.key, required this.category});

  Stream<QuerySnapshot> _fetchPostsByCategory() {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('type', isEqualTo: category) // Filter by category
        .snapshots();
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _fetchPostsByCategory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('An error occurred.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No posts available in this category.'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Product Image
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey[200],
                              ),
                              // child: ClipRRect(
                              //   borderRadius: BorderRadius.circular(10),
                              //   child: data['imageUrls'] != null &&
                              //           (data['imageUrls'] as List).isNotEmpty
                              //       ? Image.network(
                              //           data['imageUrls'][0],
                              //           fit: BoxFit.cover,
                              //           errorBuilder:
                              //               (context, error, stackTrace) {
                              //             return const Icon(
                              //               Icons.broken_image,
                              //               size: 40,
                              //               color: Colors.grey,
                              //             );
                              //           },
                              //         )
                              //       : const Icon(
                              //           Icons.image_not_supported,
                              //           size: 40,
                              //           color: Colors.grey,
                              //         ),
                              // ),
                             child: ClipRRect(
                          child: Image.memory(
                            base64Decode(data['imageUrls']),
                            fit: BoxFit.cover,
                            // errorBuilder: (context, error, stackTrace) =>
                            //     const Icon(
                            //   Icons.broken_image,
                            //   size: 40,
                            //   color: Colors.grey,
                            // ),
                          )
                        ),


                            ),
                            const SizedBox(width: 15),

                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['partName'] ?? 'Product Name',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    data['price'] != null
                                        ? 'Rs. ${data['price']}'
                                        : 'No Price',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFAC00),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    data['location'] ?? 'No Location',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFD900),
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      context.push('/details', extra: data);
                                    },
                                    child: const Text(
                                      'More Details',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
