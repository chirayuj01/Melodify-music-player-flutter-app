import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:moodhub/Core/Configs/Theme/App_colors.dart';
import 'package:shimmer/shimmer.dart';

class helperAI extends StatefulWidget {
  @override
  State<helperAI> createState() => _HelperAIState();
}

class _HelperAIState extends State<helperAI> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser user = ChatUser(id: '00', firstName: 'User');
  ChatUser AI = ChatUser(id: '11', firstName: 'melodifyAI', profileImage: 'assets/images/AI music.png');
  bool isLoading = true; // Add a loading flag

  @override
  void initState() {
    super.initState();
    sendInitialPrompt(); // Trigger AI initial message
  }

  void sendInitialPrompt() {
    // AI initial prompt
    String initialPrompt = 'Hello! I\'m MelodifyAI, your personal music companion. I\'m here to enhance your mood with perfectly curated tunes. Feel free to ask me anything';

    // Simulate AI response with shimmer effect
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        ChatMessage aiMessage = ChatMessage(user: AI, createdAt: DateTime.now(), text: initialPrompt);
        messages = [aiMessage, ...messages];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 10),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Row(
              children: [
                SizedBox(width: 30,),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: <Color>[
                        Color(0xff7A1CAC),
                        App_Colors.primary,
                        Color(0xff7A1CAC)
                      ],
                      begin: Alignment.topLeft,  // Define the gradient direction
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    'MelodifyAI :  ',
                    style: TextStyle(
                      color: Colors.white, // The color here doesn't matter as it's replaced by the gradient
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w900,
                      fontSize: 25,
                    ),
                  ),
                ),

                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    RotateAnimatedText('Smart Picks', textStyle: TextStyle(
                      color: App_Colors.grey,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    )),
                    RotateAnimatedText('AI Curated Hits', textStyle: TextStyle(
                      color: App_Colors.grey,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                    )),
                    RotateAnimatedText('Helper AI', textStyle: TextStyle(
                      color: App_Colors.grey,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
          child: bodyAI(),
        ),
      ),
    );
  }

  Widget bodyAI() {
    return Column(
      children: [
         Expanded(child: DashChat(
          currentUser: user,
          onSend: onSend,
          messages: messages,
          inputOptions: InputOptions(inputTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          )),
        )),
      ],
    );
  }



  void onSend(ChatMessage message) {
    setState(() {
      messages = [message, ...messages];
    });

    try {
      String prompt = message.text;
      gemini.streamGenerateContent(prompt).listen((event) {
        ChatMessage? lastPrompt = messages.firstOrNull;
        if (lastPrompt != null && lastPrompt.user == gemini) {
          messages.removeAt(0);
          String aiMessage = event.content?.parts?.fold('', (previous, current) => '$previous ${current.text}') ?? '';
          lastPrompt.text += aiMessage;
          setState(() {
            messages = [lastPrompt!, ...messages];
          });
        } else {
          String aiMessage = event.content?.parts?.fold('', (previous, current) => '$previous ${current.text}') ?? '';
          ChatMessage message = ChatMessage(user: AI, createdAt: DateTime.now(), text: aiMessage);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
