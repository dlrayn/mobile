import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class FotoPage extends StatefulWidget {
  const FotoPage({super.key});

  @override
  State<FotoPage> createState() => _FotoPageState();
}

class _FotoPageState extends State<FotoPage> {
  late Future<List<dynamic>> fotoItems;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _galeryIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fotoItems = fetchFotoItems();
  }

  Future<List<dynamic>> fetchFotoItems() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/foto'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> createFoto(String judul, String galeryId, Uint8List imageBytes, String fileName) async {
    try {
      var uri = Uri.parse('http://127.0.0.1:8000/api/foto/create');
      var request = http.MultipartRequest('POST', uri);
      
      request.fields['judul'] = judul;
      request.fields['galery_id'] = galeryId;
      
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: fileName,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        setState(() {
          fotoItems = fetchFotoItems();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto berhasil ditambahkan')),
          );
        }
      } else {
        throw Exception('Gagal menambahkan foto');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> updateFoto(int id, String judul, String galeryId, {Uint8List? imageBytes, String? fileName}) async {
    try {
      var uri = Uri.parse('http://127.0.0.1:8000/api/foto/$id');
      var request = http.MultipartRequest('POST', uri);
      
      request.fields['_method'] = 'PUT';
      request.fields['judul'] = judul;
      request.fields['galery_id'] = galeryId;
      
      if (imageBytes != null && fileName != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: fileName,
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          fotoItems = fetchFotoItems();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto berhasil diupdate')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengupdate foto')),
        );
      }
    }
  }

  Future<void> deleteFoto(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/foto/$id'),
      );

      if (response.statusCode == 200) {
        setState(() {
          fotoItems = fetchFotoItems();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto berhasil dihapus')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus foto')),
        );
      }
    }
  }

  Future<void> _showAddDialog() async {
    _judulController.clear();
    _galeryIdController.clear();
    Uint8List? imageBytes;
    String? fileName;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Foto Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: _galeryIdController,
                decoration: const InputDecoration(labelText: 'Gallery ID'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    imageBytes = await image.readAsBytes();
                    fileName = image.name;
                    setState(() {});
                  }
                },
                child: const Text('Pilih Gambar'),
              ),
              if (imageBytes != null)
                const Text('Gambar telah dipilih', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_judulController.text.isNotEmpty &&
                  _galeryIdController.text.isNotEmpty &&
                  imageBytes != null &&
                  fileName != null) {
                createFoto(
                  _judulController.text,
                  _galeryIdController.text,
                  imageBytes!,
                  fileName!,
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Harap isi semua field dan pilih gambar')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(Map<String, dynamic> item) async {
    _judulController.text = item['judul'];
    _galeryIdController.text = item['galery_id'].toString();
    Uint8List? imageBytes;
    String? fileName;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Foto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: _galeryIdController,
                decoration: const InputDecoration(labelText: 'Gallery ID'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    imageBytes = await image.readAsBytes();
                    fileName = image.name;
                    setState(() {});
                  }
                },
                child: const Text('Pilih Gambar Baru'),
              ),
              if (imageBytes != null)
                const Text('Gambar baru telah dipilih', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_judulController.text.isNotEmpty &&
                  _galeryIdController.text.isNotEmpty) {
                updateFoto(
                  item['id'],
                  _judulController.text,
                  _galeryIdController.text,
                  imageBytes: imageBytes,
                  fileName: fileName,
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Harap isi semua field')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(int id) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus foto ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              deleteFoto(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto'),
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
        child: FutureBuilder<List<dynamic>>(
          future: fotoItems,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada data'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          item['judul'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        subtitle: Text(
                          'Gallery ID: ${item['galery_id'] ?? ''}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditDialog(item),
                              color: Colors.blue,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _showDeleteConfirmation(item['id']),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      if (item['file'] != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'http://127.0.0.1:8000/storage/${item['file']}',
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Text('Gambar tidak tersedia'),
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
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _galeryIdController.dispose();
    super.dispose();
  }
}