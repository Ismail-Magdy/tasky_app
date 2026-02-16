import 'package:flutter/material.dart';
import '../../../core/utils/app_assets.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": AppAssets.onboard1,
      "title": "Manage your tasks",
      "desc": "You can easily manage all of your daily tasks in DoMe for free",
    },
    {
      "image": AppAssets.onboard2,
      "title": "Create daily routine",
      "desc":
          "In Tasky you can create your personalized routine to stay productive",
    },
    {
      "image": AppAssets.onboard3,
      "title": "Organize your tasks",
      "desc":
          "You can organize your daily tasks by adding your tasks into separate categories",
    },
  ];

  void nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: .center,
            children: [
              const SizedBox(height: 40),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: .center,
                      children: [
                        Image.asset(
                          onboardingData[index]["image"]!,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: .center,
                          children: List.generate(
                            onboardingData.length,
                            (i) => buildDot(i),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          onboardingData[index]["title"]!,
                          style: const TextStyle(
                            color: Color(0xff24252C),
                            fontSize: 32,
                            fontWeight: .bold,
                          ),
                          textAlign: .center,
                        ),
                        const SizedBox(height: 42),
                        Padding(
                          padding: const .symmetric(horizontal: 10),
                          child: Text(
                            onboardingData[index]["desc"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: .w400,
                              color: Color(0xff6E6A7C),
                              height: 1.6,
                            ),
                            textAlign: .center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Align(
                alignment: .centerRight,
                child: Container(
                  margin: const .only(bottom: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5F33E1),
                      elevation: 4,
                      padding: const .symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(10),
                      ),
                    ),
                    onPressed: nextPage,
                    child: Text(
                      currentIndex == onboardingData.length - 1
                          ? "GET STARTED"
                          : "NEXT",
                      style: const TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 16,
                        fontWeight: .bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const .symmetric(horizontal: 5),
      height: 8,
      width: currentIndex == index ? 26 : 8,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? const Color(0xff5F33E1)
            : Colors.grey.shade300,
        borderRadius: .circular(20),
      ),
    );
  }
}
