import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PassengerOnBoarding extends StatefulWidget {
  const PassengerOnBoarding({Key? key}) : super(key: key);

  @override
  State<PassengerOnBoarding> createState() => _PassengerOnBoardingState();
}

class _PassengerOnBoardingState extends State<PassengerOnBoarding> {
  final controller = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: controller,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/70226-a-driver.gif"),
                    fit: BoxFit.cover
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("THis is one"),
                    Text("THis is Two"),
                  ],
                ),
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Expanded(child: Lottie.asset("assets/json/70226-a-driver.json"))
              //   ],
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Lottie.asset("assets/json/70226-a-driver.json"))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Lottie.asset("assets/json/70226-a-driver.json"))
                ],
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          decoration: const BoxDecoration(
            color: Colors.black
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: (){
                    controller.jumpToPage(2);
                  },
                  child: const Text("SKIP",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),)
              ),
              Center(
                child: SmoothPageIndicator(
                  count: 3,
                  controller: controller,
                  effect: const WormEffect(
                    spacing: 16,
                    dotColor: Colors.amber,
                    activeDotColor: Colors.grey
                  ),
                  onDotClicked: (index)=>controller.animateToPage(index, duration: const Duration(milliseconds: 500 ), curve: Curves.easeIn),
                ),
              ),
              TextButton(
                  onPressed: (){
                    controller.nextPage(duration: const Duration(microseconds: 500), curve: Curves.easeInOut);
                  },
                  child: const Text("Next",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
