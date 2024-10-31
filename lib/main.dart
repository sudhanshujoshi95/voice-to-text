import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(const VoiceToTextApp());
}

class VoiceToTextApp extends StatelessWidget {
  const VoiceToTextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VoiceToTextScreen(),
    );
  }
}

class VoiceToTextScreen extends StatefulWidget {
  const VoiceToTextScreen({super.key});

  @override
  _VoiceToTextScreenState createState() => _VoiceToTextScreenState();
}

class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Press the mic to start recording";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _showRecordingDialog();
      _speech.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
    Navigator.pop(context); // Close the recording dialog
  }

  void _showRecordingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Recording..."),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Your voice is being recorded"),
            SizedBox(height: 10),
            SpinKitWave(color: Colors.blue, size: 30), // Loading animation
          ],
        ),
        actions: [
          TextButton(
            onPressed: _stopListening,
            child: const Text("Finish"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice to Text Example")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: _text),
              readOnly: true,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Recognized Text",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.mic),
              color: _isListening ? Colors.red : Colors.blue,
              iconSize: 50,
              onPressed: _isListening ? _stopListening : _startListening,
            ),
          ],
        ),
      ),
    );
  }
}
