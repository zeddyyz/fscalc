import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/forex/forex_controller.dart';
import 'package:get/get.dart';

class ForexHistoryScreen extends StatefulWidget {
  const ForexHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ForexHistoryScreen> createState() => _ForexHistoryScreenState();
}

class _ForexHistoryScreenState extends State<ForexHistoryScreen> {
  final ForexController _forexController = Get.put(ForexController());
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Forex History",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: kThemeRed,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _forexController.addTrade(
                id: "2",
                currencyPair: "XAU/USD",
                entryDate: DateTime.now(),
                exitDate: DateTime.now(),
                bookValue: "1000",
                marketValue: "1200",
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _forexController.forexStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              padding: const EdgeInsets.only(top: 20),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _index = int.parse(data['id']);
                    });
                    log(_index.toString());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _index == data['id']
                          ? kThemeRed.withOpacity(0.6)
                          : kWhite.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(13),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.shade100.withOpacity(0.1),
                      //     // spreadRadius: _index == data['id'] ? 12 : 8,
                      //     // blurRadius: _index == data['id'] ? 12 : 8,
                      //     spreadRadius: 4,
                      //     blurRadius: 4,
                      //     offset: const Offset(0, 8),
                      //   ),
                      // ],
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['id'].toString(),
                              style: TextStyle(
                                color: _index == data['id'] ? kWhite : kBlack,
                                fontWeight: _index == data['id']
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                              ),
                            ),
                            Text(
                              data['bookValue'] ?? "",
                              style: TextStyle(
                                color: _index == data['id'] ? kWhite : kBlack,
                                fontWeight: _index == data['id']
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            color: _index == data['id']
                                ? kWhite
                                : kBlack.withOpacity(0.7),
                          ),
                          onPressed: () {
                            Flushbar(
                              margin: EdgeInsets.only(
                                  bottom: screenHeight * 0.09,
                                  left: 30,
                                  right: 30),
                              padding: const EdgeInsets.all(20),
                              borderRadius: BorderRadius.circular(13),
                              titleText: Text(
                                "Notice",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.yellow[600],
                                ),
                              ),
                              messageText: const Text(
                                "Are you sure you want to delete this entry?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kWhite,
                                ),
                              ),
                              icon: const Icon(
                                Icons.info_outline,
                                size: 28.0,
                                color: kWhite,
                              ),
                              mainButton: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Column(
                                  children: [
                                    MaterialButton(
                                      color: kLightIndigo.withOpacity(0.8),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        "Confirm",
                                        style: TextStyle(color: kWhite),
                                      ),
                                      onPressed: () async {
                                        // _forexController.deleteTrade(
                                        //     data['id'], _userEmail ?? '');
                                        // Get.back();
                                      },
                                    ),
                                    MaterialButton(
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: kWhite),
                                      ),
                                      onPressed: () => Get.back(),
                                    ),
                                  ],
                                ),
                              ),
                            ).show(context);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: _index == data['id']
                                ? kWhite
                                : kBlack.withOpacity(0.7),
                          ),
                          onPressed: () {
                            // todo - edit entry
                            // _editTrade(data['id'].toString(), _userEmail ?? '');
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
