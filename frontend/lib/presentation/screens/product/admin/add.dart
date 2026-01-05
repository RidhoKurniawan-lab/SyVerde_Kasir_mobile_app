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
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (result != null) {
      setState(() {
        _selectedImage = File(result.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _productListener = ref.listenManual<ProductSubmitState>(productSubmitProvider, (
      prev,
      next,
    ) {
      if (next is ProductSubmitSuccess) {
        ref.read(productQueryProvider.notifier).getProduct();
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
    final notifier = ref.read(productSubmitProvider.notifier);
    final state = ref.watch(productSubmitProvider);

    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: AppColor.primarywhite,
        title: const HeaderAdminProduct(isIcon: false, header: 'ADD Product'),
      ),
      bottomNavigationBar: BottomSubmitButton(
        text: state is ProductQueryLoading ? 'Loading...' : 'Save',
        onPressed: state is ProductQueryLoading
            ? null
            : () {
                final request = ProductRequest(
                  name: _nameProductController.text,
                  categoryId: selectedCategory!,
                  unitId: selectedUnit!,
                  price: double.parse(_priceProductController.text),
                  sku: _skuProductController.text.trim(),
                  description: _deskriptionProductController.text.trim(),
                );

                notifier.insertProduct(request: request, image: _selectedImage);
              },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 22),
        
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 200,
                      height: 200,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.secondarywhite, // opsional background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _selectedImage == null
                          ? const Icon(
                              Icons.add_a_photo,
                              size: 100,
                              color: Colors.grey,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover, // PENTING
                              ),
                            ),
                    ),
                  ),
                ),
        
                const SizedBox(height: 30),
        
                CustomTextField(
                  withicon: false,
                  controller: _nameProductController,
                  label: 'Name',
                  hintText: 'Nama Product',
                  errorText: state is ProductSubmitValidationError
                      ? state.errors['name']?.first.toString()
                      : null,
                ),
        
                const SizedBox(height: 20),
        
                _buildCategoryDropdown(
                  state is ProductSubmitValidationError && selectedCategory == null
                      ? 'Select Category'
                      : null,
                ),
                const SizedBox(height: 20),
        
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        withicon: false,
                        controller: _priceProductController,
                        label: 'Price',
                        hintText: 'Price (Rp)',
                        errorText: state is ProductSubmitValidationError
                            ? state.errors['price']?.first.toString()
                            : null,
                      ),
                    ),
        
                    const SizedBox(width: 13),
        
                    Expanded(
                      child: _buildUnitDropdown(
                        state is ProductSubmitValidationError && selectedUnit == null
                            ? 'Select Unit'
                            : null,
                      ),
                    ),
                  ],
                ),
        
                const SizedBox(height: 20),
        
                CustomTextField(
                  withicon: false,
                  controller: _skuProductController,
                  label: 'SKU',
                  hintText: 'SKU Product',
                  errorText: state is ProductSubmitValidationError
                      ? state.errors['sku']?.first.toString()
                      : null,
                ),
        
                const SizedBox(height: 20),
        
                CustomTextField(
                  withicon: false,
                  controller: _deskriptionProductController,
                  label: 'Description',
                  hintText: 'Description Product (Optional)',
                  errorText: state is ProductSubmitValidationError
                      ? state.errors['deskripsi']?.first.toString()
                      : null,
                ),
              ],
            ),
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
