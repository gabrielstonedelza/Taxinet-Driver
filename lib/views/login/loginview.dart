import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:taxinet_driver/g_controllers/login/my_login_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../widgets/backgroundImage.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final loginData = MyLoginController.to;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool isObscured = true;
  bool isPosting = false;
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  String resetPasswordUrl = "https://taxinetghana.xyz/password-reset/";

  Future<void> _launchInBrowser(String url) async{
    if(await canLaunch(url)){
      await launch(url,forceSafariVC: false,forceWebView: false);
    }
    else{
      throw "Could not launch $url";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    Size size  = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(image: "assets/images/taxi2.jpg",),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const Flexible(
                  child:
                  Center(
                    child: Text("Taxinet",style: TextStyle(color: primaryColor,fontSize: 50,fontWeight: FontWeight.bold),
                    ),
                  )
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.grey[500]?.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16)
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: _usernameController,
                          focusNode: _usernameFocusNode,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person,color: defaultTextColor1,),
                            hintText: "Username",
                            hintStyle: TextStyle(color: defaultTextColor1,),

                          ),
                          cursorColor: defaultTextColor1,
                          style: const TextStyle(color: defaultTextColor1),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter username";
                            }
                            else{
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.grey[500]?.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16)
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  isObscured = !isObscured;
                                });
                              },
                              icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off,color: defaultTextColor1,),
                            ),
                            border: InputBorder.none,
                            prefixIcon: const Icon(FontAwesomeIcons.lock,color: defaultTextColor1,),
                            hintText: "Password",
                            hintStyle: const TextStyle(color: defaultTextColor1),

                          ),
                          cursorColor: defaultTextColor1,
                          style: const TextStyle(color: defaultTextColor1),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          obscureText: isObscured,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter password";
                            }
                            else{
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    InkWell(
                        onTap: () async{
                          await _launchInBrowser("https://taxinetghana.xyz/password-reset/");
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(width: 1,color: defaultTextColor1))
                          ),
                          child: const Text("Forgot Password",style: TextStyle(fontWeight: FontWeight.bold,color: defaultTextColor1),),
                        )),
                    const SizedBox(height: 25,),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: primaryColor
                      ),
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      child: RawMaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            loginData.loginUser(_usernameController.text.trim(), _passwordController.text.trim());

                          } else {
                            Get.snackbar("Error", "Something went wrong",
                                colorText: defaultTextColor1,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red
                            );
                            return;
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 8,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: defaultTextColor1),
                        ),
                        fillColor: primaryColor,
                        splashColor: defaultColor,
                      ),
                    ),
                    const SizedBox(height: 25,),
                  ],
                ),
              ),
              const Text("Don't have an account?",style: TextStyle(fontWeight: FontWeight.bold,color: defaultTextColor1),),
              const SizedBox(height: 20,),
              ElevatedButton(
                child: const Text("Register",style: TextStyle(fontWeight: FontWeight.bold,color: defaultTextColor1),),
                onPressed: (){
                  showMaterialModalBottomSheet(
                    backgroundColor: secondaryColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    bounce: true,
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      controller: ModalScrollController.of(context),
                      child: SizedBox(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: ListView(
                            children: const [
                              Center(
                                child: Text(
                                  "Note",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Text("For Driver registration please kindly visit one of our offices or call 0244529353 for more information"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20,),
            ],
          ),
        )
      ],
    );
  }
}
