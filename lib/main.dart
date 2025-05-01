import 'package:flutter/material.dart';
import 'sections/home_section.dart';
import 'sections/about_section.dart';
import 'sections/projects_section.dart';
import 'sections/contact_section.dart';
import 'dart:html' as html;
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart'; // For PointerSignal, PointerScrollEvent and PointerDeviceKind

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      // Enable scrolling from anywhere
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            physics: const ClampingScrollPhysics(),
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: child!,
        );
      },
    );
  }
}

// SplashScreen/Preloader
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading time
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Navigate to main page after loading
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
                const PortfolioHomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = 0.0;
              const end = 1.0;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );
              var opacityAnimation = animation.drive(tween);
              return FadeTransition(
                opacity: opacityAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E26),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Android logo as the splash image
            Icon(
              Icons.android,
              size: 100,
              color: const Color(0xFF8BC34A),
            ),
            const SizedBox(height: 20),
            Text(
              "Eyad Amr",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF8BC34A),
                ),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  String _selectedSection = "Home"; // Track the selected section
  double _scrollProgress = 0.0; // Variable to track scroll progress
  
  // Add the section offsets map to track positions for active indicator
  Map<String, double> _sectionOffsets = {
    "Home": 0,
    "About": 0,
    "Projects": 0,
    "Contact": 0,
  };
  
  // Add visibility checking for lazy loading
  bool _isHomeVisible = true;
  bool _isAboutVisible = false;
  bool _isProjectsVisible = false;
  bool _isContactVisible = false;

  void _scrollToSection(GlobalKey key, String section) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
      setState(() {
        _selectedSection = section; // Update selected section
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0, // Scroll to the top
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }
  
  // Method to calculate section visibility for lazy loading
  void _calculateVisibility() {
    final viewportHeight = MediaQuery.of(context).size.height;
    final scrollPosition = _scrollController.position.pixels;
    
    setState(() {
      _isHomeVisible = scrollPosition < _sectionOffsets["About"]! - viewportHeight / 2;
      _isAboutVisible = scrollPosition >= _sectionOffsets["About"]! - viewportHeight / 2 && 
                        scrollPosition < _sectionOffsets["Projects"]! - viewportHeight / 2;
      _isProjectsVisible = scrollPosition >= _sectionOffsets["Projects"]! - viewportHeight / 2 && 
                          scrollPosition < _sectionOffsets["Contact"]! - viewportHeight / 2;
      _isContactVisible = scrollPosition >= _sectionOffsets["Contact"]! - viewportHeight / 2;
      
      // Update selected section based on scroll position
      if (_isHomeVisible) _selectedSection = "Home";
      else if (_isAboutVisible) _selectedSection = "About";
      else if (_isProjectsVisible) _selectedSection = "Projects";
      else if (_isContactVisible) _selectedSection = "Contact";
    });
  }
  
  // Method to calculate section offsets after layout
  void _updateSectionOffsets() {
    final homeContext = _homeKey.currentContext;
    final aboutContext = _aboutKey.currentContext;
    final projectsContext = _projectsKey.currentContext;
    final contactContext = _contactKey.currentContext;
    
    if (homeContext != null && aboutContext != null && 
        projectsContext != null && contactContext != null) {
      setState(() {
        // Get the render box for each section
        final homeBox = homeContext.findRenderObject() as RenderBox;
        final aboutBox = aboutContext.findRenderObject() as RenderBox;
        final projectsBox = projectsContext.findRenderObject() as RenderBox;
        final contactBox = contactContext.findRenderObject() as RenderBox;
        
        // Calculate global positions
        final homePos = homeBox.localToGlobal(Offset.zero);
        final aboutPos = aboutBox.localToGlobal(Offset.zero);
        final projectsPos = projectsBox.localToGlobal(Offset.zero);
        final contactPos = contactBox.localToGlobal(Offset.zero);
        
        // Update offsets
        _sectionOffsets["Home"] = homePos.dy;
        _sectionOffsets["About"] = aboutPos.dy;
        _sectionOffsets["Projects"] = projectsPos.dy;
        _sectionOffsets["Contact"] = contactPos.dy;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Add a listener to track scroll progress
    _scrollController.addListener(() {
      setState(() {
        // Calculate the scroll progress as a percentage
        double progress = _scrollController.offset /
            (_scrollController.position.maxScrollExtent);
        _scrollProgress = progress.clamp(0.0, 1.0); // Clamp the value between 0 and 1
        
        // Update visibility for lazy loading
        _calculateVisibility();
      });
    });
    
    // Schedule a post-frame callback to calculate section offsets
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSectionOffsets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive breakpoints
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    // Calculate container width to make content more compact
    final contentWidth = isDesktop 
        ? screenWidth * 0.8 // 80% of screen width for desktop
        : isTablet 
            ? screenWidth * 0.9 // 90% of screen width for tablet
            : screenWidth * 0.95; // 95% of screen width for mobile

    return GestureDetector(
      // Enable drag anywhere on the screen to scroll
      onVerticalDragUpdate: (details) {
        _scrollController.position.jumpTo(
          _scrollController.position.pixels - details.delta.dy,
        );
      },
      child: Listener(
        // Enable mouse wheel scrolling from anywhere
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            _scrollController.position.jumpTo(
              _scrollController.position.pixels + pointerSignal.scrollDelta.dy,
            );
          }
        },
        child: Scaffold(
      backgroundColor: const Color(0xFF1E1E26), // Dark background
          body: Center(
            child: Container(
              width: contentWidth, // Apply the calculated content width
        height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    height: isMobile ? screenHeight * 0.08 : screenHeight * 0.07, // Slightly smaller app bar
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF282834), // Slightly lighter dark for app bar
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                    child: isMobile 
                      ? _buildMobileAppBar(screenWidth, screenHeight)
                      : _buildDesktopAppBar(screenWidth, screenHeight),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      // Use ClampingScrollPhysics for better scrolling behavior
                      physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSection(_homeKey, const HomeSection()),
                          SizedBox(height: screenHeight * 0.1), // Larger space between sections
                          _buildSection(_aboutKey, const AboutSection()),
                          SizedBox(height: screenHeight * 0.1), // Larger space between sections 
                          _buildSection(_projectsKey, ProjectsSection()),
                          SizedBox(height: screenHeight * 0.1), // Larger space between sections
                          _buildSection(_contactKey, const ContactSection()),
                          SizedBox(height: screenHeight * 0.05), // Add space at bottom for better layout
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 16.0), // Smaller padding
            child: SizedBox(
              width: isMobile ? 50 : 60, // Smaller FAB
              height: isMobile ? 50 : 60,
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: const Color(0xFF282834),
                child: Icon(
                  Icons.arrow_upward,
                  color: const Color(0xFF8BC34A),
                  size: isMobile ? 22 : 26,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Mobile app bar with drawer for navigation
  Widget _buildMobileAppBar(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and name
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Icon(
                  Icons.android,
                  size: screenHeight * 0.035, // Smaller icon
                  color: const Color(0xFF8BC34A),
                ),
              ),
              Text(
                "Eyad Amr",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.035, // Smaller text
                  color: const Color(0xFFE0E0E0),
                ),
              ),
            ],
          ),
          
          // Menu button
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: screenHeight * 0.025, // Smaller icon
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
              
              // Show drawer with navigation
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF282834),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Navigation items
                        ListTile(
                          title: Text(
                            "Home",
                            style: TextStyle(
                              color: _selectedSection == "Home" ? const Color(0xFF8BC34A) : Colors.white,
                              fontWeight: _selectedSection == "Home" ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          leading: Icon(
                            Icons.home,
                            color: _selectedSection == "Home" ? const Color(0xFF8BC34A) : Colors.white,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _scrollToSection(_homeKey, "Home");
                          },
                        ),
                        ListTile(
                          title: Text(
                            "About",
                            style: TextStyle(
                              color: _selectedSection == "About" ? const Color(0xFF8BC34A) : Colors.white,
                              fontWeight: _selectedSection == "About" ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          leading: Icon(
                            Icons.person,
                            color: _selectedSection == "About" ? const Color(0xFF8BC34A) : Colors.white,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _scrollToSection(_aboutKey, "About");
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Projects",
                            style: TextStyle(
                              color: _selectedSection == "Projects" ? const Color(0xFF8BC34A) : Colors.white,
                              fontWeight: _selectedSection == "Projects" ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          leading: Icon(
                            Icons.code,
                            color: _selectedSection == "Projects" ? const Color(0xFF8BC34A) : Colors.white,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _scrollToSection(_projectsKey, "Projects");
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Contact",
                            style: TextStyle(
                              color: _selectedSection == "Contact" ? const Color(0xFF8BC34A) : Colors.white,
                              fontWeight: _selectedSection == "Contact" ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          leading: Icon(
                            Icons.mail,
                            color: _selectedSection == "Contact" ? const Color(0xFF8BC34A) : Colors.white,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _scrollToSection(_contactKey, "Contact");
                          },
                        ),
                        
                        Divider(color: Colors.white.withOpacity(0.2)),
                        
                        // Social media links
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildSocialLink(
                                icon: Icons.email,
                                url: 'mailto:eyadamro905@gmail.com',
                                screenHeight: screenHeight,
                                color: const Color(0xFFDB4437),
                              ),
                              _buildSocialLink(
                                icon: Icons.code,
                                url: 'https://github.com/eyadamr905?tab=repositories',
                                screenHeight: screenHeight,
                                color: const Color(0xFFE0E0E0),
                              ),
                              _buildSocialLink(
                                icon: Icons.work,
                                url: 'https://www.linkedin.com/in/eyad-amr/',
                                screenHeight: screenHeight,
                                color: const Color(0xFF0077B5),
                              ),
                              _buildSocialLink(
                                icon: Icons.facebook,
                                url: 'https://www.facebook.com/profile.php?id=100009136631108',
                                screenHeight: screenHeight,
                                color: const Color(0xFF1877F2),
                              ),
                              _buildSocialLink(
                                icon: Icons.camera_alt,
                                url: 'https://www.instagram.com/eyad3mr12/',
                                screenHeight: screenHeight,
                                color: const Color(0xFFE1306C),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
  
  // Desktop app bar
  Widget _buildDesktopAppBar(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03), // Less padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo and name section
                        Row(
                          children: [
                            // Android icon replacing the logo image
                            Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.005),
                              child: Icon(
                                Icons.android,
                  size: screenHeight * 0.04, // Smaller icon
                                color: const Color(0xFF8BC34A), // Android green color
                              ),
                            ),
              SizedBox(width: screenWidth * 0.005),
                            // Name with reduced text size
                            Text(
                              "Eyad Amr",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.012, // Smaller text
                                color: const Color(0xFFE0E0E0), // Light gray for text
                              ),
                            ),
              SizedBox(width: screenWidth * 0.015),
                            // Download CV button
                            InkWell(
                              onTap: () async {
                                // For web: Create an anchor element to download the PDF
                                final anchor = html.AnchorElement(
                                  href: 'assets/EyadAmrResume.pdf',
                                )
                                  ..setAttribute('download', 'EyadAmrResume.pdf')
                                  ..click();
                              },
                              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: 4), // Smaller padding
                                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF8BC34A), width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.download_rounded,
                        size: screenHeight * 0.018, // Smaller icon
                                      color: const Color(0xFF8BC34A),
                                    ),
                      SizedBox(width: screenWidth * 0.003),
                                    Text(
                                      "Download CV",
                                      style: TextStyle(
                          fontSize: screenWidth * 0.01, // Smaller text
                                        color: const Color(0xFF8BC34A),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // Navigation items with proper spacing
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
              _buildNavItem(context, "Home", screenWidth, _homeKey, screenWidth * 0.012, false), // Smaller text
              SizedBox(width: screenWidth * 0.03), // Less spacing
              _buildNavItem(context, "About", screenWidth, _aboutKey, screenWidth * 0.012, false),
              SizedBox(width: screenWidth * 0.03),
              _buildNavItem(context, "Projects", screenWidth, _projectsKey, screenWidth * 0.012, false),
              SizedBox(width: screenWidth * 0.03),
              _buildNavItem(context, "Contact", screenWidth, _contactKey, screenWidth * 0.012, true),
            ],
          ),
          
          // Social media links
          Row(
                      children: [
              _buildSocialLink(
                icon: Icons.email,
                url: 'mailto:eyadamro905@gmail.com',
                screenHeight: screenHeight,
                color: const Color(0xFFDB4437),
              ),
              SizedBox(width: screenWidth * 0.008), // Less spacing
              _buildSocialLink(
                icon: Icons.code,
                url: 'https://github.com/eyadamr905?tab=repositories',
                screenHeight: screenHeight,
                color: const Color(0xFFE0E0E0),
              ),
              SizedBox(width: screenWidth * 0.008),
              _buildSocialLink(
                icon: Icons.work,
                url: 'https://www.linkedin.com/in/eyad-amr/',
                screenHeight: screenHeight,
                color: const Color(0xFF0077B5),
              ),
              SizedBox(width: screenWidth * 0.008),
              _buildSocialLink(
                icon: Icons.facebook,
                url: 'https://www.facebook.com/profile.php?id=100009136631108',
                screenHeight: screenHeight,
                color: const Color(0xFF1877F2),
              ),
              SizedBox(width: screenWidth * 0.008),
              _buildSocialLink(
                icon: Icons.camera_alt,
                url: 'https://www.instagram.com/eyad3mr12/',
                screenHeight: screenHeight,
                color: const Color(0xFFE1306C),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method for building nav items with underline animation
  Widget _buildNavItem(BuildContext context, String title, double screenWidth, GlobalKey key, double textSize, bool isHighlighted) {
    bool isSelected = _selectedSection == title;

    if (isHighlighted) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.008), // Less padding
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015, vertical: 6), // Smaller padding
          decoration: BoxDecoration(
            color: const Color(0xFF5D7D9A), // Muted blue for highlighted button
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5D7D9A).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _scrollToSection(key, title),
            child: Text(
              title,
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.008),
      child: InkWell(
        onTap: () => _scrollToSection(key, title),
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: textSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: const Color(0xFFB8B8B8), // Light gray for text
              ),
            ),
            // Underline animation for non-highlighted items
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSelected ? screenWidth * 0.025 : 0, // Smaller underline
              height: 2,
              color: const Color(0xFF7D9D9C), // Soft teal accent color
              margin: const EdgeInsets.only(top: 2),
            ),
          ],
        ),
      ),
    );
  }

  // Method for building each section
  Widget _buildSection(GlobalKey key, Widget child) {
    return Container(
      key: key,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20), // Added vertical margin
      child: child,
    );
  }

  // Method for building social media links
  Widget _buildSocialLink({
    required IconData icon,
    required String url,
    required double screenHeight,
    required Color color,
  }) {
    return InkWell(
      onTap: () => html.window.open(url, '_blank'),
      child: Icon(
        icon,
        size: screenHeight * 0.025, // Smaller icon
        color: color,
      ),
    );
  }
}
