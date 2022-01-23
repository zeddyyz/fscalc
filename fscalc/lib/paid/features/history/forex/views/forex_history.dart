import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fscalc/free/components/cupertino_close_icon.dart';
import 'package:fscalc/free/components/cupertino_slideup_bar.dart';
import 'package:fscalc/free/components/custom_button.dart';
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
  final AuthController _authController = Get.put(AuthController());

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
      // backgroundColor: kLightIndigo,
      // appBar: AppBar(
      //   backgroundColor: kBackgroundColor,
      //   systemOverlayStyle: const SystemUiOverlayStyle(
      //     statusBarBrightness: Brightness.light,
      //   ),
      //   elevation: 0,
      //   title: const Text(
      //     "Forex History",
      //     style: TextStyle(color: kBlack),
      //   ),
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.chevron_left_rounded,
      //       size: 36,
      //       color: kBlack,
      //     ),
      //     onPressed: () => Get.back(),
      //   ),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 4),
      //       child: IconButton(
      //         icon: const Icon(
      //           Icons.add_outlined,
      //           size: 32,
      //           color: kThemeRed,
      //         ),
      //         onPressed: _addTrade,
      //       ),
      //     )
      //   ],
      // ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/backgrounds%2Fgradienta-26WixHTutxc-unsplash.jpg?alt=media&token=4b3d4985-d8fb-40e9-928f-cf7b4502a858"),
            // todo - cached image provider to cache url for faster loading
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
              const SizedBox(height: 12),
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
                              vertical: 8,
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
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (_, controller) {
          String? _date;
          String? _unformattedDate;

          return StatefulBuilder(builder: (BuildContext context, modalState) {
            Future dateTimePicker() async {
              DateTime? newDateTime = await showRoundedDatePicker(
                context: context,
                // initialDate: _date != null
                //     ? DateTime.parse(_unformattedDate!)
                //     : DateTime.now(),
                initialDate: DateTime.now(),
                firstDate: DateTime(2019, 1),
                theme: ThemeData(primarySwatch: Colors.deepPurple),
                styleDatePicker: MaterialRoundedDatePickerStyle(
                  textStyleDayButton:
                      const TextStyle(fontSize: 36, color: Colors.white),
                  textStyleYearButton: const TextStyle(
                    fontSize: 52,
                    color: Colors.white,
                  ),
                  textStyleDayHeader: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  textStyleCurrentDayOnCalendar: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textStyleDayOnCalendar:
                      const TextStyle(fontSize: 28, color: Colors.white),
                  textStyleDayOnCalendarSelected: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textStyleDayOnCalendarDisabled: TextStyle(
                      fontSize: 28, color: Colors.white.withOpacity(0.1)),
                  textStyleMonthYearHeader: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  paddingDatePicker: const EdgeInsets.all(0),
                  paddingMonthHeader: const EdgeInsets.all(32),
                  paddingActionBar: const EdgeInsets.all(16),
                  paddingDateYearHeader: const EdgeInsets.all(32),
                  sizeArrow: 50,
                  colorArrowNext: Colors.white,
                  colorArrowPrevious: Colors.white,
                  marginLeftArrowPrevious: 16,
                  marginTopArrowPrevious: 16,
                  marginTopArrowNext: 16,
                  marginRightArrowNext: 32,
                  textStyleButtonAction:
                      const TextStyle(fontSize: 28, color: Colors.white),
                  textStyleButtonPositive: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textStyleButtonNegative: TextStyle(
                      fontSize: 28, color: Colors.white.withOpacity(0.5)),
                  decorationDateSelected: BoxDecoration(
                      color: Colors.orange[600], shape: BoxShape.circle),
                  backgroundPicker: Colors.deepPurple[400],
                  backgroundActionBar: Colors.deepPurple[300],
                  backgroundHeaderMonth: Colors.deepPurple[300],
                ),
                styleYearPicker: MaterialRoundedYearPickerStyle(
                  textStyleYear:
                      const TextStyle(fontSize: 40, color: Colors.white),
                  textStyleYearSelected: const TextStyle(
                    fontSize: 56,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  heightYearRow: 100,
                  backgroundPicker: Colors.deepPurple[400],
                ),
              );

              modalState(() {
                _date = DateFormat('dd MMMM, yyyy')
                    .format(newDateTime ?? DateTime.now())
                    .toString();
                _unformattedDate = newDateTime.toString();
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
                          SizedBox(
                            height: 150,
                            child: Row(
                              children: [
                                const Text("Entry Date"),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                      color: kThemeRed,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: const Text(
                                        "Date",
                                        style: TextStyle(color: kWhite),
                                      ),
                                      onPressed: dateTimePicker,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _date ?? "No date selected",
                                style: const TextStyle(color: kBlack),
                              ),
                            ),
                          ),
                          CustomInputFieldFb1(
                            hintText: "What price did you enter the position?",
                            inputController: TextEditingController(),
                            labelText: "Entry Price",
                          ),
                          const SizedBox(height: 20),
                          CustomInputFieldFb1(
                            hintText: "What price did you exit the position?",
                            inputController: TextEditingController(),
                            labelText: "Exit Price",
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            title: "Add",
                            onTap: () {
                              var id = storageBox.read("id");
                              id++;
                              _forexController.addTrade(
                                  id, _userEmail ?? '', "$id" "000");
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
              _forexController.addTrade(id, 'zawar@gmail.com', "$id" "000");
              storageBox.write("id", id);
            },
            // onPressed: _addTrade,
          ),
        )
      ],
    );
  }
}

class CustomInputFieldFb1 extends StatelessWidget {
  final TextEditingController inputController;
  final String hintText;
  final Color primaryColor;
  final String labelText;

  const CustomInputFieldFb1(
      {Key? key,
      required this.inputController,
      required this.hintText,
      required this.labelText,
      this.primaryColor = Colors.indigo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextField(
        controller: inputController,
        onChanged: (value) {
          //Do something wi
        },
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          border: UnderlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor.withOpacity(.1), width: 2.0),
          ),
        ),
      ),
    );
  }
}
