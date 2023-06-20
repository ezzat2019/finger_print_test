import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureSc extends StatefulWidget {
  const SignatureSc({super.key});

  @override
  State<SignatureSc> createState() => _SignatureScState();
}

class _SignatureScState extends State<SignatureSc> {
  bool isOpen = false;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSignature() {
    _controller.clear();
  }

  void _saveSignature() async {
    final image = await _controller.toPngBytes();
    setState(() {
      isOpen = false;
      _controller.disabled = true;
    });
    // Save the image or perform any other desired action with it
    // For example, you can save it to disk or send it to a server
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isOpen = false;
    _controller.disabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _clearSignature,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSignature,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment:
            isOpen ? MainAxisAlignment.center : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isOpen = true;
                    _controller.disabled = false;
                  });
                },
                child: Transform.scale(
                  scale: isOpen ? 1 : .4,
                  child: Signature(
                    controller: _controller,
                    width: MediaQuery.of(context).size.width - 40,
                    height: 200,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
