import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _fetchDarkModePreference(),
      builder: (context, snapshot) {
        print('Snapshot data: ${snapshot.data}');
        final isDarkMode = snapshot.data ?? false;
        print('Is Dark Mode: $isDarkMode');
        return DynamicTheme(
          initialTheme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          builder: (context, theme) {
            return MaterialApp(
              title: 'Calculator',
              theme: theme,
              home: Calculator(),
            );
          },
        );
      },
    );
  }

  Future<bool> _fetchDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final darkMode = prefs.getBool('darkMode') ?? false;
    print('Dark mode preference loaded: $darkMode');
    return darkMode;
  }
}

class DynamicTheme extends StatefulWidget {
  final ThemeData initialTheme;
  final Widget Function(BuildContext context, ThemeData theme) builder;

  const DynamicTheme({Key? key, required this.initialTheme, required this.builder})
      : super(key: key);

  static _DynamicThemeState? of(BuildContext context) {
    return context.findAncestorStateOfType<_DynamicThemeState>();
  }

  @override
  _DynamicThemeState createState() => _DynamicThemeState();
}

class _DynamicThemeState extends State<DynamicTheme> {
  late ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _theme = widget.initialTheme;
  }

  void toggleTheme() {
    setState(() {
      _theme = _theme == ThemeData.light() ? ThemeData.dark() : ThemeData.light();
      _saveDarkModePreference(_theme == ThemeData.dark());
      print('Theme toggled: $_theme');
    });
  }

  Future<void> _saveDarkModePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
    print('Dark mode preference saved: $isDarkMode');
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _theme);
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = '0';
  String _outputHistory = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _outputHistory = '';
        _num1 = 0;
        _num2 = 0;
        _operand = '';
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == 'x' ||
          buttonText == '/') {
        _num1 = double.parse(_output);
        _operand = buttonText;
        _outputHistory += _output + ' ' + _operand + ' ';
        _output = '0';
      } else if (buttonText == '=') {
        _num2 = double.parse(_output);
        if (_operand == '+') {
          _output = (_num1 + _num2).toString();
        }
        if (_operand == '-') {
          _output = (_num1 - _num2).toString();
        }
        if (_operand == 'x') {
          _output = (_num1 * _num2).toString();
        }
        if (_operand == '/') {
          _output = (_num1 / _num2).toString();
        }
        _outputHistory += _output;
        _operand = '';
      } else {
        if (_output == '0') {
          _output = buttonText;
        } else {
          _output += buttonText;
        }
      }
    });
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb_outline),
            onPressed: () {
              DynamicTheme.of(context)?.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(16.0),
              child: Text(
                _outputHistory,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(16.0),
              child: Text(
                _output,
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('/'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('x'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('-'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      _buildButton('.'),
                      _buildButton('0'),
                      _buildButton('C'),
                      _buildButton('+'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      _buildButton('='),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
