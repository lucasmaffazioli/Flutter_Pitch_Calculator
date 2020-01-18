import 'package:flutter/material.dart';

const TextStyle buttonText = TextStyle(
  fontSize: 18,
  color: Colors.black,
);
const TextStyle inputStyle = TextStyle(
  fontSize: 20,
);

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark().copyWith(
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF43dde6),
        ),
        accentColor: Color(0xFF43dde6),
      ),
      title: 'Pitch calculator',
      home: TipCalculator(),
    ),
  );
}

class TipCalculator extends StatefulWidget {
  @override
  TipCalculatorState createState() => new TipCalculatorState();
}

class TipCalculatorState extends State<TipCalculator> {
  FocusNode myFocusNode;
  double bpmAtual = 0.0;
  double bpmNovo = 0.0;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  final TextEditingController _controller = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Create first input field
    TextField bpmAtualField = TextField(
      decoration: InputDecoration(labelText: "Current song BPM"),
      keyboardType: TextInputType.number,
      controller: _controller,
      autofocus: true,
      focusNode: myFocusNode,
      style: inputStyle,
      onChanged: (String value) {
        try {
          setState(() {
            bpmAtual = double.parse(value);
          });
        } catch (exception) {
          setState(() {
            bpmAtual = 0.0;
          });
        }
      },
    );

    // Create another input field
    TextField bpmNovoField = TextField(
        decoration: InputDecoration(
          labelText: "Next song BPM",
        ),
        style: inputStyle,
        keyboardType: TextInputType.number,
        controller: _controller2,
        onChanged: (String value) {
          try {
            bpmNovo = double.parse(value);
          } catch (exception) {
            bpmNovo = 0.0;
          }
        });

    // Create button
    RaisedButton calculateButton = RaisedButton(
        child: Text(
          "Calculate",
          style: buttonText,
        ),
        padding: EdgeInsets.all(15),
        onPressed: () {
          double calculatedPitch = ((bpmAtual * 100) / bpmNovo) - 100;
          String pitchString = calculatedPitch.toStringAsFixed(2);
          //
          AlertDialog dialog = AlertDialog(
            content: Text(
              "Next song pitch: $pitchString%",
              textAlign: TextAlign.center,
            ),
          );
          showDialog(
              context: context, builder: (BuildContext context) => dialog);
        });

    RaisedButton resetButton = RaisedButton(
      child: Text(
        "Reset",
        style: buttonText,
      ),
      padding: EdgeInsets.all(15),
      onPressed: () {
        print(bpmAtual);
        _controller.clear();
        _controller2.clear();
        this.setState(() {
          bpmAtual = 0;
          bpmNovo = 0;
        });
        FocusScope.of(context).requestFocus(myFocusNode);
        print(bpmAtual);
        //
      },
    );

    Container container = Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          bpmAtualField,
          SizedBox(
            height: 10,
          ),
          bpmNovoField,
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: calculateButton,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: resetButton,
          ),
        ],
      ),
    );

    AppBar appBar = AppBar(title: Text("Pitch calculator"));

    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}
