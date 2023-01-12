import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:roadcycle/utility/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  //
  Future<void> saveDone() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("firstTime", false);
    Navigator.of(context).pushNamed("/start");
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: _introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          titleWidget: Column(children: [
            SizedBox(
              height: 40,
            ),
            Text("Welcome to Roadcycle",
                style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic)),
          ]),
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Find the best cycling routes throughout Switzerland."),
              SizedBox(
                height: 100,
              ),
              Image.asset('assets/images/IntroFirstPage.jpg')
            ],
          ),
        ),
        PageViewModel(
          titleWidget: Column(children: [
            SizedBox(
              height: 40,
            ),
            Text("Discover new Routes",
                style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic)),
          ]),
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Find the best cycling routes throughout Switzerland."),
              Image.asset(
                'assets/images/IntroRoute.PNG',
                height: 500,
              )
            ],
          ),
        ),
        PageViewModel(
          titleWidget: Column(children: [
            SizedBox(
              height: 40,
            ),
            Text("Like your Favorite Routes",
                style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic)),
          ]),
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Find the best cycling routes throughout Switzerland."),
              SizedBox(
                height: 80,
              ),
              Image.asset(
                'assets/images/IntroLike.PNG',
                height: 350,
              )
            ],
          ),
        )
      ],
      dotsDecorator: DotsDecorator(activeColor: AppColors.main.orange),
      onDone: () => {saveDone()},
      onSkip: () => {saveDone()},
      showNextButton: true,
      showDoneButton: true,
      showSkipButton: true,
      skip: Text('Skip',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: AppColors.main.orange)),
      next: Icon(Icons.arrow_forward, color: AppColors.main.orange),
      done: Text('Done',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: AppColors.main.orange)),
    );
  }
}
