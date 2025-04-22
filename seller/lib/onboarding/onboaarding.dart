import 'package:flutter/material.dart';
// Fixed typo in filename

class OnboardingPager extends StatefulWidget {
  @override
  _OnboardingPagerState createState() => _OnboardingPagerState();
}

class _OnboardingPagerState extends State<OnboardingPager> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'title': 'Connection',
      'description':
      'Stay connected with friends and family through high-quality video calls and instant messaging. All in one secure platform.',
      'image': 'assets/images/connections.png',
    },
    {
      'title': 'Upload File',
      'description':
      'Easily upload your documents, photos, and videos directly from your device with fast and secure cloud storage.',
      'image': 'assets/images/up.png',
    },
    {
      'title': 'Share Location',
      'description':
      'Quickly share your live location with others for smooth meetups, enhanced safety, and effortless coordination.',
      'image': 'assets/images/loc.png',
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2F47D6), // Deep blue background
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              final data = onboardingData[index];
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  margin: EdgeInsets.only(top: 60, bottom: 100),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Mobile Apps\n",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text: data['title'],
                                  style: TextStyle(
                                    color: Colors.indigo[900],
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            data['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        data['image'],
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        print('Navigate to main app');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[400],
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      _currentPage < onboardingData.length - 1
                          ? 'Continue'
                          : 'Get Started',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      print('Cancel/Skip');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.red[300] : Colors.grey[300],
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    return List<Widget>.generate(
      onboardingData.length,
          (index) => _indicator(_currentPage == index),
    );
  }
}
