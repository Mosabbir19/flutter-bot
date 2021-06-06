import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'BotSuggestions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //speech to text conversion
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }
//
////////expand by character
  // int charLength = 0;
  // double textFieldLength = 45;
  // _onChanged(String value) {
  //   setState(() {
  //     charLength = value.length;
  //     if (charLength < 26)
  //       textFieldLength = 45;
  //     else if (charLength > 26 && charLength < 46) {
  //       textFieldLength = 65;
  //     } else if (charLength > 50) {
  //       textFieldLength = 88;
  //     } else
  //       textFieldLength = 45;
  //   });
  // }

//text box line count
  int lineLength = 1;
  int charLength = 0;
  double textFieldLength = 45;
  _onChanged(String value) {
    setState(() {
      charLength = value.length;
      lineLength = '\n'.allMatches(value).length + 1;
      if (lineLength == 1)
        textFieldLength = 45;
      else if (lineLength == 2) {
        textFieldLength = 65;
      } else if (lineLength >= 3) {
        textFieldLength = 88;
      } else
        textFieldLength = 45;
    });
  }

  List<String> suggestion = ['Hi', 'Appointment', 'Official Number'];

  // void check(userMessage) async {
  //   print('User: $userMessage');
  //   AuthGoogle authGoogle =
  //       await AuthGoogle(fileJson: 'assets/mechabot-w9dg-398cd9a005e1.json')
  //           .build();
  //   Dialogflow dialogflow =
  //       Dialogflow(authGoogle: authGoogle, language: Language.english);
  //   AIResponse response = await dialogflow.detectIntent(userMessage);
  //   var botSuggestions =
  //       BotSuggestions(response.getListMessage()[0]["text"]["text"][0]);
  //   print('Bot: ${response.getMessage()}');
  //   print('Suggestions: ${botSuggestions.suggestions}');

  //   // userMessage = botSuggestions.suggestions.first;
  //   // print('User: $userMessage');
  //   // response = await dialogflow.detectIntent(userMessage);
  //   // botSuggestions = BotSuggestions(response.getListMessage());
  //   // print('Bot: ${response.getMessage()}');
  //   // print('Suggestions: ${botSuggestions.suggestions}');
  // }

  //dialogflow is called
  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: 'assets/mecha-bot-310913-d602a566da35.json')
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    // print(aiResponse.getListMessage()[0]["text"]["text"][0]);
    setState(() {
      messages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
  }

  final TextEditingController messageInsert = TextEditingController();
  List<Map> messages = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mecha Bot'),
          backgroundColor: Color(0xff053d45),
        ),
        body: Container(
            //background image
            decoration: new BoxDecoration(
              image: new DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.white.withOpacity(0.2), BlendMode.dstATop),
                image: new AssetImage("assets/launcher icon.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.all(20.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 8, bottom: 8),
                        child: Align(
                          alignment: (messages[index]["data"] == 0
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (messages[index]["data"] == 0
                                  ? Colors.grey.shade200
                                  : Colors.teal[100]),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              messages[index]["message"],
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionChip(
                          backgroundColor: Colors.grey[300],
                          label: Text(suggestion[0]),
                          onPressed: () {
                            setState(() {
                              messageInsert.text = suggestion[0];
                              messages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }),
                      ActionChip(
                          backgroundColor: Colors.grey[300],
                          label: Text(suggestion[1]),
                          onPressed: () {
                            setState(() {
                              messageInsert.text = suggestion[1];
                              messages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }),
                      ActionChip(
                          backgroundColor: Colors.grey[300],
                          label: Text(suggestion[2]),
                          onPressed: () {
                            setState(() {
                              messageInsert.text = suggestion[2];
                              messages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }),
                    ],
                  ),
                ),
                Container(
                  // padding: EdgeInsets.only(bottom: 10.0, top: 5.0),
                  // margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: EdgeInsets.only(bottom: 12.0),
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        // child: Container(
                        //   height: textFieldLength,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.all(Radius.circular(25)),
                        //     color: Colors.teal[50],
                        //   ),
                        //   padding: EdgeInsets.only(left: 15),
                        //   child: TextField(
                        //     expands: true,
                        //     controller: messageInsert,
                        //     keyboardType: TextInputType.multiline,
                        //     maxLines: null,
                        //     onChanged: _onChanged,
                        //     decoration: InputDecoration(
                        //       hintText: "Send your message",
                        //       border: InputBorder.none,
                        //       focusedBorder: InputBorder.none,
                        //       enabledBorder: InputBorder.none,
                        //       errorBorder: InputBorder.none,
                        //       disabledBorder: InputBorder.none,
                        //     ),
                        //   ),
                        // ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Colors.teal[50],
                          ),
                          padding: EdgeInsets.only(left: 10.0, right: 2.0),
                          child: new ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 155.0),
                            child: TextField(
                              // expands: true,
                              controller: messageInsert,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onChanged: _onChanged,
                              decoration: InputDecoration(
                                hintText: "Send your message",
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            child: AvatarGlow(
                              animate: _isListening,
                              glowColor: Theme.of(context).primaryColor,
                              endRadius: 30,
                              duration: const Duration(milliseconds: 2000),
                              repeatPauseDuration:
                                  const Duration(milliseconds: 100),
                              repeat: true,
                              child: IconButton(
                                onPressed: _listen,
                                icon: Icon(
                                  _isListening ? Icons.mic : Icons.mic_none,
                                  color: Colors.teal[800],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            // child: FloatingActionButton(
                            //   backgroundColor: Colors.white,
                            //   child: Icon(
                            //     Icons.send,
                            //     color: Colors.teal[800],
                            //   ),
                            child: IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Colors.teal[800],
                              ),
                              onPressed: () {
                                _isListening = false;
                                textFieldLength = 45;
                                if (messageInsert.text.isEmpty) {
                                  // print("empty message");
                                } else {
                                  setState(() {
                                    messages.insert(0, {
                                      "data": 1,
                                      "message": messageInsert.text
                                    });
                                  });
                                  response(messageInsert.text);
                                  messageInsert.clear();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

//voice listening and convert to text
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          onStatus: (val) => {
                print('onStatus: $val'),
                if (val == 'notListening')
                  {setState(() => _isListening = false)}
              },
          onError: (val) => print('onError: $val'));
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            messageInsert.text = _text;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
