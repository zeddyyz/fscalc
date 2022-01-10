import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/components/bottom_nav.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/free/utilities/loading_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _onboardingShown = false;
  bool _isLoading = false;

  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    storageBox.write("onboarding_shown", true);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const BottomNav(),
      ),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/onboarding_images/$assetName', width: width);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    onboarding();
  }

  Future<void> onboarding() async {
    bool? _value = storageBox.read("onboarding_shown");

    if (_value == null) {
      setState(() {
        _onboardingShown = false;
        _isLoading = false;
      });
    } else if (_value == true) {
      setState(() {
        _onboardingShown = true;
        _isLoading = false;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BottomNav(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    if (!_onboardingShown) {
      return LoadingScreen(
        loading: _isLoading,
        child: IntroductionScreen(
          key: introKey,
          globalBackgroundColor: kWhite,
          globalHeader: Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: _buildImage('success_factors.png', 100),
              ),
            ),
          ),
          globalFooter: const SafeArea(child: SizedBox()),

          // SizedBox(
          //   width: screenWidth * 0.92,
          //   height: 50,
          //   child: CustomButton(
          //     buttonColor: kThemeRed,
          //     title: "Let's go!",
          //     onTap: () => _onIntroEnd(context),
          //   ),
          // ),
          pages: [
            PageViewModel(
              title: "Invest wisely",
              body:
                  "Blindly investing all of your cash in one go is a recipe for disaster. Instead, allocate a certain percent on each investment.",
              image: _buildImage('invest_wisely.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Forex or Stocks",
              body:
                  "Either market can net you financial freedom. We provide caculations for both so you don't have to look at multiple resources.",
              image: _buildImage('forex_stocks.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "View more",
              body:
                  "Get additional information on a currency pair or a company, and view their charts or get financial data.",
              image: _buildImage('charting.png'),
              decoration: pageDecoration,
            ),
          ],
          onDone: () => _onIntroEnd(context),
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: false,
          skipFlex: 0,
          nextFlex: 0,
          skip: const Text(
            'Skip',
            style: TextStyle(
              color: kThemeRed,
            ),
          ),
          next: const Icon(
            Icons.chevron_right_rounded,
            size: 32,
            color: kThemeRed,
          ),
          done: const Text(
            'Done',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: kThemeRed,
            ),
          ),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: const EdgeInsets.all(16),
          controlsPadding: kIsWeb
              ? const EdgeInsets.all(12.0)
              : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          dotsDecorator: DotsDecorator(
            size: const Size(10.0, 10.0),
            activeColor: kThemeRed,
            color: kBlack.withOpacity(0.3),
            activeSize: const Size(22.0, 10.0),
            activeShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
          ),
          dotsContainerDecorator: const ShapeDecoration(
            // color: kBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
