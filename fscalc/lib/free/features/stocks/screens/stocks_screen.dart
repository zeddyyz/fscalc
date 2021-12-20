import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/components/cupertino_slideup_bar.dart';
import 'package:fscalc/free/components/cupertino_slideup_text.dart';
import 'package:fscalc/free/features/stocks/screens/stocks_fixed_screen.dart';
import 'package:fscalc/free/features/stocks/screens/stocks_percent_screen.dart';
import 'package:fscalc/free/models/ads_model.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({Key? key}) : super(key: key);

  @override
  _StocksScreenState createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late int _body = 0;

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    _bannerAd = BannerAd(
      adUnitId: AdsModel.bannerUnitId,
      request: const AdRequest(),
      size: isMobile ? AdSize.banner : AdSize.largeBanner,
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
                            "Stocks",
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
                          Tab(
                            child: Text("Fixed"),
                          ),
                        ],
                        onTap: (int index) {
                          switch (index) {
                            case 0:
                              if (!mounted) return;
                              setState(() {
                                _body = 0;
                              });
                              break;
                            case 1:
                              if (!mounted) return;
                              setState(() {
                                _body = 1;
                              });
                              break;
                            default:
                              break;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                child: _body == 0
                    ? const StocksPercentScreen()
                    : const StocksFixedScreen(),
              ),
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
                const CupertinoSlideUpTitle(title: "Stocks Terms"),
                Expanded(
                  child: ListView(
                    controller: controller,
                    shrinkWrap: true,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text(
                          "Account Size",
                          style: TextStyle(
                              color: kBlack, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text(
                          "The amount of money in your account.",
                          style: TextStyle(color: kBlack),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text(
                          "Investment Amount",
                          style: TextStyle(
                              color: kBlack, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text(
                          "The amount of money you're going to invest.",
                          style: TextStyle(color: kBlack),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text(
                          "Risk Percent",
                          style: TextStyle(
                              color: kBlack, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text(
                          "A percent that you are comfortable with risking.",
                          style: TextStyle(color: kBlack),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text(
                          "Entry Price",
                          style: TextStyle(
                              color: kBlack, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text(
                          "Price of a stock that you want to purchase at.",
                          style: TextStyle(color: kBlack),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text(
                          "Target Price",
                          style: TextStyle(
                              color: kBlack, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text(
                          "Price of the stock where you would like to close (sell) your position and take the profit.",
                          style: TextStyle(color: kBlack),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 20, right: 20),
                        child: Text(
                          "Protective Stop",
                          style: TextStyle(
                              color: kBlack, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, top: 3, right: 20),
                        child: Text(
                          "If the stock was to drop to this price then your position would be considered closed and you would bear the loss. Also known as Limit Stop",
                          style: TextStyle(color: kBlack),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 30, right: 20),
                          child: SizedBox(
                            width: double.infinity,
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
                        ),
                      ),
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
