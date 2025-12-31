import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/data/models/request/product_request_model.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:frontend/presentation/widgets/common/custom_text_field.dart';
import 'package:frontend/presentation/widgets/common/custom_dropdown.dart';
import 'package:frontend/state/category_provider.dart';
import 'package:frontend/state/product_provider.dart';
import 'package:frontend/state/unit_provider.dart';
import 'package:frontend/presentation/widgets/common/button_submit_bottom.dart';

class AddProduct extends ConsumerStatefulWidget {
  const AddProduct({super.key});

  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
  late final ProviderSubscription _productListener;
  final _nameProductController = TextEditingController();
  final _priceProductController = TextEditingController();
  final _skuProductController = TextEditingController();
  final _deskriptionProductController = TextEditingController();
  int? selectedCategory;
  int? selectedUnit;

  @override
  void initState(){
    super.initState();

    _productListener = ref.listenManual<ProductState>(productProvider, (prev, next){
      if(next is ProductLoading){
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _productListener.close();
    _nameProductController.dispose();
    _priceProductController.dispose();
    _skuProductController.dispose();
    _deskriptionProductController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(productProvider.notifier);
    final state = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: AppColor.primarywhite,
        title: const HeaderAdminProduct(isIcon: false, header: 'ADD Product'),
      ),
      bottomNavigationBar: BottomSubmitButton(
        text: state is ProductLoading ? 'Loading...' : 'Save',
        onPressed: state is ProductLoading
            ? null
            : () {
                final request = ProductRequest(
                  name: _nameProductController.text,
                  categoryId: selectedCategory!,
                  unitId: selectedCategory!,
                  price: double.parse(_priceProductController.text),
                  sku: _skuProductController.text.trim(),
                  description: _deskriptionProductController.text.trim(),
                );

                notifier.insertProduct(request);
              },
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
                hintText: 'Nama Product',
                errorText: state is ProductValidationError ? state.errors['name']?.first.toString()
                : null,
              ),

              const SizedBox(height: 20),

              _buildCategoryDropdown(state is ProductValidationError && selectedCategory == null ? 'Select Category' : null),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      withicon: false,
                      controller: _priceProductController,
                      label: 'Price',
                      hintText: 'Price (Rp)',
                      errorText: state is ProductValidationError ? state.errors['price']?.first.toString() : null,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: _buildUnitDropdown(state is ProductValidationError && selectedUnit == null ? 'Select Unit' : null),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              CustomTextField(
                withicon: false,
                controller: _skuProductController,
                label: 'SKU',
                hintText: 'SKU Product',
                errorText: state is ProductValidationError ? state.errors['sku']?.first.toString() : null,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                withicon: false,
                controller: _deskriptionProductController,
                label: 'Description',
                hintText: 'Description Product (Optional)',
                errorText: state is ProductValidationError ? state.errors['deskripsi']?.first.toString() : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // GET UNIT

  Widget _buildUnitDropdown(String? errorText) {
    final asyncUnits = ref.watch(unitProvider);

    List<DropdownMenuItem<int>> items = [];

    asyncUnits.maybeWhen(
      data: (units) {
        items = units
            .map(
              (unit) =>
                  DropdownMenuItem<int>(value: unit.id, child: Text(unit.name)),
            )
            .toList();
      },
      orElse: () {
        items = [];
      },
    );

    return CustomDropdown<int>(
      label: 'Unit',
      hintText: 'Select Unit',
      value: selectedUnit,
      withIcon: false,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedUnit = value ?? 0;
        });
      },
      errorText: errorText,
    );
  }

  // GET CATEGORY

  Widget _buildCategoryDropdown(String? errorText) {
    final state = ref.watch(categoryProvider);

    if (state is CategoryError) {
      return Text(state.message, style: const TextStyle(color: Colors.red));
    }

    return CustomDropdown<int>(
      label: 'Category',
      hintText: 'Select Category',
      value: selectedCategory,
      withIcon: false,
      items: state is CategoryLoaded
          ? state.categories.map((category) {
              return DropdownMenuItem<int>(
                value: category.id, // atau category.name
                child: Text(category.name),
              );
            }).toList()
          : [],
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },
      errorText: errorText,
    );
  }
}
