import 'package:flutter/material.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({super.key});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive breakpoints
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    // Make image size slightly smaller for a more refined look
    final imageSize = isMobile ? screenWidth * 0.32 : screenWidth * 0.22;

    // Refined padding for a cleaner look
    final padding = EdgeInsets.symmetric(
      horizontal: isMobile ? screenWidth * 0.04 : screenWidth * 0.06, 
      vertical: isMobile ? screenHeight * 0.03 : screenHeight * 0.05
    );
    
    const textStyle = TextStyle(color: Colors.white);

    return Padding(
      padding: padding,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01, 
          horizontal: isMobile ? 0 : screenWidth * 0.02
        ),
        // Height is determined by content
        child: isMobile 
          // Mobile layout (column)
          ? Column(
          children: [
                // Text Section with refined spacing
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Text(
                      "Hello,", 
                      style: textStyle.copyWith(
                        fontSize: screenWidth * 0.045, 
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      )
                    ),
                    
                    SizedBox(height: screenHeight * 0.01),
                    
                  RichText(
                    text: TextSpan(
                      text: "I'm ",
                        style: textStyle.copyWith(
                          fontSize: screenWidth * 0.065, 
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      children: [
                        TextSpan(
                          text: "Eyad",
                            style: textStyle.copyWith(
                              color: const Color(0xFF8AC24A), 
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                        ),
                      ],
                    ),
                  ),
                    
                    SizedBox(height: screenHeight * 0.01),
                    
                  Text(
                      "an Android Developer", 
                      style: textStyle.copyWith(
                        fontSize: screenWidth * 0.04, 
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      )
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    Container(
                      width: screenWidth * 0.5,
                      child: Text(
                    "\"Your Vision, Our Code - Apps Built for Success.\"",
                        style: textStyle.copyWith(
                          fontSize: screenWidth * 0.03, 
                          fontStyle: FontStyle.italic, 
                          color: Colors.grey.shade400,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
                
                // Refined Profile Image with smooth shadow and border
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8BC34A).withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF8BC34A).withOpacity(0.7),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/chair.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            )
          // Desktop layout (row) with refined spacing
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text Section with improved spacing
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hello,",
                        style: textStyle.copyWith(
                          fontSize: screenWidth * 0.015,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        )
                      ),
                      
                      SizedBox(height: screenHeight * 0.01),

                      RichText(
                        text: TextSpan(
                          text: "I'm ",
                          style: textStyle.copyWith(
                            fontSize: screenWidth * 0.034,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8,
                            height: 1.1,
                          ),
                          children: [
                            TextSpan(
                              text: "Eyad",
                              style: textStyle.copyWith(
                                color: const Color(0xFF8AC24A),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.01),

                      Text(
                        "an Android Developer",
                        style: textStyle.copyWith(
                          fontSize: screenWidth * 0.018,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        )
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      Container(
                        width: screenWidth * 0.3,
                        child: Text(
                          "\"Your Vision, Our Code - Apps Built for Success.\"",
                          style: textStyle.copyWith(
                            fontSize: screenWidth * 0.01,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade400,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacer for improved layout
                Spacer(flex: 1),

                // Refined Profile Image with smooth shadow and border
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8BC34A).withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF8BC34A).withOpacity(0.7),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/chair.png',
                            fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
