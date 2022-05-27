import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../states/app_state.dart';

class BidPrice extends StatefulWidget {
  String rideId;
  String driver;
  BidPrice({Key? key,required this.rideId,required this.driver}) : super(key: key);

  @override
  State<BidPrice> createState() => _BidPriceState(rideId:this.rideId,driver:this.driver);
}

class _BidPriceState extends State<BidPrice> {
  String rideId;
  String driver;
  _BidPriceState({required this.rideId,required this.driver});
  var uToken = "";
  final storage = GetStorage();
  var username = "";
  late Timer _timer;
  late final TextEditingController _priceController = TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var items;

  bidPrice()async{
    final bidUrl = "https://taxinetghana.xyz/bid_ride/$rideId/";
    final myLink = Uri.parse(bidUrl);
    http.Response response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      "ride": rideId,
      "bid": _priceController.text,
    });
    if(response.statusCode == 201){

    }
    else{
    }
  }
  acceptAndUpdateBidStatus(int id,String message,String bidStatus)async{
    final requestUrl = "https://taxinetghana.xyz/update_bid/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    },body: {
      "bid_accepted": bidStatus,
      "bid_message": message,
    });
    if(response.statusCode == 200){

    }
  }

  rejectAndUpdateBidStatus(int id,String message,String bidStatus)async{
    final requestUrl = "https://taxinetghana.xyz/update_bid/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    },body: {
      "bid_rejected": bidStatus,
      "bid_message": message,
    });
    if(response.statusCode == 200){

    }
  }

  driverAcceptRideAndUpdateStatus(String rideId,String driver,double price)async{
    final requestUrl = "https://taxinetghana.xyz/update_requested_ride/$rideId/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    },body: {
      "driver": driver,
      "ride_accepted": "True",
      "price": price.toString(),
    });
    if(response.statusCode == 200){

    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final appState = Provider.of<AppState>(context,listen:false);
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    appState.getBids(rideId,uToken);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      appState.getBids(rideId,uToken);
      print(appState.allBids.last['bid']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Bid Price"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: RichText(
                text: const TextSpan(
                  text: "Please don't leave this page until the bidding is finalised by you and the passenger",
                  style: TextStyle(fontWeight: FontWeight.bold,color: defaultTextColor2)
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0,right: 18.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _priceController,
                focusNode: _priceFocusNode,
                cursorColor: defaultTextColor2,
                cursorRadius: const Radius.elliptical(10, 10),
                cursorWidth: 5,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send,color: primaryColor,),
                      onPressed: (){
                        FocusScope.of(context).unfocus();
                        if(_priceController.text == ""){
                          Get.snackbar(
                              "Sorry", "price field cannot be empty",
                              snackPosition: SnackPosition.TOP,
                              colorText: defaultTextColor1,
                              backgroundColor: Colors.red
                          );
                        }
                        else{
                          bidPrice();
                          _priceController.text = "";
                        }
                      }
                      ,),
                    hintText: "Enter price",
                    hintStyle: const TextStyle(color: defaultTextColor2,),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 500,
                child:appState.loading ? const Center(
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 5,
                    backgroundColor: primaryColor,
                  ),
                ) : ListView.builder(
                    itemCount: appState.allBids != null ? appState.allBids.length : 0,
                    itemBuilder: (context,index){
                      items = appState.allBids[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Card(
                          child: Row(
                            children: [
                              
                              Expanded(
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Expanded(child: Text("${items['username']}'s bid")),
                                      Expanded(
                                        child: items['bid_message'] != null ? Text(items['bid_message']) : const Text(""),
                                      ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(items['bid'],style: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: IconButton(
                                                    onPressed: (){
                                                      acceptAndUpdateBidStatus(appState.allBids[index]['id'], "Bid was accepted", "True");
                                                    },
                                                    icon: items['bid_accepted'] ? Image.asset("assets/images/thumbs-up.png",width: 20,height: 20,) : Image.asset("assets/images/accep_bid.png",width: 20,height: 20,)
                                                ),
                                              ),

                                              Expanded(
                                                child: IconButton(
                                                    onPressed: (){
                                                      rejectAndUpdateBidStatus(appState.allBids[index]['id'], "Bid was Rejected", "True");
                                                    },
                                                    icon: items['bid_rejected'] ? Image.asset("assets/images/thumbs-down.png",width: 20,height: 20,) : Image.asset("assets/images/reject_bid.png",width: 20,height: 20,)
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0,right: 18.0),
                  child: RawMaterialButton(
                    onPressed: () {
                      driverAcceptRideAndUpdateStatus(rideId,driver,double.parse(appState.allBids.last['bid']));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            12)),
                    elevation: 8,
                    child: const Padding(
                      padding:
                      EdgeInsets.all(8.0),
                      child: Text(
                        "Accept",
                        style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 15,
                            color:
                            defaultTextColor1),
                      ),
                    ),
                    fillColor: primaryColor,
                    splashColor: defaultColor,
                  ),
                ),
                flex: 1,
              ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0,right: 18.0),
                  child: RawMaterialButton(
                    onPressed: () {

                    },
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            12)),
                    elevation: 8,
                    child: const Padding(
                      padding:
                      EdgeInsets.all(8.0),
                      child: Text(
                        "Reject",
                        style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 15,
                            color:
                            defaultTextColor1),
                      ),
                    ),
                    fillColor: Colors.red,
                    splashColor: defaultColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
