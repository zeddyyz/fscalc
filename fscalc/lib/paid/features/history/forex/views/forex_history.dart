import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fscalc/free/components/cupertino_close_icon.dart';
import 'package:fscalc/free/components/cupertino_slideup_bar.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/components/custom_textfield.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/features/authentication/controllers/auth_controller.dart';
import 'package:fscalc/paid/features/history/forex/controller/forex_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ForexHistoryWidget extends StatefulWidget {
  const ForexHistoryWidget({Key? key}) : super(key: key);

  @override
  State<ForexHistoryWidget> createState() => _ForexHistoryWidgetState();
}

class _ForexHistoryWidgetState extends State<ForexHistoryWidget> {
  final Stream<QuerySnapshot> _forexStream = FirebaseFirestore.instance
      .collection('forexHistory')
      .orderBy('id', descending: true)
      .snapshots();

  final ForexController _forexController = Get.put(ForexController());
  final AuthController _authController = Get.find<AuthController>();

  int _index = 0;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _userEmail = _authController.firebaseUser.value!.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/backgrounds%2Fgradienta-26WixHTutxc-unsplash.jpg?alt=media&token=4b3d4985-d8fb-40e9-928f-cf7b4502a858",
            ),
            // todo - check if opacity can be reduced on image only
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      size: 36,
                      color: kBlack,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  const Text(
                    "Forex History",
                    style: TextStyle(
                      color: kBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: _addTrade,
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // color: Colors.blue.shade500,
                          color: kThemeRed,
                          boxShadow: [
                            BoxShadow(
                              color: kBlack.withOpacity(0.15),
                              spreadRadius: 4,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add_rounded,
                          size: 28,
                          color: kWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _forexStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }

                    return ListView(
                      padding: const EdgeInsets.only(top: 20),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _index = data['id'];
                            });
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
                                        color: _index == data['id']
                                            ? kWhite
                                            : kBlack,
                                        fontWeight: _index == data['id']
                                            ? FontWeight.w700
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      data['bookValue'],
                                      style: TextStyle(
                                        color: _index == data['id']
                                            ? kWhite
                                            : kBlack,
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
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Column(
                                          children: [
                                            MaterialButton(
                                              color:
                                                  kLightIndigo.withOpacity(0.8),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                "Confirm",
                                                style: TextStyle(color: kWhite),
                                              ),
                                              onPressed: () async {
                                                _forexController.deleteTrade(
                                                    data['id'],
                                                    _userEmail ?? '');
                                                Get.back();
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
                                    _editTrade(data['id'].toString(),
                                        _userEmail ?? '');
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
            ],
          ),
        ),
      ),
    );
  }

  _addTrade() {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: kBackgroundColor.withOpacity(0),
      context: context,
      builder: (BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (_, controller) {
          String? _entryDate, _closeDate;
          String _currencyPair, _bookValue, _marketValue;

          return StatefulBuilder(builder: (BuildContext context, modalState) {
            final Map<int, Color> _materialColor = {
              50: const Color.fromRGBO(182, 17, 49, .1),
              100: const Color.fromRGBO(182, 17, 49, .2),
              200: const Color.fromRGBO(182, 17, 49, .3),
              300: const Color.fromRGBO(182, 17, 49, .4),
              400: const Color.fromRGBO(182, 17, 49, .5),
              500: const Color.fromRGBO(182, 17, 49, .6),
              600: const Color.fromRGBO(182, 17, 49, .7),
              700: const Color.fromRGBO(182, 17, 49, .8),
              800: const Color.fromRGBO(182, 17, 49, .9),
              900: const Color.fromRGBO(182, 17, 49, 1),
            };

            Future entryDateTimePicker() async {
              MaterialColor colorCustom =
                  MaterialColor(0xffB61131, _materialColor);

              DateTime? newDateTime = await showRoundedDatePicker(
                context: context,
                height: screenHeight * 0.35,
                initialDate: DateTime.now(),
                firstDate: DateTime(2019, 1),
                theme: ThemeData(
                  primarySwatch: colorCustom,
                ),
                styleDatePicker: MaterialRoundedDatePickerStyle(
                  decorationDateSelected: const BoxDecoration(
                    color: kThemeRed,
                    shape: BoxShape.circle,
                  ),
                  paddingMonthHeader: const EdgeInsets.symmetric(vertical: 10),
                ),
                styleYearPicker: MaterialRoundedYearPickerStyle(
                  textStyleYear:
                      const TextStyle(fontSize: 40, color: kThemeRed),
                  textStyleYearSelected: const TextStyle(
                    fontSize: 50,
                    color: kLightIndigo,
                    fontWeight: FontWeight.bold,
                  ),
                  heightYearRow: 100,
                ),
              );

              modalState(() {
                _entryDate = DateFormat('dd MMMM, yyyy')
                    .format(newDateTime ?? DateTime.now())
                    .toString();
              });
            }

            Future closeDateTimePicker() async {
              MaterialColor colorCustom =
                  MaterialColor(0xffB61131, _materialColor);

              DateTime? newDateTime = await showRoundedDatePicker(
                context: context,
                height: screenHeight * 0.35,
                initialDate: DateTime.now(),
                firstDate: DateTime(2019, 1),
                theme: ThemeData(
                  primarySwatch: colorCustom,
                ),
                styleDatePicker: MaterialRoundedDatePickerStyle(
                  decorationDateSelected: const BoxDecoration(
                    color: kThemeRed,
                    shape: BoxShape.circle,
                  ),
                  paddingMonthHeader: const EdgeInsets.symmetric(vertical: 10),
                ),
                styleYearPicker: MaterialRoundedYearPickerStyle(
                  textStyleYear:
                      const TextStyle(fontSize: 40, color: kThemeRed),
                  textStyleYearSelected: const TextStyle(
                    fontSize: 50,
                    color: kLightIndigo,
                    fontWeight: FontWeight.bold,
                  ),
                  heightYearRow: 100,
                ),
              );

              modalState(() {
                _closeDate = DateFormat('dd MMMM, yyyy')
                    .format(newDateTime ?? DateTime.now())
                    .toString();
              });
            }

            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13.0),
                  topRight: Radius.circular(13.0),
                ),
                color: kBackgroundColor,
              ),
              height: screenHeight * 0.8,
              margin: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const CupertinoSlideUpBar(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                          top: 20,
                          right: 15,
                          bottom: 10,
                        ),
                        child: Text(
                          "Add Entry",
                          style: TextStyle(
                            color: kThemeRed,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: CupertinoCloseIcon(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        controller: controller,
                        children: [
                          CustomTextField(
                            hintText: "Name of currency pair?",
                            hintTextColor: kBlack.withOpacity(0.5),
                            numberKeyboard: false,
                            prefixIcon: Icons.attach_money_rounded,
                            onChanged: (value) {
                              if (value != "") {
                                _currencyPair = value;
                              }
                            },
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  hintText:
                                      _entryDate ?? "Entry date of position?",
                                  hintTextColor: kBlack.withOpacity(0.5),
                                  prefixIcon: Icons.calendar_today_outlined,
                                  // onChanged: (value) {
                                  //   if (value != "") _entryDate = value;
                                  // },
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                child: Container(
                                  height: 60,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text("Select"),
                                ),
                                onTap: entryDateTimePicker,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  hintText:
                                      _closeDate ?? "Exit date of position?",
                                  hintTextColor: kBlack.withOpacity(0.5),
                                  prefixIcon: Icons.calendar_today_outlined,
                                  // onChanged: (value) {
                                  //   if (value != "") _closeDate = value;
                                  // },
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                child: Container(
                                  height: 60,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text("Select"),
                                ),
                                onTap: closeDateTimePicker,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          CustomTextField(
                            hintText: "Book value?",
                            hintTextColor: kBlack.withOpacity(0.5),
                            prefixIcon: Icons.attach_money_rounded,
                            onChanged: (value) {
                              if (value != "") {
                                _bookValue = value;
                              }
                            },
                          ),
                          const SizedBox(height: 4),
                          CustomTextField(
                            hintText: "Market value?",
                            hintTextColor: kBlack.withOpacity(0.5),
                            prefixIcon: Icons.money_off_csred_rounded,
                            onChanged: (value) {
                              if (value != "") _marketValue = value;
                            },
                          ),
                          const SizedBox(height: 8),
                          CustomButton(
                            title: "Add",
                            onTap: () {
                              var id = storageBox.read("id");
                              id++;

                              _forexController.addTrade(
                                id,
                                _userEmail ?? '',
                                _currencyPair,
                                DateTime.parse(_entryDate!),
                                DateTime.parse(_closeDate!),
                                _bookValue,
                                _marketValue,
                              );
                              storageBox.write("id", id);
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  _editTrade(String id, String email) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: kBackgroundColor.withOpacity(0),
      context: context,
      builder: (BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13.0),
                topRight: Radius.circular(13.0),
              ),
              color: kBackgroundColor,
            ),
            height: screenHeight * 0.8,
            margin: const EdgeInsets.all(0),
            child: Column(
              children: [
                const CupertinoSlideUpBar(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 20,
                        right: 15,
                        bottom: 10,
                      ),
                      child: Text(
                        id,
                        style: const TextStyle(
                          color: kThemeRed,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: CupertinoCloseIcon(),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      controller: controller,
                      children: const [],
                    ),
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

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required ForexController forexController,
  })  : _forexController = forexController,
        super(key: key);

  final ForexController _forexController;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kBackgroundColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
      elevation: 0,
      title: const Text(
        "Forex History",
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
              var id = storageBox.read("id");
              id++;
              // _forexController.addTrade(id, 'zawar@gmail.com', "$id" "000");
              storageBox.write("id", id);
            },
            // onPressed: _addTrade,
          ),
        )
      ],
    );
  }
}
