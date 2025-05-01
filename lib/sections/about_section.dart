import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For better font styles
import 'package:flutter/services.dart'; // For asset loading
import 'package:path_provider/path_provider.dart'; // To get the temporary directory
import 'dart:io'; // For file operations
import 'package:permission_handler/permission_handler.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive breakpoints
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    return Container(
      width: double.infinity,
      // Let content determine height
      margin: EdgeInsets.only(
        top: screenHeight * 0.04,
        bottom: screenHeight * 0.04,
      ),
      child: SingleChildScrollView( // Wrap in SingleChildScrollView to prevent overflow
        child: Column(
          children: [
            // About Me Section
            Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.06),
              width: isMobile ? screenWidth * 0.85 : screenWidth * 0.7,
              child: Column(
                children: [
                  // Section title with refined styling
                  Text(
                    "About Me",
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? screenWidth * 0.055 : screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  // Elegant divider
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

                  SizedBox(height: screenHeight * 0.03),

                  // About text paragraph
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23232D),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Hello, I'm Eyad Amr, an Android Developer passionate about creating beautiful, functional mobile applications.",
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? screenWidth * 0.035 : screenWidth * 0.016,
                            color: Colors.white,
                            height: 1.6,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        Text(
                          "With expertise in Android, Kotlin, Java, and Flutter, I specialize in developing responsive and intuitive user interfaces, implementing complex application logic, and integrating with various APIs and services. Throughout my journey, I've successfully delivered multiple projects that focus on performance, scalability, and excellent user experience.",
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? screenWidth * 0.033 : screenWidth * 0.014,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.6,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.justify,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        Text(
                          "I'm constantly learning new technologies and approaches to stay at the forefront of mobile development.",
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? screenWidth * 0.033 : screenWidth * 0.014,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.6,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Skills Section title with refined styling
            Text(
              "Skills",
              style: GoogleFonts.poppins(
                fontSize: isMobile ? screenWidth * 0.055 : screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // More elegant divider
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

            // Subtitle text with refined styling
            Text(
              "Welcome to My Skillbook",
              style: GoogleFonts.poppins(
                fontSize: isMobile ? screenWidth * 0.035 : screenWidth * 0.018,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8BC34A),
                letterSpacing: 0.5,
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // Skills grid with enhanced styling to match the reference image
            Container(
              height: isMobile ? screenHeight * 0.45 : screenHeight * 0.4, // Increased height to fix overflow
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? screenWidth * 0.04 : screenWidth * 0.1),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Adjust crossAxisCount based on screen width
                    final crossAxisCount = isMobile ? 3 : 7; // 3 items per row on mobile, 7 on desktop

                    return GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.9, // Adjusted to prevent overflow
                      mainAxisSpacing: screenHeight * 0.05, // Increased spacing
                      crossAxisSpacing: screenWidth * 0.015,
                      children: [
                        _buildSkillItem(context, Icons.android, "Android", const Color(0xFF8BC34A)),
                        _buildSkillItem(context, Icons.flutter_dash, "Flutter", const Color(0xFF54C5F8)),
                        _buildSkillItem(context, Icons.code, "Java", const Color(0xFFE76F00)),
                        _buildSkillItem(context, Icons.language, "Kotlin", const Color(0xFF7F52FF)),
                        _buildSkillItem(context, Icons.sports_basketball, "Jetpack", const Color(0xFF3DDC84)),
                        _buildSkillItem(context, Icons.local_fire_department, "Firebase", const Color(0xFFFFA000)),
                        _buildSkillItem(context, Icons.design_services, "UI/UX", const Color(0xFFFF5252)),

                        // Second row
                        _buildSkillItem(context, Icons.cloud, "REST APIs", const Color(0xFF2196F3)),
                        _buildSkillItem(context, Icons.storage, "SQL", const Color(0xFF03A9F4)),
                        _buildSkillItem(context, Icons.phone_android, "Material", const Color(0xFF9C27B0)),
                        _buildSkillItem(context, Icons.developer_mode, "Git", const Color(0xFFF05032)),
                        _buildSkillItem(context, Icons.verified, "Testing", const Color(0xFF4CAF50)),
                        _buildSkillItem(context, Icons.auto_fix_high, "Compose", const Color(0xFF039BE5)),
                        _buildSkillItem(context, Icons.data_object, "JSON", const Color(0xFFFF9800)),
                      ],
                    );
                  }
                ),
              ),
            ),

            // Construction zone banner at the bottom
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillItem(BuildContext context, IconData icon, String skillName, Color iconColor) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Enhanced skill icon with more pronounced glow to match reference image
        Container(
          width: isMobile ? screenWidth * 0.11 : screenWidth * 0.055,
          height: isMobile ? screenWidth * 0.11 : screenWidth * 0.055,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF23232D),
              shape: BoxShape.circle,
              border: Border.all(
                color: iconColor.withOpacity(0.8),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              size: isMobile ? screenWidth * 0.055 : screenWidth * 0.028,
              color: iconColor,
            ),
          ),
        ),

        SizedBox(height: isMobile ? screenWidth * 0.02 : screenWidth * 0.01),

        // Skill name with refined text styling
        Text(
          skillName,
          style: GoogleFonts.poppins(
            fontSize: isMobile ? screenWidth * 0.028 : screenWidth * 0.011,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Method to download the CV
  Future<void> _downloadCV(BuildContext context) async {
    bool hasPermission = await requestStoragePermission();

    if (!hasPermission) {
      print("Permission denied, cannot download the file.");
      return;
    }

    try {
      final dir = await getExternalStorageDirectory(); // Get external storage directory
      final filePath = '${dir!.path}/EyadAmrResume.pdf';

      print("Saving PDF to: $filePath"); // Log the file path

      // Load the PDF file from assets
      final byteData = await rootBundle.load('assets/EyadAmrResume.pdf');
      final buffer = byteData.buffer.asUint8List();

      // Write the PDF file to the external directory
      final file = File(filePath);
      await file.writeAsBytes(buffer);

      print("CV downloaded successfully"); // Log successful save

      // Optionally, show a snackbar or toast to notify the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CV downloaded')));
    } catch (e) {
      print("Error downloading CV: $e");
    }
  }
}

// Function to request storage permissions
Future<bool> requestStoragePermission() async {
  PermissionStatus status = await Permission.storage.request();

  // Check if the permission is granted
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    // Handle the case where the permission is denied
    return false;
  } else if (status.isPermanentlyDenied) {
    // Open app settings if the permission is permanently denied
    openAppSettings();
    return false;
  }

  return false;
}
