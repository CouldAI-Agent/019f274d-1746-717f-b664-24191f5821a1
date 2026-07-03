import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.orange,
          surface: Colors.black,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CalculatorScreen(),
      },
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _equation = "0";
  String _result = "0";
  String _expression = "";

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _equation = "0";
        _result = "0";
      } else if (buttonText == "⌫") {
        _equation = _equation.substring(0, _equation.length - 1);
        if (_equation == "") {
          _equation = "0";
        }
      } else if (buttonText == "=") {
        _expression = _equation;
        _expression = _expression.replaceAll('×', '*');
        _expression = _expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression);

          ContextModel cm = ContextModel();
          _result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          
          if (_result.endsWith(".0")) {
            _result = _result.substring(0, _result.length - 2);
          }
        } catch (e) {
          _result = "Error";
        }
      } else {
        if (_equation == "0") {
          _equation = buttonText;
        } else {
          _equation = _equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, Color buttonColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: buttonColor,
          padding: const EdgeInsets.all(24.0),
        ),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.normal,
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            double buttonSize = (maxWidth - 64) / 4;
            if (buttonSize > 80) buttonSize = 80;

            Widget customButton(String text, Color bg, Color fg) {
              return SizedBox(
                width: buttonSize,
                height: buttonSize,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(buttonSize / 2),
                      ),
                      backgroundColor: bg,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => buttonPressed(text),
                    child: Center(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: buttonSize * 0.4,
                          fontWeight: FontWeight.w400,
                          color: fg,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _equation,
                          style: const TextStyle(fontSize: 48.0, color: Colors.white54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _result,
                          style: const TextStyle(fontSize: 72.0, color: Colors.white, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: buttonSize * 4 + 32,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              customButton("C", Colors.grey[400]!, Colors.black),
                              customButton("⌫", Colors.grey[400]!, Colors.black),
                              customButton("%", Colors.grey[400]!, Colors.black),
                              customButton("÷", Colors.orange, Colors.white),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              customButton("7", Colors.grey[850]!, Colors.white),
                              customButton("8", Colors.grey[850]!, Colors.white),
                              customButton("9", Colors.grey[850]!, Colors.white),
                              customButton("×", Colors.orange, Colors.white),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              customButton("4", Colors.grey[850]!, Colors.white),
                              customButton("5", Colors.grey[850]!, Colors.white),
                              customButton("6", Colors.grey[850]!, Colors.white),
                              customButton("-", Colors.orange, Colors.white),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              customButton("1", Colors.grey[850]!, Colors.white),
                              customButton("2", Colors.grey[850]!, Colors.white),
                              customButton("3", Colors.grey[850]!, Colors.white),
                              customButton("+", Colors.orange, Colors.white),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Zero button spans 2 columns roughly by wrapping in Expanded in a normal layout, 
                              // but here we just use fixed size since we're strictly setting sizes. 
                              // A wider zero button:
                              SizedBox(
                                width: buttonSize * 2,
                                height: buttonSize,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(buttonSize / 2),
                                      ),
                                      backgroundColor: Colors.grey[850]!,
                                      padding: const EdgeInsets.only(left: 32),
                                      alignment: Alignment.centerLeft,
                                    ),
                                    onPressed: () => buttonPressed("0"),
                                    child: Text(
                                      "0",
                                      style: TextStyle(
                                        fontSize: buttonSize * 0.4,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              customButton(".", Colors.grey[850]!, Colors.white),
                              customButton("=", Colors.orange, Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
