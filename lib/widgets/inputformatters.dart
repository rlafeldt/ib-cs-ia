import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow numbers and a single dot for decimals, remove other characters
    String numericOnly = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Prevent multiple dots and limit decimal places to 2
    if (numericOnly.contains('.')) {
      final parts = numericOnly.split('.');
      if (parts.length > 2) {
        // More than one dot present, join back with a single dot
        numericOnly = '${parts[0]}.${parts.sublist(1).join('')}';
      }
      // Limit decimal places to 2
      if (parts.length > 1 && parts[1].length > 2) {
        numericOnly = '${parts[0]}.${parts[1].substring(0, 2)}';
      }
    }

    if (numericOnly.isEmpty) {
      return const TextEditingValue();
    }

    // Format the text with currency symbol
    String newText = 'R\$ $numericOnly';

    return newValue.copyWith(
      text: newText,
      // Update the cursor position accordingly
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class PercentageInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow numbers and a single dot for decimals, remove other characters
    String numericOnly = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Prevent multiple dots and limit decimal places to 2
    if (numericOnly.contains('.')) {
      final parts = numericOnly.split('.');
      if (parts.length > 2) {
        // More than one dot present, join back with a single dot
        numericOnly = '${parts[0]}.${parts.sublist(1).join('')}';
      }
      // Limit decimal places to 2
      if (parts.length > 1 && parts[1].length > 2) {
        numericOnly = '${parts[0]}.${parts[1].substring(0, 2)}';
      }
    }

    if (numericOnly.isEmpty) {
      return const TextEditingValue();
    }

    // Format the text with percentage symbol
    String newText = '$numericOnly%';

    return newValue.copyWith(
      text: newText,
      // Correctly place the cursor before the '%' symbol
      selection: TextSelection.collapsed(offset: newText.length - 1),
    );
  }
}
