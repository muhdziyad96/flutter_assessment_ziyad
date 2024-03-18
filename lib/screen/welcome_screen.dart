import 'package:flutter/material.dart';
import 'package:flutter_assessment_ziyad/constant/color.dart';
import 'package:flutter_assessment_ziyad/util/preference.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = PageController();
  bool _isLastPage = false;
  bool _isFirstPage = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState((() {
            _isLastPage = index == 3;
            _isFirstPage = index == 0;
          }));
        },
        children: [
          body('Your Destination for Effortless Shopping',
              'At EazyMart, we believe that shopping should be simple, straightforward, and enjoyable. Say goodbye to long queues, complicated checkout processes, and endless browsing. With EazyMart, your shopping experience is just a few clicks away.'),
          body('Get Started Today',
              'Ready to experience the ease of shopping with EazyMart? Sign up now and start exploring our extensive collection of products. Whether you`re stocking up on essentials or treating yourself to something special, EazyMart is here to make your shopping experience hassle-free.'),
          body('Join the EazyMart Community',
              'Follow us on social media and stay updated on the latest deals, promotions, and product launches. Join our growing community of satisfied shoppers and make EazyMart your go-to destination for all your shopping needs.'),
          body('Why Choose EazyMart?',
              'Simplicity: We`ve designed our platform to be intuitive and user-friendly, ensuring that you can find what you need without any hassle. \n\nConvenience: Shop anytime, anywhere, with our mobile-friendly app. Whether you`re at home, at work, or on the go, EazyMart is always at your fingertips.\n\nWide Selection: Discover a vast range of products from top brands across various categories. From groceries to electronics, we`ve got you covered.\n\nFast Delivery: Get your purchases delivered straight to your doorstep in no time. With our efficient logistics network, you can enjoy speedy delivery without any delays.'),
        ],
      ),
      bottomSheet: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _isFirstPage
                ? Padding(
                    padding: EdgeInsets.all(4.2.w),
                    child: TextButton(
                      onPressed: () {
                        _controller.animateToPage(4,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(4.2.w),
                    child: TextButton(
                      onPressed: () {
                        _controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
            Center(
              child: SmoothPageIndicator(
                count: 4,
                controller: _controller,
                effect: const WormEffect(
                    spacing: 16,
                    radius: 10,
                    dotHeight: 10,
                    dotWidth: 10,
                    dotColor: greyLess,
                    activeDotColor: primaryColor),
                onDotClicked: (index) => _controller.animateToPage(
                  index,
                  duration: const Duration(microseconds: 500),
                  curve: Curves.easeIn,
                ),
              ),
            ),
            _isLastPage
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.3.w),
                    child: TextButton(
                      onPressed: () {
                        Preference.setBool(Preference.showOnboard, false);
                        Get.offNamed('/login');
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.3.w),
                    child: TextButton(
                      onPressed: () {
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget body(String text1, String text2) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text1,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.5.h),
              Text(
                text2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
