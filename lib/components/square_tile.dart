import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        // Center the image within the container
        child: Image.asset(
          imagePath,
          height: 65, // Adjust the height to make the image larger
        ),
      ),
    );
  }
}
