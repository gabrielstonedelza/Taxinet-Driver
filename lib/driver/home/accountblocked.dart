import "package:flutter/material.dart";

class AccountBlockNotification extends StatelessWidget {
  const AccountBlockNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Image.asset("assets/images/ad.png",fit: BoxFit.cover,),
            const SizedBox(height: 20),
            const Center(
                child: Text("Sorry,your account is blocked.",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
            ),
            const SizedBox(height: 20),
            const Center(
                child: Text("Please contact the administrator.",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
            ),
          ],
        )
    );
  }
}
