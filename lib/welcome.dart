import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'package:transparent_image/transparent_image.dart' as transparent;

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Map<String, dynamic> profileData = {};
  Map<String, dynamic> kategoriData = {};
  Map<String, dynamic> postsData = {};
  Map<String, dynamic> galeryData = {};
  Map<String, dynamic> fotoData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final profileResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final kategoriResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/kategori'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final postsResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final galeryResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/galery'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final fotoResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/foto'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (mounted) {
        setState(() {
          if (profileResponse.statusCode == 200) {
            profileData = json.decode(profileResponse.body);
          }
          if (kategoriResponse.statusCode == 200) {
            kategoriData = json.decode(kategoriResponse.body);
          }
          if (postsResponse.statusCode == 200) {
            postsData = json.decode(postsResponse.body);
          }
          if (galeryResponse.statusCode == 200) {
            galeryData = json.decode(galeryResponse.body);
          }
          if (fotoResponse.statusCode == 200) {
            fotoData = json.decode(fotoResponse.body);
            debugPrint('Foto Response: ${fotoResponse.body}');
            
            if (fotoData['data'] != null) {
              for (var photo in fotoData['data']) {
                debugPrint('Photo URL: ${photo['file']}');
              }
            }
          }
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 40),
            const SizedBox(width: 8),
            const Text('SMK Negeri 4 Bogor', 
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[600]!, Colors.blue[800]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/lapang.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Optional: Add a semi-transparent overlay
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome to SMK Negeri 4 Bogor',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Your Future Starts Here',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24, 
                                  vertical: 12
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Get Started'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Scroll to profile section
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24, 
                                  vertical: 12
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Learn More'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Profile Section
                if (profileData.isNotEmpty && profileData['data'] != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profile Sekolah',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...List.generate(
                          (profileData['data'] as List).length,
                          (index) {
                            final profile = profileData['data'][index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile['judul'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    profile['isi'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                // Kategori Section
                if (kategoriData.isNotEmpty && kategoriData['data'] != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (kategoriData['data'] as List).length,
                          itemBuilder: (context, index) {
                            final kategori = kategoriData['data'][index];
                            // Ambil posts yang terkait dengan kategori ini
                            final relatedPosts = _getPostsByKategori(kategori['id']);
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 15),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ExpansionTile(
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.category,
                                      color: Colors.blue[600],
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            kategori['judul'] ?? 'No Title',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${relatedPosts.length} posts',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  if (relatedPosts.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text('Tidak ada post dalam kategori ini'),
                                    )
                                  else
                                    ...relatedPosts.map((post) => ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      leading: Icon(
                                        Icons.article,
                                        color: Colors.blue[400],
                                      ),
                                      title: Text(
                                        post['judul'] ?? 'No Title',
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post['isi'] ?? 'No Content',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatDate(post['created_at'] ?? ''),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )).toList(),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                // Posts Section
                if (postsData.isNotEmpty && postsData['data'] != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Terkini',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (postsData['data'] as List).length,
                          itemBuilder: (context, index) {
                            final post = postsData['data'][index];
                            final relatedGaleries = _getGaleriesByKategoriId(post['kategori_id']);
                            final allRelatedPhotos = _getAllPhotosByGaleries(relatedGaleries);
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 15),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Post Header with Featured Image
                                  if (allRelatedPhotos.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        'http://127.0.0.1:8000/storage/${allRelatedPhotos.first['file']}',
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                  // Post Content
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post['judul'] ?? 'No Title',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          post['isi'] ?? 'No Content',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            height: 1.5,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Photo Gallery
                                  if (allRelatedPhotos.length > 1)
                                    Container(
                                      height: 100,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: allRelatedPhotos.length,
                                        itemBuilder: (context, photoIndex) {
                                          final photo = allRelatedPhotos[photoIndex];
                                          return Container(
                                            width: 100,
                                            margin: const EdgeInsets.only(right: 8),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                'http://127.0.0.1:8000/storage/${photo['file']}',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                  // Post Footer
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Kategori: ${_getKategoriName(post['kategori_id'])}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          _formatDate(post['created_at'] ?? ''),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                // Photo Gallery Section
                if (fotoData.isNotEmpty && fotoData['data'] != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gallery Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Photo Gallery',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${(fotoData['data'] as List).length} Photos',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Gallery Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: (fotoData['data'] as List).length,
                          itemBuilder: (context, index) {
                            try {
                              final photo = fotoData['data'][index];
                              final uri = Uri(
                                scheme: 'http',
                                host: '127.0.0.1',
                                port: 8000,
                                path: '/storage/fotos/${photo['file']}',
                              ).toString();

                              return Hero(
                                tag: 'photo_$index',
                                child: GestureDetector(
                                  onTap: () {
                                    // Tampilkan gambar dalam mode fullscreen saat di tap
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Stack(
                                          children: [
                                            InteractiveViewer(
                                              child: Image.network(
                                                uri,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          FadeInImage.memoryNetwork(
                                            placeholder: transparent.kTransparentImage,
                                            image: 'http://127.0.0.1:8000/storage/${photo['file']}',
                                            fit: BoxFit.cover,
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              // Try to fetch and display alternative image from API
                                              return FutureBuilder(
                                                future: http.get(
                                                  Uri.parse('http://127.0.0.1:8000/api/foto'),
                                                  headers: {
                                                    'Content-Type': 'application/json',
                                                    'Accept': 'application/json',
                                                  },
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData && snapshot.data != null) {
                                                    final photoData = json.decode(snapshot.data!.body);
                                                    if (photoData['data'] != null && photoData['data'].isNotEmpty) {
                                                      // Display first available photo as fallback
                                                      return Image.network(
                                                        'http://127.0.0.1:8000/storage/${photoData['data'][0]['file']}',
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          // If all else fails, show default error UI
                                                          return Container(
                                                            color: Colors.grey[200],
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(
                                                                  Icons.broken_image,
                                                                  color: Colors.grey[400],
                                                                  size: 40,
                                                                ),
                                                                const SizedBox(height: 8),
                                                                Text(
                                                                  'Image unavailable',
                                                                  style: TextStyle(
                                                                    color: Colors.grey[600],
                                                                    fontSize: 12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }
                                                  // Show loading indicator while fetching
                                                  return const Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          // Overlay gradient
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.black.withOpacity(0.3),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Zoom icon indicator
                                          Positioned(
                                            right: 8,
                                            bottom: 8,
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.9),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: const Icon(
                                                Icons.zoom_in,
                                                size: 20,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } catch (e) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
    );
  }

  // Helper methods
  String _getKategoriName(dynamic kategoriId) {
    if (kategoriData.isNotEmpty && kategoriData['data'] != null) {
      final kategori = (kategoriData['data'] as List).firstWhere(
        (k) => k['id'].toString() == kategoriId.toString(),
        orElse: () => null,
      );
      return kategori != null ? kategori['judul'] : 'Uncategorized';
    }
    return 'Uncategorized';
  }

  String _formatDate(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  List<dynamic> _getPostsByKategori(dynamic kategoriId) {
    if (postsData.isNotEmpty && postsData['data'] != null) {
      return (postsData['data'] as List)
          .where((post) => post['kategori_id'].toString() == kategoriId.toString())
          .toList();
    }
    return [];
  }

  List<dynamic> _getGaleriesByKategoriId(dynamic kategoriId) {
    if (galeryData.isNotEmpty && galeryData['data'] != null) {
      return (galeryData['data'] as List)
          .where((galeri) => 
            galeri['kategori_id'].toString() == kategoriId.toString()
          )
          .toList();
    }
    return [];
  }

  List<dynamic> _getFotosByGaleryId(dynamic galeryId) {
    if (galeryId != null && fotoData.isNotEmpty && fotoData['data'] != null) {
      return (fotoData['data'] as List)
          .where((foto) => foto['galery_id'].toString() == galeryId.toString())
          .toList();
    }
    return [];
  }

  List<dynamic> _getAllPhotosByGaleries(List<dynamic> galleries) {
    List<dynamic> allPhotos = [];
    for (var gallery in galleries) {
      final photos = _getFotosByGaleryId(gallery['id']);
      allPhotos.addAll(photos);
    }
    return allPhotos;
  }

  // Helper methods untuk UI components
  Widget _buildErrorContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildLoadingContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class PhotoGallerySection extends StatefulWidget {
  @override
  _PhotoGallerySectionState createState() => _PhotoGallerySectionState();
}

class _PhotoGallerySectionState extends State<PhotoGallerySection> {
  late Future<List<dynamic>> galleryItems;

  Future<List<dynamic>> fetchGalleryItems() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/foto'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load gallery items');
      }
    } catch (e) {
      print('Error fetching gallery items: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    galleryItems = fetchGalleryItems();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Photo Gallery',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300, // Tinggi container untuk gallery
            child: FutureBuilder<List<dynamic>>(
              future: galleryItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada foto'));
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.only(right: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Container(
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gambar
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  'http://127.0.0.1:8000/storage/${item['file']}',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(Icons.error_outline),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Informasi
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['judul'] ?? 'Tanpa Judul',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (item['galery'] != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        item['galery']['status'] ?? 'No Status',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}