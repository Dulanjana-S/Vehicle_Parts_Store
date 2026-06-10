import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appBar.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  // Fetch products from Firestore
  Stream<QuerySnapshot> _fetchProducts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Delete product from Firestore
  Future<void> _deleteProduct(String docId) async {
    await FirebaseFirestore.instance.collection('posts').doc(docId).delete();
  }

  // Fetch image from Firebase Storage and convert binary to image
  // Future<ImageProvider> _fetchImage(String? imageUrl) async {
  //   try {
  //     if (imageUrl == null || imageUrl.isEmpty) {
  //       throw Exception("Invalid image URL.");
  //     }

  //     // Fetch the binary data from the image URL
  //     final binaryData =
  //         await FirebaseStorage.instance.refFromURL(imageUrl).getData();

  //     // Convert the binary data to an ImageProvider
  //     if (binaryData != null) {
  //       return MemoryImage(binaryData); // Convert binary data to MemoryImage
  //     } else {
  //       throw Exception("Failed to fetch image data.");
  //     }
  //   } on FirebaseException catch (e) {
  //     // Handle Firebase-specific errors
  //     print('Firebase error: ${e.message}');
  //     return const AssetImage('assets/placeholder.png'); // Placeholder image
  //   } catch (e) {
  //     // Handle other errors
  //     print('Error fetching image: $e');
  //     return const AssetImage('assets/placeholder.png'); // Placeholder image
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: CustomAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Product Image Box
                      // FutureBuilder<ImageProvider>(
                      //   future: _fetchImage(data['imageUrl'],
                      //   ),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return Container(
                      //         width: 100,
                      //         height: 100,
                      //         decoration: BoxDecoration(
                      //           color: Colors.grey[300],
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         child: const Center(
                      //           child: CircularProgressIndicator(),
                      //         ),
                      //       );
                      //     }
                      //     if (snapshot.hasError || !snapshot.hasData) {
                      //       return Container(
                      //         width: 100,
                      //         height: 100,
                      //         decoration: BoxDecoration(
                      //           color: Colors.grey[300],
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         child: const Center(
                      //           child: Icon(
                      //             Icons.broken_image,
                      //             size: 40,
                      //             color: Colors.grey,
                      //           ),
                      //         ),
                      //       );
                      //     }
                      //     return Container(
                      //       width: 100,
                      //       height: 100,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         image: DecorationImage(
                      //           image: snapshot.data!,
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                              data['partName'] ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              data['price'] ?? 'No Price',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFAC00),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${data['location'] ?? 'No Location'} • ${data['timestamp']?.toDate().toString().split(' ')[0] ?? 'No Date'}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['description'] ?? 'No Description',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // More Details Button and Delete Button
                            Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFD900),
                                      foregroundColor:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      context.push('/details',
                                          extra:
                                              data); // Pass post data to DetailsPage
                                    },
                                    child: const Text("More Details"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteProduct(doc.id),
                                ),
                              ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/createpost'),
        backgroundColor: const Color(0xFFFFD900),
        child: const Icon(Icons.add),
      ),
    );
  }
}
