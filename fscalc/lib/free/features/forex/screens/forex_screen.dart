import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fscalc/free/components/cupertino_slideup_bar.dart';
import 'package:fscalc/free/components/cupertino_slideup_text.dart';
import 'package:fscalc/free/controller/notification_service.dart';
import 'package:fscalc/free/features/forex/screens/forex_percent_screen.dart';
import 'package:fscalc/free/models/ads_model.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ForexScreen extends StatefulWidget {
  const ForexScreen({Key? key}) : super(key: key);

  @override
  _ForexScreenState createState() => _ForexScreenState();
}

class _ForexScreenState extends State<ForexScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 1, vsync: this);

    _bannerAd = BannerAd(
      adUnitId: AdsModel.bannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: kThemeRed,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(screenWidth, 40),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Text(
                            "Forex",
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => _infoSlideUp(),
                            icon: Icon(
                              Icons.info_outline_rounded,
                              size: 28,
                              color: kWhite.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: kBlack,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        indicatorPadding:
                            const EdgeInsets.symmetric(horizontal: -2),
                        isScrollable: true,
                        indicator: BubbleTabIndicator(
                          indicatorHeight: 30,
                          indicatorColor: kBlack.withOpacity(0.09),
                          insets: const EdgeInsets.symmetric(horizontal: -4),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        ),
                        tabs: const [
                          Tab(
                            child: Text("Percent"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 28),
              child: ForexPercentScreen(),
            ),
            _isBannerAdReady ? const SizedBox(height: 20) : Container(),
            if (_isBannerAdReady)
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  void _infoSlideUp() {
    double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: kBackgroundColor.withOpacity(0),
      context: context,
      builder: (BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: kBackgroundColor,
            ),
            height: screenHeight * 0.80,
            margin: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: CupertinoSlideUpBar()),
                const CupertinoSlideUpTitle(title: "Forex Terms"),
                Expanded(
                  child: ListView(
                    controller: controller,
                    shrinkWrap: true,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text("Account Size",
                            style: TextStyle(
                                color: kBlack, fontWeight: FontWeight.w500)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text("The amount of money in your account.",
                            style: TextStyle(color: kBlack)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text("Investment Amount",
                            style: TextStyle(
                                color: kBlack, fontWeight: FontWeight.w500)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text(
                            "The amount of money you're going to invest.",
                            style: TextStyle(color: kBlack)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text("Risk Percent",
                            style: TextStyle(
                                color: kBlack, fontWeight: FontWeight.w500)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text(
                            "A percent that you are comfortable with risking.",
                            style: TextStyle(color: kBlack)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text("Entry Price",
                            style: TextStyle(
                                color: kBlack, fontWeight: FontWeight.w500)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text(
                            "Price of a currency pair that you want to get involved at. Rounded up to the nearest 4th decimal point, ex: 1.2400",
                            style: TextStyle(color: kBlack)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text("Target Price",
                            style: TextStyle(
                                color: kBlack, fontWeight: FontWeight.w500)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text(
                            "Price of the currency pair where you would like to close your position and take the profit. Rounded up to the nearest 4th decimal point, ex: 1.2650",
                            style: TextStyle(color: kBlack)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text("Protective Stop",
                            style: TextStyle(
                                color: kBlack, fontWeight: FontWeight.w500)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text(
                            "If the currency pair was to go beyond this price then your position would be considered closed and you would bear the loss. Rounded up to the nearest 4th decimal point, ex: 0.9850",
                            style: TextStyle(color: kBlack)),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 30, right: 20),
                        child: CupertinoButton(
                          padding: const EdgeInsets.all(10),
                          borderRadius: BorderRadius.circular(12),
                          pressedOpacity: 0.8,
                          child: const Text(
                            "Understood",
                            style: TextStyle(
                              color: kThemeRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          color: kBlack.withOpacity(0.08),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      // Padding(
                      //     padding: const EdgeInsets.only(
                      //         left: 20, top: 8, right: 20, bottom: 25),
                      //     child: CupertinoButton(
                      //       padding: const EdgeInsets.all(10),
                      //       borderRadius: BorderRadius.circular(16),
                      //       pressedOpacity: 0.8,
                      //       child: const Text(
                      //         "More Info",
                      //         style: TextStyle(
                      //             color: kLightIndigo, fontWeight: FontWeight.w600),
                      //       ),
                      //       color: kBlack.withOpacity(0.08),
                      //       onPressed: () => _launchURL(),
                      //     )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
