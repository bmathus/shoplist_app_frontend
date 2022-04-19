import 'package:flutter/material.dart';

//widget buttonu ktory pouzivame pri logine
class ButtonWidget extends StatelessWidget {
  final String title;
  final bool hasBorder;
  final Function onTap;

  ButtonWidget({
    required this.hasBorder,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF355C7D),
          borderRadius: BorderRadius.circular(10),
          border: hasBorder
              ? Border.all(
                  color: const Color(0xFF355C7D),
                  width: 1,
                )
              : const Border.fromBorderSide(BorderSide.none),
        ),
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 55,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
