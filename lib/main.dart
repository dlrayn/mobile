import 'package:flutter/material.dart';
import 'welcome.dart';
import 'profile.dart';
import 'kategori.dart';
import 'post.dart';
import 'gallery.dart';
import 'foto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RayFusion Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const SplashScreenWrapper(),
      routes: {
        '/profile': (context) => const ProfilePage(),
        '/kategori': (context) => const KategoriPage(),
        '/posts': (context) => const PostPage(),
        '/gallery': (context) => const GalleryPage(),
        '/foto': (context) => const FotoPage(),
      },
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showWelcome = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showWelcome = true);
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _showWelcome
          ? const Welcome()
          : FadeTransition(
              opacity: _animation,
              child: Scaffold(
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.blue.shade50,
                        Colors.blue.shade100,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo dengan animasi scale
                      ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.5,
                          end: 1.0,
                        ).animate(CurvedAnimation(
                          parent: _controller,
                          curve: Curves.elasticOut,
                        )),
                        child: Image.asset(
                          'assets/RayFusion.png',
                          width: 200,
                          height: 200,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Loading indicator dengan animasi fade
                      FadeTransition(
                        opacity: Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(0.5, 1.0),
                        )),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade800),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
