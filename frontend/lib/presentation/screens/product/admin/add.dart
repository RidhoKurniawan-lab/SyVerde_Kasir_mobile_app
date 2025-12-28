import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:frontend/presentation/widgets/common/custom_text_field.dart';
import 'package:frontend/presentation/widgets/common/custom_dropdown.dart';

class AddProduct extends ConsumerStatefulWidget {
  const AddProduct({super.key});

  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
  final _nameProductController = TextEditingController();
  String? selectedCategory;
  String? selectedUnit;

  @override
  void dispose() {
    _nameProductController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: AppColor.primarywhite,
        title: const HeaderAdminProduct(isIcon: false, header: 'ADD Product'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            children: [
              CustomTextField(
                withicon: false,
                controller: _nameProductController,
                label: 'Name',
                hintText: 'Name Product',
              ),

              const SizedBox(height: 20),

              CustomDropdown<String>(
                label: 'Category',
                hintText: 'Select Unit',
                value: selectedCategory,
                withIcon: false,
                items: [
                  DropdownMenuItem(value: 'Minuman', child: Text('Minuman')),
                  DropdownMenuItem(value: 'Makanan', child: Text('Makanan')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      withicon: false,
                      controller: _nameProductController,
                      label: 'Price',
                      hintText: 'Price (Rp)',
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: CustomDropdown<String>(
                      label: 'Unit',
                      hintText: 'Select Unit',
                      value: selectedUnit,
                      withIcon: false,
                      items: [
                        DropdownMenuItem(
                          value: 'Kg',
                          child: Text('Kg'),
                        ),
                        DropdownMenuItem(
                          value: 'Ons',
                          child: Text('Ons'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedUnit = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              CustomTextField(
                withicon: false,
                controller: _nameProductController,
                label: 'SKU',
                hintText: 'SKU Product',
              ),

              const SizedBox(height: 20),

              CustomTextField(
                withicon: false,
                controller: _nameProductController,
                label: 'Description',
                hintText: 'Description Product (Optional)',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
