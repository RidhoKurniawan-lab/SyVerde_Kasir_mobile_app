import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:frontend/core/constants/app_color.dart';

class CustomSearchDropdown<T> extends StatelessWidget {
  final List<T> items;
  final String label;
  final String hintText;
  final String Function(T) itemAsString;
  final ValueChanged<T> onItemSelected;
  final Widget Function(BuildContext context, T item)? itemBuilder;
  final bool withIcon;
  final IconData? prefixIcon;

  const CustomSearchDropdown({
    super.key,
    required this.items,
    required this.label,
    required this.hintText,
    required this.itemAsString,
    required this.onItemSelected,
    this.itemBuilder,
    this.withIcon = false,
    this.prefixIcon,
  });

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: items,
      selectedItem: null, 

      itemAsString: itemAsString,

      dropdownBuilder: (_, _) => Text(
        hintText,
        style: TextStyle(color: Colors.grey.shade600),
      ),

      onChanged: (value) {
        if (value != null) {
          onItemSelected(value);
        }
      },

      popupProps: PopupProps.menu(
        showSearchBox: true,
        itemBuilder: (context, item, _) {
          return InkWell(
            onTap: () {
              onItemSelected(item);
              Navigator.pop(context);
            },
            child: itemBuilder != null
                ? itemBuilder!(context, item)
                : ListTile(
                    title: Text(itemAsString(item)),
                  ),
          );
        },
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          prefixIcon: withIcon ? Icon(prefixIcon) : null,
          filled: true,
          fillColor: AppColor.secondarywhite,
          enabledBorder: _border(Colors.grey.shade300),
          focusedBorder: _border(AppColor.primary, width: 2),
        ),
      ),

      dropdownButtonProps: const DropdownButtonProps(
        icon: Icon(Icons.search),
      ),
    );
  }
}
