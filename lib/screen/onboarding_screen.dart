import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Rent with Confidence.',
      'highlight': 'Explore Freely.',
      'description': 'Temukan barang yang kamu butuhkan dan nikmati kemudahan menyewa kapan saja.',
      'image':
          'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=1000',
    },
    {
      'title': 'Share What You Own.',
      'highlight': 'Earn More.',
      'description': 'Ubah barang yang jarang digunakan menjadi peluang penghasilan tambahan.',
      'image':
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=1000',
    },
    {
      'title': 'Everything You Need.',
      'highlight': 'Just a Rental Away.',
      'description': 'Sewa berbagai barang dengan proses yang mudah dan praktis melalui RentMate.',
      'image':
          'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=1000',
    },
  ];

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GetStartedPage()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              // Bagian foto dan logo
              Expanded(
                flex: 7,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingImage(
                      image: onboardingData[index]['image']!,
                    );
                  },
                ),
              ),

              // Bagian tulisan dan tombol
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),

                      Text(
                        onboardingData[currentPage]['title']!,
                        style: const TextStyle(
                          fontSize: 27,
                          height: 1.1,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF171717),
                        ),
                      ),

                      Text(
                        onboardingData[currentPage]['highlight']!,
                        style: const TextStyle(
                          fontSize: 27,
                          height: 1.1,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF8A00),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        onboardingData[currentPage]['description']!,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: Color(0xFF777777),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Indikator halaman
                      Row(
                        children: List.generate(
                          onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 6),
                            width: currentPage == index ? 17 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? const Color(0xFFFF8A00)
                                  : const Color(0xFFD8D8D8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Tombol navigasi
                      SizedBox(
                        width: double.infinity,
                        height: 49,
                        child: ElevatedButton(
                          onPressed: nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF111111),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 30),
                              Text(
                                currentPage == onboardingData.length - 1
                                    ? 'Get Started'
                                    : 'Continue',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(Icons.arrow_forward, size: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tampilan foto dengan bentuk lengkungan
class OnboardingImage extends StatelessWidget {
  final String image;

  const OnboardingImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipPath(
          clipper: ImageCurveClipper(),
          child: Image.network(
            image,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;

              return Container(
                color: const Color(0xFFF1F1F1),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF8A00)),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFFFF3E8),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 55,
                    color: Color(0xFFFF8A00),
                  ),
                ),
              );
            },
          ),
        ),

        // Logo RentMate
        Positioned(
          top: 28,
          left: 22,
          child: Row(
            children: [
              const Icon(
                Icons.home_work_rounded,
                color: Color(0xFFFF8A00),
                size: 30,
              ),
              const SizedBox(width: 7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'RentMate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF171717),
                    ),
                  ),
                  Text(
                    'Rent Anything. Explore More.',
                    style: TextStyle(fontSize: 8, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Membentuk bagian bawah foto menjadi melengkung
class ImageCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.78);

    path.cubicTo(
      size.width * 0.28,
      size.height * 0.68,
      size.width * 0.60,
      size.height * 0.95,
      size.width,
      size.height * 0.76,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Halaman sementara setelah onboarding
class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home_work_rounded,
              color: Color(0xFFFF8A00),
              size: 65,
            ),
            const SizedBox(height: 15),
            const Text(
              'Welcome to RentMate!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your rental journey starts here.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
