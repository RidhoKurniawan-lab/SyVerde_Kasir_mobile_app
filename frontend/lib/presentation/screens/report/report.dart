import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:frontend/presentation/screens/layout/header/header_kasir.dart';
import 'package:frontend/core/configs/routes.dart';
import 'package:frontend/presentation/widgets/helper/alern_logout.dart';
import 'package:frontend/state/auth_provider.dart';

class Report extends ConsumerWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: AppColor.primarywhite,
        title: const HeaderKasir(
          header: 'Report',
          isHeaderShow: true,
          name: true,
        ),
      ),
      body: Container(
        color: AppColor.secondarywhite,
        margin: EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/reportSeles');
              },
              child: Container(
                width: double.infinity,
                height: 80,
                padding: EdgeInsets.only(
                  top: 10,
                  right: 20,
                  left: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColor.green100, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColor.green28,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: AppColor.primary,
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Text(
                          'Seles Report',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    RotatedBox(
                      quarterTurns: 2,
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/transaction');
              },
              child: Container(
                width: double.infinity,
                height: 80,
                padding: EdgeInsets.only(
                  top: 10,
                  right: 20,
                  left: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColor.green100, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColor.green28,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: AppColor.primary,
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Text(
                          'History Transaction',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    RotatedBox(
                      quarterTurns: 2,
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/transaction');
              },
              child: Container(
                width: double.infinity,
                height: 80,
                padding: EdgeInsets.only(
                  top: 10,
                  right: 20,
                  left: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColor.green100, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColor.green28,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: AppColor.primary,
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Text(
                          'History Transaction',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    RotatedBox(
                      quarterTurns: 2,
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/transaction');
              },
              child: Container(
                width: double.infinity,
                height: 80,
                padding: EdgeInsets.only(
                  top: 10,
                  right: 20,
                  left: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColor.green100, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColor.green28,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: AppColor.primary,
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Text(
                          'History Transaction',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    RotatedBox(
                      quarterTurns: 2,
                      child: Icon(Icons.arrow_back_ios),
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
}
