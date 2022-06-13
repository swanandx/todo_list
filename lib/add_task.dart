import 'package:flutter/material.dart';

class AddTask extends StatelessWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        child: const PageContent(),
        builder: (context, dynamic value, child) {
          return ShaderMask(
              shaderCallback: (rect) {
                return RadialGradient(
                        radius: value * 5,
                        colors: const [
                          Colors.white,
                          Colors.white,
                          Colors.transparent,
                          Colors.transparent
                        ],
                        stops: const [0.0, 0.65, 0.7, 1.0],
                        center: const FractionalOffset(0.95, 0.95))
                    .createShader(rect);
              },
              child: child);
        });
  }
}

class PageContent extends StatefulWidget {
  const PageContent({Key? key}) : super(key: key);

  @override
  State<PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // backgroundColor: Colors.purple,
      body: Center(
        child: TextFormField(
          controller: myController,
          decoration: const InputDecoration(
              hintText: 'Enter the Task',
              hintStyle: TextStyle(color: Colors.white38),
              contentPadding: EdgeInsets.symmetric(horizontal: 20)),
          style: const TextStyle(
            fontSize: 32,
            // color: Colors.white
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: () {
          Navigator.pop(context, myController.text);
        },
        label: const Text('Add Task to list'),
      ),
    );
  }
}
