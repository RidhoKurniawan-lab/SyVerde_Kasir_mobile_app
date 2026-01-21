import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_kasir.dart';

class KasirDashboard extends ConsumerStatefulWidget {
  const KasirDashboard({super.key});

  @override
  ConsumerState<KasirDashboard> createState() => _ProductState();
}

class _ProductState extends ConsumerState<KasirDashboard> {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final state = ref.read(productQueryProvider);
    //   if (state is! ProductQueryLoaded) {
    //     ref.read(productQueryProvider.notifier).getProduct();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: const HeaderKasir(
        isHeaderShow: true,
        header: 'Dashboard',
        name: true,
      ),
    );
  }
}
