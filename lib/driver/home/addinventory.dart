import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:get_storage/get_storage.dart';
import 'package:taxinet_driver/driver/home/pages/inventories.dart';
import '../../bottomnavigation.dart';
import '../../constants/app_colors.dart';
import 'package:http/http.dart' as http;

import '../../controllers/walletcontroller.dart';
import '../../g_controllers/user/user_controller.dart';
import '../../sendsms.dart';

enum WindScreenEnum { okay, no }
enum SideMirrorEnum { okay, no }
enum RegPlateEnum { okay, no }
enum TirePressureEnum { okay, no }
enum DrivingMirrorEnum { okay, no }
enum TireDepthEnum { okay, no }
enum WheelNutsEnum { okay, no }
enum EngineOilEnum { okay, no }
enum FuelLevelEnum { okay, no }
enum BreakFluidEnum { okay, no }
enum EngineCoolantEnum { okay, no }
enum SteeringFluidEnum { okay, no }
enum WiperWasherEnum { okay, no }
enum SeatBeltsEnum { okay, no }
enum SteeringWheelEnum { okay, no }
enum HornEnum { okay, no }
enum ElectricWindowsEnum { okay, no }
enum WindScreenWiperEnum { okay, no }
enum HeadLightsEnum { okay, no }
enum TrafficatorsEnum { okay, no }
enum TailLightsEnum { okay, no }
enum ReverseLightsEnum { okay, no }
enum InteriorLightsEnum { okay, no }
enum EngineNoiseEnum { okay, no }
enum ExcessiveSmokeEnum { okay, no }
enum FootBreakEnum { okay, no }
enum HandBreakEnum { okay, no }
enum WheelBearingNoiseEnum { okay, no }
enum TriangleEnum { okay, no }
enum FireExtinguisherEnum { okay, no }
enum FirstAidBoxEnum { okay, no }

class AddInventory extends StatefulWidget {
  const AddInventory({Key? key}) : super(key: key);

  @override
  State<AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  WalletController walletController = Get.find();
  final UserController userController = Get.find();
  WindScreenEnum? _windScreenEnum;
  SideMirrorEnum? _sideMirrorEnum;
  RegPlateEnum? _regPlateEnum;
  TirePressureEnum? _tirePressureEnum;
  DrivingMirrorEnum? _drivingMirrorEnum;
  TireDepthEnum? _tireDepthEnum;
  WheelNutsEnum? _wheelNutsEnum;
  EngineOilEnum? _engineOilEnum;
  FuelLevelEnum? _fuelLevelEnum;
  BreakFluidEnum? _breakFluidEnum;
  EngineCoolantEnum? _engineCoolantEnum;
  SteeringFluidEnum? _steeringFluidEnum;
  WiperWasherEnum? _wiperWasherEnum;
  SeatBeltsEnum? _seatBeltsEnum;
  SteeringWheelEnum? _steeringWheelEnum;
  HornEnum? _hornEnum;
  ElectricWindowsEnum? _electricWindowsEnum;
  WindScreenWiperEnum? _windScreenWiperEnum;
  HeadLightsEnum? _headLightsEnum;
  TrafficatorsEnum? _trafficatorsEnum;
  TailLightsEnum? _tailLightsEnum;
  ReverseLightsEnum? _reverseLightsEnum;
  InteriorLightsEnum? _interiorLightsEnum;
  EngineNoiseEnum? _engineNoiseEnum;
  ExcessiveSmokeEnum? _excessiveSmokeEnum;
  FootBreakEnum? _footBreakEnum;
  HandBreakEnum? _handBreakEnum;
  WheelBearingNoiseEnum? _wheelBearingNoiseEnum;
  TriangleEnum? _triangleEnum;
  FireExtinguisherEnum? _fireExtinguisherEnum;
  FirstAidBoxEnum? _firstAidBoxEnum;

  var uToken = "";
  final storage = GetStorage();
  var username = "";
  var userId = "";

  List toyotaBrands = [
    'Select a brand',
    'Avalon',
    'BELTA',
    'CAMRY',
    'CENTURY',
    'ALLION',
    'LEVIN GT',
    'CROWN',
    'ETIOS',
    'MIRAI',
    'PRIUS',
    'AGYA',
    'AQUA',
    'COROLLA',
    'ETIOS',
    'GLANZA',
    'PASSO',
    'YARIS',
    '4RUNNER',
    'VENZA',
    'HIGHLANDER',
    'LAND CRUISER',
    'RAV4',
    'RUSH',
    'Vitz'
  ];
  String _currentSelectedBrand = "Select a brand";
  double amountToPay = 70.0;
  double amount = 0.0;
  bool canPayToday = false;
  
  late final  TextEditingController _registrationNumberController = TextEditingController();
  late final  TextEditingController _uniqueNumberController = TextEditingController();
  late final  TextEditingController _millageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isPosting = false;
  var userWalletId = "";
  final SendSmsController sendSms = SendSmsController();
  double commission = 0.0;

  void _startPosting()async{
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isPosting = false;
    });
  }

  processInventory()async {
    const requestUrl = "https://taxinetghana.xyz/add_drivers_inventories/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    },
        body: {
      "vehicle_brand": _currentSelectedBrand,
      "registration_number": _registrationNumberController.text.trim(),
      "unique_number": _uniqueNumberController.text.trim(),
      "millage": _millageController.text.trim(),
      "windscreen": _windScreenEnum?.name,
      "side_mirror": _sideMirrorEnum?.name,
      "registration_plate": _regPlateEnum?.name,
      "tire_pressure": _tirePressureEnum?.name,
      "driving_mirror": _drivingMirrorEnum?.name,
      "tire_thread_depth": _tireDepthEnum?.name,
      "wheel_nuts": _wheelNutsEnum?.name,
      "engine_oil": _engineOilEnum?.name,
      "fuel_level": _fuelLevelEnum?.name,
      "break_fluid": _breakFluidEnum?.name,
      "radiator_engine_coolant": _engineCoolantEnum?.name,
      "power_steering_fluid": _steeringFluidEnum?.name,
      "wiper_washer_fluid": _wiperWasherEnum?.name,
      "seat_belts": _seatBeltsEnum?.name,
      "steering_wheel": _steeringWheelEnum?.name,
      "horn": _hornEnum?.name,
      "electric_windows": _electricWindowsEnum?.name,
      "windscreen_wipers": _windScreenWiperEnum?.name,
      "head_lights": _headLightsEnum?.name,
      "trafficators": _trafficatorsEnum?.name,
      "tail_rear_lights": _tailLightsEnum?.name,
      "reverse_lights": _reverseLightsEnum?.name,
      "interior_lights": _interiorLightsEnum?.name,
      "engine_noise": _engineNoiseEnum?.name,
      "excessive_smoke": _excessiveSmokeEnum?.name,
      "foot_break": _footBreakEnum?.name,
      "hand_break": _handBreakEnum?.name,
      "wheel_bearing_noise": _wheelBearingNoiseEnum?.name,
      "warning_triangle": _triangleEnum?.name,
      "fire_extinguisher": _fireExtinguisherEnum?.name,
      "first_aid_box": _firstAidBoxEnum?.name,
      "inspector_name": "Dudu Faisal",
    });
    if(response.statusCode == 201){
      setState(() {
        commission = 0.10 * amountToPay;
      });
      Get.snackbar("Success 😀", "inventory added.",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: defaultTextColor1);
      updateDriversWallet();
      processPaymentToday();
      addToDriverCommissionToday(commission.toStringAsFixed(2));
      Get.offAll(() => const MyBottomNavigationBar());
    }
    else{
      Get.snackbar("Sorry", "something went wrong. Please try again",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: defaultTextColor1);
    }
  }

  processPaymentToday()async {
    const requestUrl = "https://taxinetghana.xyz/add_to_drivers_payment_today/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
    "Content-Type": "application/x-www-form-urlencoded",
    'Accept': 'application/json',
    "Authorization": "Token $uToken"
    }, body: {

      "amount": amount.toStringAsFixed(2),
    });
    if(response.statusCode == 201){
      String trackerSim = userController.driversTrackerSim;
      // trackerSim = trackerSim.replaceFirst("0", '+233');
      sendSms.sendMySms(trackerSim, "0244529353", "relay,0\%23#");

      String driversPhone = userController.phoneNumber;
      // driversPhone = driversPhone.replaceFirst("0", '+233');
      sendSms.sendMySms(driversPhone, "Taxinet",
          "Attention!,your car is now unlocked.You can start in one minute");
    }
    else{
      if (kDebugMode) {
        // print("This is coming from the process add to drivers payment ${response.body}");
      }
    }
  }

  updateDriversWallet()async {
    final requestUrl = "https://taxinetghana.xyz/user_update_wallet/$userWalletId/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "user": walletController.userUpdatingWallet,
      "amount": amount.toStringAsFixed(2),
    });
    if(response.statusCode == 200){

    }
    else{
      if (kDebugMode) {
        // print("This is coming from update drivers payment ${response.body}");
      }
    }
  }

  addToDriverCommissionToday(String driverCommission)async {
    const requestUrl = "https://taxinetghana.xyz/add_driver_commission/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "driver": userController.driverProfileId,
      "amount": driverCommission,
    });
    if(response.statusCode == 201){

    }
    else{
      if (kDebugMode) {
        // print("This is coming from the process add to drivers payment ${response.body}");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    if (storage.read("userid") != null) {
      userId = storage.read("userid");
    }
    walletController.getUserWallet(uToken);
    userWalletId = walletController.walletId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
          // backgroundColor:primaryColor,
        appBar: AppBar(
          title: const Text("Add Inventory",style:TextStyle(color: defaultTextColor2)),
          centerTitle: true,
          backgroundColor:Colors.transparent,
          elevation:0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),

        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: ListView(
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key:_formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: DropdownButton(
                              isExpanded: true,
                              underline: const SizedBox(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                              items: toyotaBrands.map((dropDownStringItem) {
                                return DropdownMenuItem(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                _onDropDownItemSelectedBrand(newValueSelected);
                              },
                              value: _currentSelectedBrand,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 10),
                            child: TextFormField(
                              controller: _registrationNumberController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Registration Number",
                                hintStyle: TextStyle(color: defaultTextColor2,),
                              ),
                              cursorColor: defaultTextColor2,
                              style: const TextStyle(color: defaultTextColor2),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter registration number";
                                }
                                else{
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 10),
                            child: TextFormField(
                              controller: _uniqueNumberController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Unique Number",
                                hintStyle: TextStyle(color: defaultTextColor2,),
                              ),
                              cursorColor: defaultTextColor2,
                              style: const TextStyle(color: defaultTextColor2),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter unique number";
                                }
                                else{
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 10),
                            child: TextFormField(
                              controller: _millageController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Millage",
                                hintStyle: TextStyle(color: defaultTextColor2,),
                              ),
                              cursorColor: defaultTextColor2,
                              style: const TextStyle(color: defaultTextColor2),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter millage";
                                }
                                else{
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text("Windscreen",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<WindScreenEnum>(
                                    contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: WindScreenEnum.okay,
                                      groupValue: _windScreenEnum,
                                      title: Text(WindScreenEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _windScreenEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<WindScreenEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: WindScreenEnum.no,
                                      groupValue: _windScreenEnum,
                                      title: Text(WindScreenEnum.no.name),
                                      dense: true,
                                      onChanged: (value){
                                        setState(() {
                                          _windScreenEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text("Side Mirror",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 50),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<SideMirrorEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: SideMirrorEnum.okay,
                                      groupValue: _sideMirrorEnum,
                                      title: Text(SideMirrorEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _sideMirrorEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<SideMirrorEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: SideMirrorEnum.no,
                                      groupValue: _sideMirrorEnum,
                                      title: Text(SideMirrorEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _sideMirrorEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text("Registration Plate",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<RegPlateEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: RegPlateEnum.okay,
                                      groupValue: _regPlateEnum,
                                      title: Text(RegPlateEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _regPlateEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<RegPlateEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: RegPlateEnum.no,
                                      groupValue: _regPlateEnum,
                                      title: Text(RegPlateEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _regPlateEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text("Tire Pressure",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<TirePressureEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: TirePressureEnum.okay,
                                      groupValue: _tirePressureEnum,
                                      title: Text(TirePressureEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _tirePressureEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<TirePressureEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: TirePressureEnum.no,
                                      groupValue: _tirePressureEnum,
                                      title: Text(TirePressureEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _tirePressureEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text("Driving Mirror",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<DrivingMirrorEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: DrivingMirrorEnum.okay,
                                      groupValue: _drivingMirrorEnum,
                                      title: Text(DrivingMirrorEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _drivingMirrorEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<DrivingMirrorEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: DrivingMirrorEnum.no,
                                      groupValue: _drivingMirrorEnum,
                                      title: Text(DrivingMirrorEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _drivingMirrorEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Text("Tire Depth",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<TireDepthEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: TireDepthEnum.okay,
                                      groupValue: _tireDepthEnum,
                                      title: Text(TireDepthEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _tireDepthEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<TireDepthEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: TireDepthEnum.no,
                                      groupValue: _tireDepthEnum,
                                      title: Text(TireDepthEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _tireDepthEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Wheel Nuts",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<WheelNutsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: WheelNutsEnum.okay,
                                      groupValue: _wheelNutsEnum,
                                      title: Text(WheelNutsEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _wheelNutsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<WheelNutsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: WheelNutsEnum.no,
                                      groupValue: _wheelNutsEnum,
                                      title: Text(WheelNutsEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _wheelNutsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Engine Oil",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<EngineOilEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: EngineOilEnum.okay,
                                      groupValue: _engineOilEnum,
                                      title: Text(EngineOilEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _engineOilEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<EngineOilEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: EngineOilEnum.no,
                                      groupValue: _engineOilEnum,
                                      title: Text(EngineOilEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _engineOilEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Fuel Level",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<FuelLevelEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: FuelLevelEnum.okay,
                                      groupValue: _fuelLevelEnum,
                                      title: Text(FuelLevelEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _fuelLevelEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<FuelLevelEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: FuelLevelEnum.no,
                                      groupValue: _fuelLevelEnum,
                                      title: Text(FuelLevelEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _fuelLevelEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Break Fluid",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<BreakFluidEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: BreakFluidEnum.okay,
                                      groupValue: _breakFluidEnum,
                                      title: Text(BreakFluidEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _breakFluidEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<BreakFluidEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: BreakFluidEnum.no,
                                      groupValue: _breakFluidEnum,
                                      title: Text(BreakFluidEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _breakFluidEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Engine Coolant",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<EngineCoolantEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: EngineCoolantEnum.okay,
                                      groupValue: _engineCoolantEnum,
                                      title: Text(EngineCoolantEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _engineCoolantEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<EngineCoolantEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: EngineCoolantEnum.no,
                                      groupValue: _engineCoolantEnum,
                                      title: Text(EngineCoolantEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _engineCoolantEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Steering Fluid",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<SteeringFluidEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: SteeringFluidEnum.okay,
                                      groupValue: _steeringFluidEnum,
                                      title: Text(SteeringFluidEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _steeringFluidEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<SteeringFluidEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: SteeringFluidEnum.no,
                                      groupValue: _steeringFluidEnum,
                                      title: Text(SteeringFluidEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _steeringFluidEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Wiper Washer",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<WiperWasherEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: WiperWasherEnum.okay,
                                      groupValue: _wiperWasherEnum,
                                      title: Text(WiperWasherEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _wiperWasherEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<WiperWasherEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: WiperWasherEnum.no,
                                      groupValue: _wiperWasherEnum,
                                      title: Text(WiperWasherEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _wiperWasherEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("SeatBelts",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<SeatBeltsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: SeatBeltsEnum.okay,
                                      groupValue: _seatBeltsEnum,
                                      title: Text(SeatBeltsEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _seatBeltsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<SeatBeltsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: SeatBeltsEnum.no,
                                      groupValue: _seatBeltsEnum,
                                      title: Text(SeatBeltsEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _seatBeltsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Steering Wheel",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<SteeringWheelEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: SteeringWheelEnum.okay,
                                      groupValue: _steeringWheelEnum,
                                      title: Text(SteeringWheelEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _steeringWheelEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<SteeringWheelEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: SteeringWheelEnum.no,
                                      groupValue: _steeringWheelEnum,
                                      title: Text(SteeringWheelEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _steeringWheelEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Horn",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<HornEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: HornEnum.okay,
                                      groupValue: _hornEnum,
                                      title: Text(HornEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _hornEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<HornEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: HornEnum.no,
                                      groupValue: _hornEnum,
                                      title: Text(HornEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _hornEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Electric Windows",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<ElectricWindowsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: ElectricWindowsEnum.okay,
                                      groupValue: _electricWindowsEnum,
                                      title: Text(ElectricWindowsEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _electricWindowsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<ElectricWindowsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: ElectricWindowsEnum.no,
                                      groupValue: _electricWindowsEnum,
                                      title: Text(ElectricWindowsEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _electricWindowsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Windscreen Wipers",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<WindScreenWiperEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: WindScreenWiperEnum.okay,
                                      groupValue: _windScreenWiperEnum,
                                      title: Text(WindScreenWiperEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _windScreenWiperEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<WindScreenWiperEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: WindScreenWiperEnum.no,
                                      groupValue: _windScreenWiperEnum,
                                      title: Text(WindScreenWiperEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _windScreenWiperEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Head Lights",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<HeadLightsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: HeadLightsEnum.okay,
                                      groupValue: _headLightsEnum,
                                      title: Text(HeadLightsEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _headLightsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<HeadLightsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: HeadLightsEnum.no,
                                      groupValue: _headLightsEnum,
                                      title: Text(HeadLightsEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _headLightsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Trafficators",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<TrafficatorsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: TrafficatorsEnum.okay,
                                      groupValue: _trafficatorsEnum,
                                      title: Text(TrafficatorsEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _trafficatorsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<TrafficatorsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: TrafficatorsEnum.no,
                                      groupValue: _trafficatorsEnum,
                                      title: Text(TrafficatorsEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _trafficatorsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Tail Lights",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<TailLightsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: TailLightsEnum.okay,
                                      groupValue: _tailLightsEnum,
                                      title: Text(TailLightsEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _tailLightsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<TailLightsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: TailLightsEnum.no,
                                      groupValue: _tailLightsEnum,
                                      title: Text(TailLightsEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _tailLightsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Reverse Lights",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<ReverseLightsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: ReverseLightsEnum.okay,
                                      groupValue: _reverseLightsEnum,
                                      title: Text(ReverseLightsEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _reverseLightsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<ReverseLightsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: ReverseLightsEnum.no,
                                      groupValue: _reverseLightsEnum,
                                      title: Text(ReverseLightsEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _reverseLightsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Interior Lights",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<InteriorLightsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: InteriorLightsEnum.okay,
                                      groupValue: _interiorLightsEnum,
                                      title: Text(InteriorLightsEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _interiorLightsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<InteriorLightsEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: InteriorLightsEnum.no,
                                      groupValue: _interiorLightsEnum,
                                      title: Text(InteriorLightsEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _interiorLightsEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Engine Noise",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<EngineNoiseEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: EngineNoiseEnum.okay,
                                      groupValue: _engineNoiseEnum,
                                      title: Text(EngineNoiseEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _engineNoiseEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<EngineNoiseEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: EngineNoiseEnum.no,
                                      groupValue: _engineNoiseEnum,
                                      title: Text(EngineNoiseEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _engineNoiseEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Excessive Smoke",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<ExcessiveSmokeEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: ExcessiveSmokeEnum.okay,
                                      groupValue: _excessiveSmokeEnum,
                                      title: Text(ExcessiveSmokeEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _excessiveSmokeEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<ExcessiveSmokeEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: ExcessiveSmokeEnum.no,
                                      groupValue: _excessiveSmokeEnum,
                                      title: Text(ExcessiveSmokeEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _excessiveSmokeEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Foot Break",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<FootBreakEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: FootBreakEnum.okay,
                                      groupValue: _footBreakEnum,
                                      title: Text(FootBreakEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _footBreakEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<FootBreakEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: FootBreakEnum.no,
                                      groupValue: _footBreakEnum,
                                      title: Text(FootBreakEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _footBreakEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Hank Break",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<HandBreakEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: HandBreakEnum.okay,
                                      groupValue: _handBreakEnum,
                                      title: Text(HandBreakEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _handBreakEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<HandBreakEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: HandBreakEnum.no,
                                      groupValue: _handBreakEnum,
                                      title: Text(HandBreakEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _handBreakEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Wheel Bearing Noise",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<WheelBearingNoiseEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: WheelBearingNoiseEnum.okay,
                                      groupValue: _wheelBearingNoiseEnum,
                                      title: Text(WheelBearingNoiseEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _wheelBearingNoiseEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<WheelBearingNoiseEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: WheelBearingNoiseEnum.no,
                                      groupValue: _wheelBearingNoiseEnum,
                                      title: Text(WheelBearingNoiseEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _wheelBearingNoiseEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Waring Triangle",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<TriangleEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: TriangleEnum.okay,
                                      groupValue: _triangleEnum,
                                      title: Text(TriangleEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _triangleEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<TriangleEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: TriangleEnum.no,
                                      groupValue: _triangleEnum,
                                      title: Text(TriangleEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _triangleEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("Fire Extinguisher",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<FireExtinguisherEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: FireExtinguisherEnum.okay,
                                      groupValue: _fireExtinguisherEnum,
                                      title: Text(FireExtinguisherEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _fireExtinguisherEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<FireExtinguisherEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: FireExtinguisherEnum.no,
                                      groupValue: _fireExtinguisherEnum,
                                      title: Text(FireExtinguisherEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _fireExtinguisherEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(child: Text("First Aid Box",style: TextStyle(fontWeight: FontWeight.bold))),
                          // const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<FirstAidBoxEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      dense: true,
                                      value: FirstAidBoxEnum.okay,
                                      groupValue: _firstAidBoxEnum,
                                      title: Text(FirstAidBoxEnum.okay.name),
                                      onChanged: (value){
                                        setState(() {
                                          _firstAidBoxEnum = value;
                                        });
                                      }
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<FirstAidBoxEnum>(
                                      contentPadding: const EdgeInsets.all(0),
                                      value: FirstAidBoxEnum.no,
                                      groupValue: _firstAidBoxEnum,
                                      title: Text(FirstAidBoxEnum.no.name),
                                      onChanged: (value){
                                        setState(() {
                                          _firstAidBoxEnum = value;
                                        });
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height:20),

                   isPosting ? const Center(
                     child: CircularProgressIndicator.adaptive(
                       strokeWidth: 5,
                       backgroundColor: primaryColor,
                     )
                   ) :
                   RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            isPosting = true;
                          });
                          _startPosting();
                          if(double.parse(walletController.wallet) >= amountToPay){

                            amount = double.parse(walletController.wallet) - amountToPay;
                            if (_formKey.currentState!.validate()) {
                              if(_windScreenEnum?.name == null || _sideMirrorEnum?.name == null || _regPlateEnum?.name == null || _tirePressureEnum?.name == null || _drivingMirrorEnum?.name == null || _tireDepthEnum?.name == null || _wheelNutsEnum?.name == null || _engineOilEnum?.name == null || _fuelLevelEnum?.name == null || _breakFluidEnum?.name == null || _engineCoolantEnum?.name == null || _steeringFluidEnum?.name == null || _wiperWasherEnum?.name == null || _seatBeltsEnum?.name == null || _steeringWheelEnum?.name == null || _hornEnum?.name == null || _electricWindowsEnum?.name == null || _windScreenWiperEnum?.name == null || _headLightsEnum?.name == null || _trafficatorsEnum?.name == null || _tailLightsEnum?.name == null || _reverseLightsEnum?.name == null || _interiorLightsEnum?.name == null || _engineNoiseEnum?.name == null || _excessiveSmokeEnum?.name == null || _footBreakEnum?.name == null || _handBreakEnum?.name == null || _wheelBearingNoiseEnum?.name == null || _triangleEnum?.name == null || _fireExtinguisherEnum?.name == null || _firstAidBoxEnum?.name == null){

                                Get.snackbar("Error", "all fields are required",
                                    colorText: defaultTextColor1,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red
                                );
                                return;
                              }
                              processInventory();
                            } else {
                              Get.snackbar("Error", "something went wrong.please try again later",
                                  colorText: defaultTextColor1,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red
                              );
                            }
                          }

                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 8,
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: defaultTextColor2),
                        ),
                        fillColor: primaryColor,
                        splashColor: defaultColor,
                      ),
                      const SizedBox(height:20),
                    ],
                  ),
                )
              )
            ],
          ),
        )
      )
    );
  }
  void _onDropDownItemSelectedBrand(newValueSelected) {
    setState(() {
      _currentSelectedBrand = newValueSelected;
    });
  }
}
