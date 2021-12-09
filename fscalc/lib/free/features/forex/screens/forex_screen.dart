import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/components/cupertino_close_icon.dart';
import 'package:fscalc/free/components/cupertino_slideup_bar.dart';
import 'package:fscalc/free/utilities/constants.dart';

class ForexScreen extends StatefulWidget {
  const ForexScreen({Key? key}) : super(key: key);

  @override
  _ForexScreenState createState() => _ForexScreenState();
}

class _ForexScreenState extends State<ForexScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late int _body = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
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
                            icon: const Icon(
                              Icons.info_outline_rounded,
                              size: 28,
                              color: kBlack,
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
                        indicatorPadding:
                            const EdgeInsets.symmetric(horizontal: -2),
                        isScrollable: true,
                        indicator: BubbleTabIndicator(
                          indicatorHeight: 28,
                          indicatorColor: kBlack.withOpacity(0.09),
                          insets: const EdgeInsets.symmetric(horizontal: 0),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: _body == 0 ? _percentView() : _fixedView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _percentView() {
    return Column(
      children: [],
    );
  }

  Widget _fixedView() {
    return Container(child: Text("FIXED", style: TextStyle(color: kThemeRed)));
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
                  const SizedBox(height: 16),
                  const Center(child: CupertinoSlideUpBar()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25, top: 20, right: 15, bottom: 10),
                        child: Text(
                          "Forex Terms",
                          style: TextStyle(
                            foreground: Paint()..shader = termsTitle,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 16, top: 4),
                        child: CupertinoCloseIcon(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      shrinkWrap: true,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 25, top: 20, right: 20),
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
                          padding:
                              EdgeInsets.only(left: 25, top: 20, right: 20),
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
                          padding:
                              EdgeInsets.only(left: 25, top: 20, right: 20),
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
                          padding:
                              EdgeInsets.only(left: 25, top: 20, right: 20),
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
                          padding:
                              EdgeInsets.only(left: 25, top: 20, right: 20),
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
                          padding:
                              EdgeInsets.only(left: 25, top: 20, right: 20),
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
                          padding: const EdgeInsets.only(
                              left: 20, top: 30, right: 20),
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
          }),
    );
  }
}
