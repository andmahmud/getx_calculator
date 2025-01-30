import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Calculator",
    home: CalculatorApp(),
  ));
}

class CalculatorController extends GetxController {
  var input = ''.obs;
  var result = ''.obs;

  void onButtonPressed(String value) {
    if (value == "C") {
      input.value = '';
      result.value = '';
    } else if (value == "=") {
      try {
        result.value = evaluateExpression(input.value);
      } catch (e) {
        result.value = "Error";
      }
    } else {
      input.value += value;
    }
  }

  String evaluateExpression(String expression) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression.replaceAll('x', '*'));
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);
      return eval.toString();
    } catch (e) {
      return "Error";
    }
  }
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.put(CalculatorController());
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Solve Your Math", style: TextStyle(fontSize: 25)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() => Text(
                        controller.input.value,
                        style: const TextStyle(fontSize: 40, color: Colors.black),
                      )),
                  const SizedBox(height: 10),
                  Obx(() => Text(
                        controller.result.value,
                        style: const TextStyle(fontSize: 39, color: Colors.grey),
                      )),
                ],
              ),
            ),
          ),
          _buildButtonRow(controller, ["1", "2", "3", "+"]),
          _buildButtonRow(controller, ["4", "5", "6", "-"]),
          _buildButtonRow(controller, ["7", "8", "9", "*"]),
          _buildButtonRow(controller, ["0", "C", "=", "/"]),
        ],
      ),
    );
  }

  Widget _buildButtonRow(CalculatorController controller, List<String> texts) {
    return Expanded(
      flex: 1,
      child: Row(
        children: texts.map((text) => CalculatorButton(text: text, onTap: () => controller.onButtonPressed(text))).toList(),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CalculatorButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 36, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
