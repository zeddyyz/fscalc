import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:get/get.dart';

class StocksHistoryWidget extends StatefulWidget {
  const StocksHistoryWidget({Key? key}) : super(key: key);

  @override
  _StocksHistoryWidgetState createState() => _StocksHistoryWidgetState();
}

class _StocksHistoryWidgetState extends State<StocksHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightIndigo,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        elevation: 0,
        title: const Text(
          "Stocks History",
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
                // var id = storageBox.read("id");
                // id++;
                // _historyController.addTrade(id, 'zawar@gmail.com', "$id" "000");
                // storageBox.write("id", id);
              },
            ),
          )
        ],
      ),
    );
  }
}
