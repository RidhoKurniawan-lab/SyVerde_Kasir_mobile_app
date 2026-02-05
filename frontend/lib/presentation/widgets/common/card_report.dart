import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

class ReportCard extends StatelessWidget {
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;
  final String headerText;
  final String mainText;
  final double bottomText;

  const ReportCard({
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
      width: 182,
      height: 95,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColor.secondarywhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColor.primarylight40, 
          width: 0.5, 
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  headerText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                ),
              ),

              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),

          /// Main Value
          Center(
            child: Text(
              mainText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                
                fontWeight: FontWeight.w900,
                color: AppColor.primary,
              ),
            ),
          ),

          /// Bottom Description
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              '${bottomText.toString()} form Yesterday',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 9, 
                fontWeight: 
                FontWeight.w400, 
                fontStyle: FontStyle.italic,
                color: bottomText.isNegative ? AppColor.red100 : AppColor.green100
                ),
            ),
          ),
        ],
      ),
    );
  }
}
