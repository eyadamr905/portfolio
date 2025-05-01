import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;

class ProjectsSection extends StatelessWidget {
   ProjectsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive breakpoints
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    return Container(
      // Dynamic height based on content
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.04,
        horizontal: isMobile ? screenWidth * 0.03 : screenWidth * 0.06,
      ),
      child: Column(
        children: [
          // Section title with refined styling
          Text(
            "Projects",
            style: GoogleFonts.poppins(
              fontSize: isMobile ? screenWidth * 0.055 : screenWidth * 0.035,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
          
          SizedBox(height: screenHeight * 0.01),
          
          // More elegant divider matching about section
          Container(
            width: isMobile ? screenWidth * 0.2 : screenWidth * 0.1,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFF8BC34A).withOpacity(0.7),
                  Colors.transparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // UNDER DEVELOPMENT banner

          
          // Subtitle text with refined styling
          Text(
            "Android & Flutter Applications",
            style: GoogleFonts.poppins(
              fontSize: isMobile ? screenWidth * 0.035 : screenWidth * 0.018,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8BC34A),
              letterSpacing: 0.5,
            ),
          ),
          
          SizedBox(height: screenHeight * 0.03),
          
          // Projects grid with cards
          Container(
            height: screenHeight * 0.6, // Fixed height
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2, // 1 item per row on mobile
                childAspectRatio: isMobile ? 1.6 : 1.7, // More compact cards
                mainAxisSpacing: isMobile ? screenHeight * 0.025 : screenHeight * 0.035,
                crossAxisSpacing: isMobile ? 0 : screenWidth * 0.03,
              ),
              itemCount: projectData.length,
              itemBuilder: (context, index) {
                // Implement lazy loading with builder
                return ProjectCard(
                  projectTitle: projectData[index]['title']!,
                  projectImage: projectData[index]['image']!,
                  projectBrief: projectData[index]['brief']!,
                  projectUrl: projectData[index]['url']!,
                  techStack: projectData[index]['tech']!,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // Project data to enable lazy loading
  final List<Map<String, String>> projectData = [
    {
      'title': 'Jobfiy',
      'image': 'https://cdn-icons-png.flaticon.com/512/2936/2936630.png',
      'brief': 'Job Search and Application Tracker built with Kotlin. Features job search, filters, and application tracking.',
      'url': 'https://github.com/eyadamr905/Jobfiy',
      'tech': 'Kotlin, Jetpack Compose, MVVM, Firebase',
    },
    {
      'title': 'WhatNow News',
      'image': 'https://cdn-icons-png.flaticon.com/512/2965/2965879.png',
      'brief': 'Android News App that provides latest news updates based on categories like politics, sports, and tech.',
      'url': 'https://github.com/eyadamr905/WhatNow-NewsApp',
      'tech': 'Kotlin, MVVM, Retrofit, Firebase',
    },
    {
      'title': 'Speedo Transfer',
      'image': 'https://cdn-icons-png.flaticon.com/512/5501/5501125.png',
      'brief': 'Money transfer application with secure transactions and real-time tracking features.',
      'url': 'https://github.com/eyadamr905/Speedo-Transfer-App',
      'tech': 'Android, Kotlin, APIs, Security',
    },
    {
      'title': 'Signy',
      'image': 'https://cdn-icons-png.flaticon.com/512/6295/6295417.png',
      'brief': 'Sign language translation app that converts ASL to English and English to sign language.',
      'url': 'https://github.com/eyadamr905/Signy_V1.1',
      'tech': 'Flutter, ML, Computer Vision, C++',
    },
  ];
}

class ProjectCard extends StatefulWidget {
  final String projectTitle;
  final String projectImage;
  final String projectBrief;
  final String projectUrl;
  final String techStack;
  final int index;

  const ProjectCard({
    required this.projectTitle,
    required this.projectImage,
    required this.projectBrief,
    required this.projectUrl,
    required this.techStack,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  bool _isHovered = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200), // Faster animation for smoother feel
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 0.05).animate(_animationController); // Subtle scale
    _animationController.addListener(() {
      setState(() {});
    });
    
    // Initialize with visibility set to true (no delay loading)
    _isVisible = true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;

    // If not visible yet, return an empty container with the same dimensions
    if (!_isVisible) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
          _animationController.forward();
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _animationController.reverse();
        });
      },
      child: GestureDetector(
        onTap: () {
          html.window.open(widget.projectUrl, '_blank');
        },
        child: Transform.scale(
          scale: 1 + _animation.value,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF23232D), // Slightly darker for better contrast
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _isHovered 
                    ? const Color(0xFF8BC34A).withOpacity(0.3) 
                    : Colors.black.withOpacity(0.2),
                  spreadRadius: _isHovered ? 2 : 1,
                  blurRadius: _isHovered ? 12 : 8,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: _isHovered 
                  ? const Color(0xFF8BC34A).withOpacity(0.7) 
                  : Colors.white.withOpacity(0.05),
                width: _isHovered ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                // Top section with image and title
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E26),
                      ),
                      child: Row(
                        children: [
                          // Project image with refined styling
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.all(isMobile ? screenWidth * 0.025 : screenWidth * 0.012),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.05),
                                ),
                                padding: EdgeInsets.all(isMobile ? 12 : 10),
                              child: Image.network(
                                widget.projectImage,
                                fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          
                          // Project title and tech stack
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.015),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.projectTitle,
                                    style: GoogleFonts.poppins(
                                      fontSize: isMobile ? screenWidth * 0.04 : screenWidth * 0.016,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  
                                  SizedBox(height: screenHeight * 0.008),
                                  
                                  // Tech stack with smaller text and subtle styling
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8BC34A).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: const Color(0xFF8BC34A).withOpacity(0.3),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                    widget.techStack,
                                    style: GoogleFonts.poppins(
                                        fontSize: isMobile ? screenWidth * 0.022 : screenWidth * 0.009,
                                        color: const Color(0xFF8BC34A).withOpacity(0.9),
                                        letterSpacing: 0.3,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                ),
                
                // Description section
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.projectBrief,
                            style: GoogleFonts.poppins(
                              fontSize: isMobile ? screenWidth * 0.026 : screenWidth * 0.01,
                              color: Colors.white.withOpacity(0.8),
                              height: 1.5,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // Visit button
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(top: screenHeight * 0.01),
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 16 : 10,
                              vertical: isMobile ? 8 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: _isHovered
                                  ? const Color(0xFF8BC34A)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFF8BC34A),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "View Project",
                              style: GoogleFonts.poppins(
                                fontSize: isMobile ? screenWidth * 0.025 : screenWidth * 0.01,
                                color: _isHovered
                                    ? Colors.black
                                    : const Color(0xFF8BC34A),
                              ),
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
      ),
    );
  }
}
