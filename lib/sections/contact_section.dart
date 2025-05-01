import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;

class ContactSection extends StatefulWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  _ContactSectionState createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final String emailTo = 'eyadamro905@gmail.com';
      final String subject = 'Contact from: ${_nameController.text}';
      final String body = 'Name: ${_nameController.text}\n'
          'Email: ${_emailController.text}\n\n'
          'Message:\n${_messageController.text}';

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: emailTo,
        query: _encodeQueryParameters({
          'subject': subject,
          'body': body,
        }),
      );

      html.window.open(emailUri.toString(), '_blank');

      // Reset form after submission
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();

      setState(() {
        _isSubmitting = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email client opened. Thanks for your message!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive breakpoints
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    return Container(
      // Use auto height instead of fixed height to avoid overflow
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.04,
        horizontal: isMobile ? screenWidth * 0.03 : screenWidth * 0.06,
      ),
      child: SingleChildScrollView( // Wrap in SingleChildScrollView to handle overflow
        child: Column(
          children: [
            // Section title with refined styling
            Text(
              "Contact Me",
              style: GoogleFonts.poppins(
                fontSize: isMobile ? screenWidth * 0.055 : screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),
            
            SizedBox(height: screenHeight * 0.01),
            
            // More elegant divider matching other sections
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
            
            // Social media links section with refined styling
            Container(
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              child: Column(
                children: [
                  Text(
                    "Connect With Me",
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? screenWidth * 0.035 : screenWidth * 0.018,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8BC34A),
                      letterSpacing: 0.5,
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.02),
                  
                  // Social media icons in a row with refined styling
                  Wrap(
                    spacing: isMobile ? screenWidth * 0.04 : screenWidth * 0.025,
                    runSpacing: screenHeight * 0.02,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildSocialButton(
                        icon: Icons.email,
                        label: "Email",
                        url: "mailto:eyadamro905@gmail.com",
                        color: Color(0xFFDB4437),
                        isMobile: isMobile,
                      ),
                      _buildSocialButton(
                        icon: Icons.work, 
                        label: "LinkedIn",
                        url: "https://www.linkedin.com/in/eyad-amr/",
                        color: Color(0xFF0077B5),
                        isMobile: isMobile,
                      ),
                      _buildSocialButton(
                        icon: Icons.code, 
                        label: "GitHub",
                        url: "https://github.com/eyadamr905?tab=repositories",
                        color: Color(0xFFE0E0E0),
                        isMobile: isMobile,
                      ),
                      _buildSocialButton(
                        icon: Icons.facebook, 
                        label: "Facebook",
                        url: "https://www.facebook.com/profile.php?id=100009136631108",
                        color: Color(0xFF1877F2),
                        isMobile: isMobile,
                      ),
                      _buildSocialButton(
                        icon: Icons.camera_alt, 
                        label: "Instagram",
                        url: "https://www.instagram.com/eyad3mr12/",
                        color: Color(0xFFE1306C),
                        isMobile: isMobile,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: screenHeight * 0.025),
            
            // Contact form with refined styling - fixed height
            Container(
              width: isMobile ? screenWidth * 0.85 : screenWidth * 0.55,
              padding: EdgeInsets.all(isMobile ? screenWidth * 0.035 : screenWidth * 0.025),
              margin: EdgeInsets.only(bottom: screenHeight * 0.04), // Added bottom margin
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
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Changed to min for better handling
                  children: [
                    // Name field with improved styling
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      icon: Icons.person_outline,
                      isMobile: isMobile,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: screenHeight * 0.018),
                    
                    // Email field with improved styling
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      isMobile: isMobile,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: screenHeight * 0.018),
                    
                    // Message field with improved styling and shorter height
                    _buildTextField(
                      controller: _messageController,
                      label: 'Message',
                      icon: Icons.message_outlined,
                      maxLines: isMobile ? 3 : 4, // Reduced number of lines
                      isMobile: isMobile,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Submit button with improved styling
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8BC34A).withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? screenWidth * 0.05 : screenWidth * 0.035,
                              vertical: isMobile ? screenHeight * 0.018 : screenHeight * 0.013,
                            ),
                            backgroundColor: const Color(0xFF8BC34A),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: _isSubmitting
                              ? SizedBox(
                                  width: isMobile ? 20 : 16,
                                  height: isMobile ? 20 : 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                  ),
                                )
                              : Text(
                                  'Send Message',
                                  style: GoogleFonts.poppins(
                                    fontSize: isMobile ? screenWidth * 0.035 : screenWidth * 0.014,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
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
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required String url,
    required Color color,
    required bool isMobile,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = isMobile ? screenWidth * 0.12 : screenWidth * 0.05;
    
    return InkWell(
      onTap: () => html.window.open(url, '_blank'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: const Color(0xFF23232D),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: color.withOpacity(0.6),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: buttonSize * 0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? screenWidth * 0.025 : screenWidth * 0.01,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isMobile,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: isMobile ? screenWidth * 0.03 : screenWidth * 0.012,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.white.withOpacity(0.7),
          fontSize: isMobile ? screenWidth * 0.03 : screenWidth * 0.012,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF8BC34A),
          size: isMobile ? screenWidth * 0.04 : screenWidth * 0.016,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: const Color(0xFF8BC34A).withOpacity(0.6),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.redAccent.withOpacity(0.6),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.redAccent.withOpacity(0.8),
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: maxLines > 1 ? 16 : 0,
        ),
      ),
    );
  }
}
