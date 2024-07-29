import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:hive/hive.dart';

class CalculatorProvider extends ChangeNotifier {
  final compController = TextEditingController();
  Box<String>? box;
  final List<String> symbols = ['*', '/', '+', '-', '%'];

  CalculatorProvider() {
    openBox();
  }

  Future<void> openBox() async {
    box = await Hive.openBox<String>('calculationHistory');
    notifyListeners();
  }

  void setVal(String val) {
    String str = compController.text;
    bool isLastCharSymbol =
        str.isNotEmpty && symbols.contains(str[str.length - 1]);
    bool isCurrentValSymbol = symbols.contains(val);

    if (val == '0' && str == '0') {
      return; // Prevent leading zero
    }

    if (val == '.' && (str.isEmpty || str.endsWith('.') || isLastCharSymbol)) {
      return; // Prevent dot at the beginning, after another dot, or after a symbol
    }

    // Prevent multiple dots in the same number
    List<String> parts = str.split(RegExp(r'[*/+%-]'));
    if (val == '.' && parts.isNotEmpty && parts.last.contains('.')) {
      return;
    }

    if (isLastCharSymbol && isCurrentValSymbol) {
      return; // Prevent consecutive symbols
    }

    switch (val) {
      case 'C':
        compController.clear();
        break;
      case 'AC':
        if (str.isNotEmpty) {
          compController.text = str.substring(0, str.length - 1);
        }
        break;
      case 'X':
        if (!isLastCharSymbol) {
          compController.text += "*";
        }
        break;
      case '=':
        compute();
        break;
      default:
        compController.text += val;
        break;
    }

    compController.selection = TextSelection.fromPosition(
        TextPosition(offset: compController.text.length));
    notifyListeners();
  }

  void compute() {
    String str = compController.text;
    try {
      // Ensure that the last character is not a symbol before computing
      if (symbols.contains(str[str.length - 1])) {
        throw Exception("Invalid input");
      }

      String result = str.interpret().toString();
      if (result.contains('.')) {
        result = double.parse(result).toStringAsFixed(2);
      }
      String historyEntry = '$str = $result';
      compController.text = result;
      box?.add(historyEntry);
    } catch (e) {
      compController.text = "Error";
    }
    notifyListeners();
  }

  @override
  void dispose() {
    compController.dispose();
    super.dispose();
  }
}
