import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import "package:get/get.dart";

import 'package:get_storage/get_storage.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_colors.dart';

class NewChat extends StatefulWidget {
  final receiverId;
  final receiverUsername;
  final receiverPhone;
  const NewChat({Key? key,required this.receiverId,required this.receiverUsername,required this.receiverPhone}) : super(key: key);

  @override
  State<NewChat> createState() => _NewChatState(receiverId:this.receiverId,receiverUsername:this.receiverUsername,receiverPhone:this.receiverPhone);
}

class _NewChatState extends State<NewChat> {
  final receiverId;
  final receiverUsername;
  final receiverPhone;
  _NewChatState({required this.receiverId,required this.receiverUsername,required this.receiverPhone});
  _callNumber(String phoneNumber) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

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
  var items;


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
    return Scaffold(
      backgroundColor: Colors.indigo,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(receiverUsername),
          actions: [
            IconButton(
              onPressed: (){
                _callNumber(receiverPhone);
              },
              icon: const Icon(Icons.phone_outlined)
            )
          ],
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          // Expanded(
          //   child: Container(
          //     padding: const EdgeInsets.only(left:25,right: 25,top:25),
          //     width: double.infinity,
          //     decoration: const BoxDecoration(
          //         borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(45),
          //             topRight: Radius.circular(45)
          //         ),
          //         color: Colors.white
          //     ),
          //     child: ListView.builder(
          //         physics: const BouncingScrollPhysics(),
          //         itemCount: privateMessages != null ? privateMessages.length : 0,
          //         itemBuilder: (context,index){
          //           items = privateMessages[index];
          //           return Row(
          //             mainAxisAlignment: items['sender'] == profileId ? MainAxisAlignment.end : MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.end,
          //             children: [
          //               items['get_senders_username'] == username ?  CircleAvatar(
          //                 backgroundImage: NetworkImage(items['get_sender_profile_pic']),
          //                 radius: 20,
          //               ) : Container(),
          //               Flexible(
          //                   child: Container(
          //                       margin: const EdgeInsets.only(left:10, right:10,top:20),
          //                       padding: const EdgeInsets.all(20),
          //                       decoration:BoxDecoration(
          //                           color: Colors.indigo.shade100,
          //                           borderRadius:  items['get_senders_username'] == username ? const BorderRadius.only(
          //                               topLeft: Radius.circular(30),
          //                               topRight: Radius.circular(30),
          //                               bottomLeft: Radius.circular(30)
          //                           ) : const BorderRadius.only(
          //                               topLeft: Radius.circular(30),
          //                               topRight: Radius.circular(30),
          //                               bottomRight: Radius.circular(30)
          //                           )
          //                       ),
          //                       child: Text(items['message'])
          //                   )
          //               )
          //             ],
          //           );
          //         }
          //     ),
          //   ),
          // ),
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
              itemBuilder: (context, dynamic message) => SlideInUp(
                animate: true,
                child: Row(
                  mainAxisAlignment:message['get_senders_username'] == username ? MainAxisAlignment.start : MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    message['get_senders_username'] == username ?  CircleAvatar(
                      backgroundImage: NetworkImage(message['get_sender_profile_pic']),
                      radius: 20,
                    ) : Container(),
                    Flexible(
                        child: Container(
                            margin: const EdgeInsets.only(left:10, right:10,top:20),
                            padding: const EdgeInsets.all(20),
                            decoration:BoxDecoration(
                                color: Colors.indigo.shade100,
                                borderRadius:  message['get_senders_username'] == username ? const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30)
                                ) : const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30)
                                )
                            ),
                            child: Column(
                              children: [
                                Text(message['message']),
                                const SizedBox(height:10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(message['timestamp'].toString().split("T").first,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),),
                                    const SizedBox(width: 20,),
                                    Text(message['timestamp'].toString().split("T").last.substring(0,8),style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),),
                                  ],
                                ),
                              ],
                            )
                        )
                    )
                  ],
                ),
              ),
              // itemComparator: (item1, item2) => item1['get_username'].compareTo(item2['get_username']), // optional
              useStickyGroupSeparators: true, // optional
              floatingHeader: true, // optional
              // order: GroupedListOrder.ASC, // optional
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
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
    );
  }
}
