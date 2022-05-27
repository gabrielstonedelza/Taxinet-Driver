import 'package:flutter/material.dart';


class ProgressDialog extends StatelessWidget {
  String? message;
  ProgressDialog({Key? key,required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black54,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(),
          borderRadius: BorderRadius.circular(6)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const SizedBox(height: 6,),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 26,),
              Text(message!,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.grey,fontSize: 12),)
            ],
          ),
        ),
      ),
    );
  }
}

