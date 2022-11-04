import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class SendSmsController{
  //Flutter HTTP Implementation

  sendMySms(String recp, String sen, String message) async{
    const apiKey = 'TG0VqHEFA9ZoqNtnw43GdVkKnBSBIpf2'; //Remember to put your account API Key here
    final recipient = recp; //International format (233) or (+233)
    final sender = sen; //11 Characters maximum
    final msg = message;
    final url = 'https://sms.textcus.com/api/send?apikey=$apiKey&destination=$recipient&source=$sender&dlr=0&type=0&message=$msg';   // append parameters to the right position in the url

    final myLink = Uri.parse(url);
    final response = await http.get(myLink);   // This is a GET HTTP request

// Get response from your request
    if(response.statusCode == 200){
      //all good
      if (kDebugMode) {
        print('Response is: ${response.body}');
      }
    } else {
      if (kDebugMode) {
        print('There was an issue sending message: ${response.body}');
      }
    }
  }
}