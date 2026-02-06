import 'package:flutter/material.dart';
import 'package:frontend/core/configs/routes.dart';
import 'package:frontend/core/constants/app_color.dart';

class TransactionCard extends StatelessWidget {
  final int id;
  final String invoice;
  final String date; 
  final String time;
  final String status;

  const TransactionCard({
    super.key,
    required this.id,
    required this.invoice,
    required this.date,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isCanceled = status.toLowerCase() == 'canceled';
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.detailTransaction, arguments: id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.secondarywhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColor.green100, width: 0.5),
        ),
        child: Row(
          children: [
            /// LEFT — ID TRANSACTION
            Expanded(
              child: Row(
                children: [
                  const Text(
                    'ID:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      invoice,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColor.green100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isCanceled ? AppColor.red28 : AppColor.green28,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isCanceled ? AppColor.red100 : AppColor.green100,
                ),
              ),
            ),
      
            const SizedBox(width: 8),
      
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 12,
                  color: AppColor.black50,
                ),
                const SizedBox(width: 4),
                Text(
                  '$date • $time',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
