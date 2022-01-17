import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/features/history/components/custom_tabbar.dart';
import 'package:get/get.dart';

class HistoryHomeScreen extends StatefulWidget {
  const HistoryHomeScreen({Key? key}) : super(key: key);

  @override
  _HistoryHomeScreenState createState() => _HistoryHomeScreenState();
}

class _HistoryHomeScreenState extends State<HistoryHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        elevation: 0,
        title: const Text(
          "History",
          style: TextStyle(color: kBlack),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 36,
            color: kBlack,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: const Icon(
                Icons.add_outlined,
                size: 32,
                color: kThemeRed,
              ),
              onPressed: () {
                // todo - Add item
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // color: kBlue,
              child: const TabBarAndTabViews(),
            ),
          ),
        ],
      ),
    );
  }
}
