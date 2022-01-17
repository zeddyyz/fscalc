import 'package:flutter/material.dart';
import 'package:fscalc/paid/features/history/widgets/forex_history.dart';
import 'package:fscalc/paid/features/history/widgets/stocks_history.dart';

class TabBarAndTabViews extends StatefulWidget {
  const TabBarAndTabViews({Key? key}) : super(key: key);

  @override
  _TabBarAndTabViewsState createState() => _TabBarAndTabViewsState();
}

class _TabBarAndTabViewsState extends State<TabBarAndTabViews>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: TabPairs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // give the tab bar a height [can change height to preferred height]
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                25.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: const Color(0xFFFF8527),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: TabPairs.map((tabPair) => tabPair.tab).toList()),
            ),
          ),
          // tab bar view here
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: TabPairs.map((tabPair) => tabPair.tab).toList()),
          ),
        ],
      ),
    );
  }
}

class TabPair {
  final Tab tab;
  final Widget view;
  TabPair({required this.tab, required this.view});
}

List<TabPair> TabPairs = [
  TabPair(
    tab: const Tab(
      text: 'Forex',
    ),
    view: const ForexHistoryWidget(),
  ),
  TabPair(
    tab: const Tab(
      text: 'Stocks',
    ),
    view: const StocksHistoryWidget(),
  ),
  // TabPair(
  //   tab: Tab(
  //     text: 'Steps',
  //   ),
  //   view: Center(
  //     child: Text(
  //       'Steps here',
  //       style: TextStyle(
  //         fontSize: 25,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   ),
  // )
];
