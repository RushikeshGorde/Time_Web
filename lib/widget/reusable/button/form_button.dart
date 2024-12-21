import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomButtons extends StatelessWidget {
  final VoidCallback onSavePressed;
  final VoidCallback onCancelPressed;

  const CustomButtons({
    super.key,
    required this.onSavePressed,
    required this.onCancelPressed,
  });

  bool _isMobilePlatform(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.android;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobilePlatform(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => {},
            onExit: (_) => {},
            child: InkWell(
              onTap: onCancelPressed,
              hoverColor: isMobile
                  ? const Color.fromARGB(255, 247, 145, 145).withOpacity(0.4)// White color for mobile
                  : const Color.fromARGB(255, 247, 145, 145).withOpacity(0.4), // Hover effect for non-mobile
              borderRadius: BorderRadius.circular(3),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => {},
            onExit: (_) => {},
            child: InkWell(
              onTap: onSavePressed,
              hoverColor: isMobile
                  ? Color.fromARGB(255, 62, 237, 27).withOpacity(0.4) // White color for mobile
                  : const Color.fromARGB(255, 62, 237, 27).withOpacity(0.4), // Hover effect for non-mobile
              borderRadius: BorderRadius.circular(3),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
