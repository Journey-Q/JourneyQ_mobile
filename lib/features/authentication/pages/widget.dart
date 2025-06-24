import 'package:flutter/material.dart';
import 'package:journeyq/shared/widgets/common/loading_widget.dart';

Widget buildHeader() {
  return Column(
    children: [
      Hero(
        tag: 'app_logo',
        child: Container(
          width: 150,
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/logo1.png', fit: BoxFit.cover),
          ),
        ),
      ),
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF0088cc), Color(0xFF00B4DB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: const Text(
          'Welcome to JourneyQ',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Sign in to continue your journey',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}


Widget buildLoginHeader() {
  return Column(
    children: [
      Hero(
        tag: 'app_logo',
        child: Container(
          width: 150,
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/logo1.png', fit: BoxFit.cover),
          ),
        ),
      ),
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF0088cc), Color(0xFF00B4DB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: const Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Sign up to continue your journey',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}


Widget buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or continue with',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget buildSocialButton({
    required dynamic
    icon, // Changed to dynamic to accept both IconData and Widget
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(color: borderColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: icon is IconData
                ? Icon(icon, size: 28, color: textColor) // For IconData
                : icon, // For Widget (Image.asset)
          ),
        ),
      ),
    );
  }

  Widget buildCommonTextField({
 required TextEditingController controller,
 required String labelText,
 required String hintText,
 required IconData prefixIcon,
 required String? Function(String?)? validator,
 TextInputType keyboardType = TextInputType.text,
 bool obscureText = false,
 Widget? suffixIcon,
}) {
 return Material(
   borderRadius: BorderRadius.circular(16),
   child: TextFormField(
     controller: controller,
     keyboardType: keyboardType,
     validator: validator,
     obscureText: obscureText,
     style: const TextStyle(fontSize: 16),
     decoration: InputDecoration(
       labelText: labelText,
       hintText: hintText,
       prefixIcon: Container(
         margin: const EdgeInsets.all(12),
         child: Icon(
           prefixIcon,
           color: Colors.black,
           size: 20,
         ),
       ),
       suffixIcon: suffixIcon,
       border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(16),
         borderSide: BorderSide.none,
       ),
       enabledBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(16),
         borderSide: BorderSide.none,
       ),
       focusedBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(16),
         borderSide: const BorderSide(color: Color(0xFF0088cc), width: 2),
       ),
       filled: true,
       fillColor: Colors.grey[100],
       labelStyle: TextStyle(color: Colors.grey[700]),
       hintStyle: TextStyle(color: Colors.grey[400]),
       contentPadding: const EdgeInsets.symmetric(
         horizontal: 16,
         vertical: 16,
       ),
     ),
   ),
 );
}


Widget buildPrimaryGradientButton({
 required String text,
 required VoidCallback? onPressed,
 bool isLoading = false,
 double width = double.infinity,
 double height = 56,
 Widget? loadingWidget,
 TextStyle? textStyle,
 List<Color>? gradientColors,
 BorderRadius? borderRadius,
 List<BoxShadow>? boxShadow,
}) {
 return Container(
   width: width,
   height: height,
   decoration: BoxDecoration(
     borderRadius: borderRadius ?? BorderRadius.circular(16),
     gradient: LinearGradient(
       colors: gradientColors ?? const [Color(0xFF0088cc), Color(0xFF00B4DB)],
       begin: Alignment.centerLeft,
       end: Alignment.centerRight,
     ),
     boxShadow: boxShadow ?? [
       BoxShadow(
         color: Colors.black.withOpacity(0.15),
         blurRadius: 10,
         offset: const Offset(0, 4),
       ),
     ],
   ),
   child: Material(
     color: Colors.transparent,
     child: InkWell(
       onTap: isLoading ? null : onPressed,
       borderRadius: borderRadius ?? BorderRadius.circular(16),
       child: Container(
         alignment: Alignment.center,
         child: isLoading
             ? (loadingWidget ?? const LoadingWidget(color: Colors.white))
             : Text(
                 text,
                 style: textStyle ?? const TextStyle(
                   fontSize: 18,
                   fontWeight: FontWeight.w600,
                   color: Colors.white,
                   letterSpacing: 0.5,
                 ),
               ),
       ),
     ),
   ),
 );
}
