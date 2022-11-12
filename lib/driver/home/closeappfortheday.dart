import "package:flutter/material.dart";

class CloseAppForDay extends StatelessWidget {
  const CloseAppForDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
                child: Text("Sorry app is closed for the day",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
            ),
            Center(
                child: Text("App will resume at working times only.",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
            ),
          ],
        )
    );
  }
}

