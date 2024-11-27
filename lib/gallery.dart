import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<dynamic> galleries = [];
  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGalleries();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/posts'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          posts = jsonResponse['data'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching posts: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> fetchGalleries() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/galery'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          setState(() {
            galleries = jsonResponse['data'];
            isLoading = false;
          });
        }
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> createGallery(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/galery'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          setState(() {
            fetchGalleries();
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Galeri berhasil ditambahkan')),
            );
          }
        }
      } else {
        throw Exception('Gagal menambahkan galeri');
      }
    } catch (e) {
      print('Error creating gallery: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan galeri: $e')),
        );
      }
    }
  }

  Future<void> showGalleryDetails(int id) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/galery/$id'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Detail Galery'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Post: ${jsonResponse['data']['post']['judul']}'),
                      Text('Position: ${jsonResponse['data']['position']}'),
                      Text('Status: ${jsonResponse['data']['status']}'),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            );
          }
        }
      } else {
        throw Exception('Galery tidak ditemukan');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> updateGallery(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/galery/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          setState(() {
            fetchGalleries();
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Galeri berhasil diupdate')),
            );
          }
        }
      } else {
        throw Exception('Gagal mengupdate galeri');
      }
    } catch (e) {
      print('Error updating gallery: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengupdate galeri: $e')),
        );
      }
    }
  }

  Future<void> deleteGallery(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/galery/$id'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          fetchGalleries();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Galery berhasil dihapus')),
            );
          }
        }
      } else {
        throw Exception('Galery tidak ditemukan');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus galery: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : galleries.isEmpty
                ? Center(
                    child: Text(
                      'No galleries found',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: galleries.length,
                    itemBuilder: (context, index) {
                      final gallery = galleries[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            'Post ID: ${gallery['post_id']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                'Position: ${gallery['position']}',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              Text(
                                'Status: ${gallery['status']}',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              if (gallery['post'] != null)
                                Text(
                                  'Post Title: ${gallery['post']['judul']}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Colors.blue.shade800),
                                onPressed: () =>
                                    showGalleryDetails(gallery['id']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () => deleteGallery(gallery['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your create gallery dialog here
        },
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
} 