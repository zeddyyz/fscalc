import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({Key? key}) : super(key: key);

  @override
  _StocksScreenState createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen>
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
                            "Stocks",
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
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
    return Container(child: Text("PERCENT"));
  }

  Widget _fixedView() {
    return Container(child: Text("FIXED", style: TextStyle(color: kThemeRed)));
  }
}
