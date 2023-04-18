import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final IconData? icon;
  late String title;
  late VoidCallback onTap;
  ProfileButton({@required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            SizedBox(width: 20),
            Text(title, style: TextStyle(color: Colors.black87))
          ],
        ),
      ),
    );
  }
}
