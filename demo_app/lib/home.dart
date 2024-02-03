import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:demo_app/my_keys.dart';

class CareerChatbotPage extends StatefulWidget {
  @override
  _CareerChatbotPageState createState() => _CareerChatbotPageState();
}

class _CareerChatbotPageState extends State<CareerChatbotPage> {
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _minimumSalaryController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();

  List<String?> _response = [];

  _generateBot() async {
    print("clicked");
    String profession = _professionController.text;
    double minimumSalary =
        double.tryParse(_minimumSalaryController.text) ?? 0.0;
    String location = _locationController.text;
    double distance = double.tryParse(_distanceController.text) ?? 0.0;

    try {
      // The user message to be sent to the request.
      final userMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            'Create a bot for profession: $profession, minimum salary: $minimumSalary, location: $location, distance: $distance',
          ),
        ],
        role: OpenAIChatMessageRole.user,
      );

      final chatStream = OpenAI.instance.chat.createStream(
        model: "gpt-3.5-turbo",
        messages: [
          userMessage,
        ],
        seed: 423,
        n: 2,
      );

// Listen to the stream.
      chatStream.listen(
        (streamChatCompletion) {
          final content = streamChatCompletion.choices.first.delta.content;
          setState(() {
            _response.insert(_response.length, content?[0].text);
            print(_response);
          });
        },
        onDone: () {
          print("Done");
        },
      );
    } catch (e) {
      print("There was an error");
      setState(() {
        _response = ['Error: $e'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Chatbot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _professionController,
              decoration: const InputDecoration(labelText: 'Profession'),
            ),
            TextField(
              controller: _minimumSalaryController,
              decoration: const InputDecoration(labelText: 'Minimum Salary'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _distanceController,
              decoration: const InputDecoration(labelText: 'Distance'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _generateBot();
                });
              },
              child: const Text('Generate Bot'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_response.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
