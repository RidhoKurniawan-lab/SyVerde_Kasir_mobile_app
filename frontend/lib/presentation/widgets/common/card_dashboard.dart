import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

class SummaryCard extends StatelessWidget {
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;
  final String headerText;
  final String mainText;
  final String bottomText;

  const SummaryCard({
    super.key,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
    required this.headerText,
    required this.mainText,
    required this.bottomText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 178,
      height: 118,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.secondarywhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColor.black10,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Header
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(16),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),

              const SizedBox(width: 25),

              Text(
                headerText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),

          /// Main Value
          Text(
            mainText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColor.primary,
            ),
          ),

          /// Bottom Description
          Text(
            bottomText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
