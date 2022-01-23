import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/features/history/forex/views/forex_history.dart';
import 'package:fscalc/paid/features/history/stocks/views/stocks_history.dart';
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardFb1(
                text: "Forex History",
                imageUrl:
                    "https://static6.depositphotos.com/1062085/593/i/600/depositphotos_5937633-stock-photo-touching-stock-market-chart.jpg",
                subtitle: "Forex stuff",
                onPressed: () => Get.to(() => const ForexHistoryWidget()),
              ),
              const SizedBox(height: 12),
              CardFb1(
                text: "Stocks History",
                imageUrl:
                    "https://media.istockphoto.com/photos/financial-and-technical-data-analysis-graph-picture-id1145882183",
                subtitle: "Stocks stuff",
                onPressed: () => Get.to(() => const StocksHistoryWidget()),
              ),
            ],
          ),
        ),
      ),
      // body: ForexHistoryWidget(),
    );
  }
}

class CardFb1 extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String subtitle;
  final Function() onPressed;

  const CardFb1(
      {required this.text,
      required this.imageUrl,
      required this.subtitle,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.maxFinite,
        height: 250,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              offset: const Offset(10, 20),
              blurRadius: 10,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.05),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const Spacer(),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
