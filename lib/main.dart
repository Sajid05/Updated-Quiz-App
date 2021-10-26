import 'dart:async';
import 'package:flutter/material.dart';
import 'questions.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _queindex = 0;

  int showStatus = 1;
  int _totalCorrect = 0;
  late String _status;
  late String _result;

  bool _isButtonDisabled = false;
  bool _isQuizOver = false;
  List<int> options = [1, 1, 1, 1];
  late Questions _newQuestion;

  var random = Random();
  late int _operator1;
  late int _operator2;
  late int _operand;
  late String _operandSign;
  Timer? timer;
  int _seconds = 26;

  startQuiz() {
    _newQuestion = generateRandomQuestoin();
    _queindex++;
    options = [1, 1, 1, 1];
    showStatus = 1;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        --_seconds;
        if (_seconds < 1) {
          timer!.cancel();
          _isQuizOver = true;
          _result = "You got " +
              (_totalCorrect / _queindex * 100).toStringAsFixed(2) +
              "% correct";
        }
      });
    });
  }

  nextQuiz() {
    _newQuestion = generateRandomQuestoin();
    _queindex++;
    options = [1, 1, 1, 1];
    _isButtonDisabled = false;
    showStatus = 1;
    setState(() {});
  }

  optionChosen(int _index) {
    options = [1, 1, 1, 1];
    _isButtonDisabled = true;
    if (_newQuestion.options[_index] == _newQuestion.ans) {
      showStatus = 2;
      options[_index] = 2;
      _status = "You got it right!";
      _totalCorrect++;
    } else {
      showStatus = 0;
      options[_index] = 0;
      _status = "Ooops! Try the next one";
    }
    setState(() {});
  }

  restart() {
    _queindex = 0;
    _isQuizOver = false;
    _totalCorrect = 0;
    _seconds = 26;
    setState(() {});
  }

  Questions generateRandomQuestoin() {
    _operator1 = random.nextInt(20) + 1;
    _operator2 = random.nextInt(20) + 1;
    _operand = random.nextInt(3);
    late int answer;
    if (_operand == 0) {
      _operandSign = '+';
      answer = (_operator1 + _operator2);
    } else if (_operand == 1) {
      _operandSign = '-';
      answer = (_operator1 - _operator2);
    } else if (_operand == 2) {
      _operandSign = '*';
      answer = (_operator1 * _operator2);
    }

    String question = _operator1.toString() +
        " " +
        _operandSign +
        " " +
        _operator2.toString() +
        " = ?";

    int correctIndex = random.nextInt(4);
    List<int> _listAllOptions = [0, 0, 0, 0];
    _listAllOptions[correctIndex] = answer;

    List<int> _listOptions = [answer - 1, answer + 1, answer + 3];

    for (int i = 0, j = 0; i < 4; i++) {
      if (i != correctIndex) {
        _listAllOptions[i] = _listOptions[j];
        j++;
      }
    }

    return Questions(que: question, ans: answer, options: _listAllOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text("Quiz Application"),
          backgroundColor: Colors.blue[800],
        ),
        body: _queindex == 0
            ? Center(
                child: ElevatedButton(
                  child: const Text("Start Quiz!"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white,
                    // foreground
                  ),
                  onPressed: startQuiz,
                ),
              )
            : !_isQuizOver
                ? Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child:
                                  Text("Score : $_totalCorrect / $_queindex"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                            child: Text(_newQuestion.que,
                                style: const TextStyle(
                                  color: Colors.white,
                                  wordSpacing: 2,
                                  fontSize: 15,
                                )),
                            decoration: BoxDecoration(
                              color: Colors.blue[700],
                              borderRadius: BorderRadius.circular(10),
                            )),
                        SizedBox(
                          width: 80,
                          child: ElevatedButton(
                            child: Text(_newQuestion.options[0].toString()),
                            style: options[0] == 0
                                ? ElevatedButton.styleFrom(
                                    primary: Colors.red, // background
                                    onPrimary: Colors.white,
                                    // foreground
                                  )
                                : options[0] == 2
                                    ? ElevatedButton.styleFrom(
                                        primary: Colors.green, // background
                                        onPrimary: Colors.white,
                                        // foreground
                                      )
                                    : ElevatedButton.styleFrom(
                                        primary: Colors.white, // background
                                        onPrimary: Colors.black,
                                        // foreground
                                      ),
                            onPressed: () =>
                                !_isButtonDisabled ? optionChosen(0) : null,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: ElevatedButton(
                            child: Text(_newQuestion.options[1].toString()),
                            style: options[1] == 0
                                ? ElevatedButton.styleFrom(
                                    primary: Colors.red, // background
                                    onPrimary: Colors.white,
                                    // foreground
                                  )
                                : options[1] == 2
                                    ? ElevatedButton.styleFrom(
                                        primary: Colors.green, // background
                                        onPrimary: Colors.white,
                                        // foreground
                                      )
                                    : ElevatedButton.styleFrom(
                                        primary: Colors.white, // background
                                        onPrimary: Colors.black,
                                        // foreground
                                      ),
                            onPressed: () =>
                                !_isButtonDisabled ? optionChosen(1) : null,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: ElevatedButton(
                            child: Text(_newQuestion.options[2].toString()),
                            style: options[2] == 0
                                ? ElevatedButton.styleFrom(
                                    primary: Colors.red, // background
                                    onPrimary: Colors.white,
                                    // foreground
                                  )
                                : options[2] == 2
                                    ? ElevatedButton.styleFrom(
                                        primary: Colors.green, // background
                                        onPrimary: Colors.white,
                                        // foreground
                                      )
                                    : ElevatedButton.styleFrom(
                                        primary: Colors.white, // background
                                        onPrimary: Colors.black,
                                        // foreground
                                      ),
                            onPressed: () =>
                                !_isButtonDisabled ? optionChosen(2) : null,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: ElevatedButton(
                            child: Text(_newQuestion.options[3].toString()),
                            style: options[3] == 0
                                ? ElevatedButton.styleFrom(
                                    primary: Colors.red, // background
                                    onPrimary: Colors.white,
                                    // foreground
                                  )
                                : options[3] == 2
                                    ? ElevatedButton.styleFrom(
                                        primary: Colors.green, // background
                                        onPrimary: Colors.white,
                                        // foreground
                                      )
                                    : ElevatedButton.styleFrom(
                                        primary: Colors.white, // background
                                        onPrimary: Colors.black,
                                        // foreground
                                      ),
                            onPressed: () =>
                                !_isButtonDisabled ? optionChosen(3) : null,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        showStatus != 1
                            ? SizedBox(
                                width: 200,
                                height: 50,
                                child: ElevatedButton(
                                  child: Text(_status),
                                  style: showStatus == 2
                                      ? ElevatedButton.styleFrom(
                                          primary: Colors.green, // background
                                          onPrimary: Colors.white,
                                          // foreground
                                        )
                                      : ElevatedButton.styleFrom(
                                          primary: Colors.red, // background
                                          onPrimary: Colors.white,
                                          // foreground
                                        ),
                                  onPressed: nextQuiz,
                                ),
                              )
                            : const SizedBox(
                                height: 50,
                              ),
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: Text(
                              "0:$_seconds",
                              style: const TextStyle(fontSize: 80),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : AlertDialog(
                    title: const Text("Done!"),
                    content: Text(_result),
                    actions: [
                      TextButton(
                          onPressed: restart,
                          child: const Text(
                            "Restart Quiz",
                            style: TextStyle(color: Colors.green),
                          ))
                    ],
                  ));
  }
}
