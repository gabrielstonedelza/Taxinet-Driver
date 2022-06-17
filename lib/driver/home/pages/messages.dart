import 'package:flutter/material.dart';

import '../fab_widget.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("Messages"),
        ),
        floatingActionButton: myFabMenu(),
      ),
    );
  }
}
