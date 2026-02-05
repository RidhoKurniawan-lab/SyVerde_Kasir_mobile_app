import 'package:flutter/material.dart';

class TableRowWidget extends StatelessWidget {
  final Map<String, dynamic> param;

  const TableRowWidget({super.key, required this.param});

  @override
  Widget build(BuildContext context) {
    final flex = param['flex'] as Map<String, dynamic>;

    // Ambil semua row kecuali "flex"
    final rows = param.entries.where((e) => e.key.startsWith('row')).toList();

    return Container(
      height: 32,
      color: Colors.white,
      child: Row(
        children: List.generate(rows.length, (index) {
          final row = rows[index].value;
          final colFlex = flex['col${index + 1}'] ?? 1;

          return Expanded(flex: colFlex, child: _buildCell(row));
        }),
      ),
    );
  }

  Widget _buildCell(Map<String, dynamic> row) {
    final type = row['type'];
    final text = row['text'] ?? '';
    final format = row['format'] ?? 'text';

    if (type == 'status') {
      return _buildStatusCell(text, format);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStatusCell(String action, String format) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: format == 'icon'
            ? const EdgeInsets.all(4)
            : const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: _getActionColor(action),
          shape: format == 'icon' ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: format == 'icon' ? null : BorderRadius.circular(4),
        ),
        child: _buildStatusContent(action, format),
      ),
    );
  }

  Widget _buildStatusContent(String action, String format) {
    if (format == 'icon') {
      return Icon(
        _getActionIcon(action),
        size: 14,
        color: _getActionTextColor(action),
      );
    }

    return Text(
      action,
      style: TextStyle(
        fontSize: 12,
        color: _getActionTextColor(action),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'create':
        return Colors.green.shade100;
      case 'completed':
        return Colors.green.shade100;
      case 'update':
        return Colors.blue.shade100;
      case 'delete':
        return Colors.red.shade100;
      case 'cancel':
        return Colors.red.shade100;
      case 'view':
        return Colors.orange.shade100;
      case 'export':
        return Colors.purple.shade100;
      case 'out':
        return Colors.red.shade100;
      case 'normal':
        return Colors.green.shade100;
      case 'low':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getActionTextColor(String action) {
    switch (action.toLowerCase()) {
      case 'create':
        return Colors.green.shade800;
      case 'update':
        return Colors.blue.shade800;
      case 'delete':
        return Colors.red.shade800;
      case 'view':
        return Colors.orange.shade800;
      case 'export':
        return Colors.purple.shade800;
      case 'out':
        return Colors.red.shade800;
      case 'normal':
        return Colors.green.shade800;
      case 'low':
        return Colors.orange.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'completed':
        return Icons.check;
      case 'cancel':
        return Icons.close;
      default:
        return Icons.question_mark;
    }
  }
}
