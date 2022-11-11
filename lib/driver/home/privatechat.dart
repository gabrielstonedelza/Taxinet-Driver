import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";

import 'package:get_storage/get_storage.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_colors.dart';

class PrivateChat extends StatefulWidget {
  final receiverId;
  String passengerUsername;

  PrivateChat({Key? key,required this.receiverId,required this.passengerUsername}) : super(key: key);

  @override
  State<PrivateChat> createState() => _PrivateChatState(receiverId:this.receiverId,passengerUsername:this.passengerUsername);
}

class _PrivateChatState extends State<PrivateChat> {
  final receiverId;
  String passengerUsername;
  _PrivateChatState({required this.receiverId,required this.passengerUsername});
  late String username = "";
  String profileId = "";
  final storage = GetStorage();
  bool hasToken = false;
  late String uToken = "";
  List privateMessages = [];
  bool isLoading = true;
  late Timer _timer;
  late final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();


  sendPrivateMessage() async {
    const bidUrl = "https://taxinetghana.xyz/send_private_message/";
    final myLink = Uri.parse(bidUrl);
    http.Response response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      "sender": profileId,
      "receiver": receiverId,
      "message": messageController.text,
    });
    if (response.statusCode == 201) {
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  fetchAllPrivateMessages() async {
    final url = "https://taxinetghana.xyz/get_private_message/$profileId/$receiverId/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $uToken"});

    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      privateMessages = json.decode(jsonData);
    //
    }
    else{
      if (kDebugMode) {
        print(response.body);
        print("This error is coming from the fetch private chat messages");
      }
    }
    setState(() {
      isLoading = false;
      privateMessages = privateMessages;
    });
  }

  @override
  void initState(){
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    if (storage.read("profile_id") != null) {
      setState(() {
        hasToken = true;
        profileId = storage.read("profile_id");
      });
    }
    fetchAllPrivateMessages();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchAllPrivateMessages();
    });
    print(uToken);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
            backgroundColor:Colors.grey,
            appBar: AppBar(
              elevation: 0,
              title: Text(passengerUsername),
              backgroundColor: primaryColor,
            ),
            body: Column(
              children: [
                Expanded(
                  child: GroupedListView<dynamic, String>(
                    padding: const EdgeInsets.all(8),
                    reverse:true,
                    order: GroupedListOrder.DESC,
                    elements: privateMessages,
                    groupBy: (message) => message['timestamp'],
                    groupSeparatorBuilder: (String groupByValue) => Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(groupByValue,style: const TextStyle(fontSize: 0,fontWeight: FontWeight.bold,color: Colors.transparent),),
                    ),
                    // groupHeaderBuilder: (),
                    itemBuilder: (context, dynamic message) => Align(
                      alignment: message['sender'] == profileId ? Alignment.centerRight : Alignment.centerRight,
                      child: SlideInUp(
                        animate: true,
                        child: Card(
                          color: message['get_senders_username'] == username ? Colors.blue : Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            elevation:8,
                            child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom:18.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          message['get_senders_username'] == username ?  const Text("") : Text(message['get_senders_username'],style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.white),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom:18.0),
                                      child: SelectableText(
                                        message['message'],
                                        showCursor: true,
                                        cursorColor: Colors.blue,
                                        cursorRadius: const Radius.circular(10),
                                       style: const TextStyle(color:Colors.white)
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(message['timestamp'].toString().split("T").first,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),),
                                        const SizedBox(width: 20,),
                                        Text(message['timestamp'].toString().split("T").last.substring(0,8),style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),),
                                      ],
                                    ),
                                  ],
                                )
                            )),
                      ),
                    ),
                    // itemComparator: (item1, item2) => item1['get_username'].compareTo(item2['get_username']), // optional
                    useStickyGroupSeparators: true, // optional
                    floatingHeader: true, // optional
                    // order: GroupedListOrder.ASC, // optional
                  ),
                ),
                Card(
                  elevation:12,
                  shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      color:Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.only(left:15.0),
                        child: TextFormField(
                          controller: messageController,
                          focusNode: messageFocusNode,
                          cursorColor: defaultTextColor2,
                          cursorRadius: const Radius.elliptical(10, 10),
                          cursorWidth: 5,
                          maxLines: null,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (messageController.text == "") {
                                    Get.snackbar("Sorry", "message field cannot be empty",
                                        snackPosition: SnackPosition.TOP,
                                        colorText: defaultTextColor1,
                                        backgroundColor: Colors.red);
                                  } else {
                                    sendPrivateMessage();
                                    messageController.text = "";
                                  }
                                },
                              ),
                              hintText: "Message here.....",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent, width: 2),
                                  borderRadius: BorderRadius.circular(12))
                          ),
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
        )
    );
  }
}
