import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/authentication/auth_controller.dart';
import 'package:fscalc/paid/forex/forex_controller.dart';
import 'package:fscalc/paid/forex/forex_history_screen.dart';
import 'package:fscalc/paid/stocks/stocks_history_screen.dart';
import 'package:get/get.dart';

class PaidHome extends StatelessWidget {
  const PaidHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.find();
    final ForexController _forexController = Get.put(ForexController());
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Obx(
          () => Text(_forexController.username.value),
        ),
        backgroundColor: kThemeRed,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              _authController.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForexHistoryScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.9,
                      height: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Forex",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://static6.depositphotos.com/1062085/593/i/600/depositphotos_5937633-stock-photo-touching-stock-market-chart.jpg",
                            ),
                          ),
                          const Text(
                            "Forex History Page",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StocksHistoryScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.9,
                      height: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Stocks",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://media.istockphoto.com/photos/financial-and-technical-data-analysis-graph-picture-id1145882183",
                            ),
                          ),
                          const Text(
                            "Stocks History Page",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
