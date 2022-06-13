import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fscalc/free/components/cupertino_close_icon.dart';
import 'package:fscalc/free/components/cupertino_slideup_bar.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/components/custom_textfield.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/forex/forex_controller.dart';
import 'package:fscalc/paid/forex/forex_isClosed_widget.dart';
import 'package:fscalc/paid/forex/forex_isOpen_widget.dart';
import 'package:get/get.dart';

class ForexHistoryScreen extends StatelessWidget {
  const ForexHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ForexController _forexController = Get.put(ForexController());
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Forex History",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: kThemeRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          iconSize: 38,
          onPressed: () {
            Navigator.pop(context);
            _forexController.indexOfView(0);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 30,
            onPressed: () {
              _forexController.resetFormValues();
              addTradeModalBottomSheet();
              // Get.to(() => const ForexAddTrade());
              // Get.back();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: kThemeRed,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(screenWidth, 45),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _forexController.indexOfView(0);
                      _forexController.pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.linear,
                      );
                    },
                    child: Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                          color: _forexController.indexOfView.value == 0
                              ? Colors.white.withOpacity(0.9)
                              : Colors.transparent,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(12),
                            right: Radius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 4,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        child: Text(
                          "Open",
                          style: TextStyle(
                            color: _forexController.indexOfView.value == 0
                                ? kThemeRed
                                : kWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _forexController.indexOfView(1);
                      _forexController.pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.linear,
                      );
                    },
                    child: Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                          color: _forexController.indexOfView.value == 1
                              ? Colors.white.withOpacity(0.9)
                              : Colors.transparent,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(12),
                            right: Radius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 4,
                        ),
                        child: Text(
                          "Closed",
                          style: TextStyle(
                            color: _forexController.indexOfView.value == 1
                                ? kThemeRed
                                : kWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: 2,
              onPageChanged: (view) {
                switch (view) {
                  case 0:
                    _forexController.indexOfView(0);
                    break;
                  case 1:
                    _forexController.indexOfView(1);
                    break;
                  default:
                    break;
                }
              },
              controller: _forexController.pageController,
              itemBuilder: (context, position) {
                if (position == 0) {
                  return const ForexIsOpenWidget();
                }

                if (position == 1) {
                  return const ForexIsClosedWidget();
                }

                return Container();
              },
            ),
          ),
        ],
      ),

      // DefaultTabController(
      //   length: 2,
      //   child: Column(
      //     children: [
      //       Container(
      //         padding: const EdgeInsets.only(bottom: 17),
      //         decoration: BoxDecoration(
      //           color: kThemeRed,
      //           borderRadius: BorderRadius.vertical(
      //             bottom: Radius.elliptical(screenWidth, 40),
      //           ),
      //         ),
      //         child: const TabBar(
      //           indicatorColor: kThemeRed,
      //           tabs: [
      //             Tab(
      //               text: "Open",
      //             ),
      //             Tab(
      //               text: "Closed",
      //             ),
      //           ],
      //           labelColor: kBlack,
      //           labelStyle: TextStyle(
      //             fontWeight: FontWeight.w600,
      //             fontSize: 16,
      //           ),
      //           indicator: null,
      //           // MaterialIndicator(
      //           //   height: 4,
      //           //   topLeftRadius: 8,
      //           //   topRightRadius: 8,
      //           //   horizontalPadding: 50,
      //           //   tabPosition: TabPosition.bottom,
      //           //   color: kWhite.withOpacity(1),
      //           // ),
      //         ),
      //       ),
      //       const Expanded(
      //         child: AnimationLimiter(
      //           child: AnimationConfiguration.staggeredList(
      //             position: 0,
      //             child: SlideAnimation(
      //               verticalOffset: 50,
      //               child: FadeInAnimation(
      //                 child: TabBarView(
      //                   children: [
      //                     //* isOpen = true
      //                     ForexIsOpenWidget(),
      //                     // * isOpen = false
      //                     ForexIsClosedWidget(),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  addTradeModalBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: kBackgroundColor.withOpacity(0),
      context: Get.context!,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.3,
        maxChildSize: 0.937,
        builder: (_, controller) {
          return StatefulBuilder(builder: (BuildContext context, modalState) {
            final ForexController _forexController = Get.put(ForexController());

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
                _forexController.entryDate = RxString(newDateTime.toString());
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
                _forexController.exitDate = RxString(newDateTime.toString());
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
                          Container(
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 4,
                            ),
                            child: DropdownButtonFormField2(
                              selectedItemHighlightColor: kBackgroundColor,
                              buttonElevation: 4,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                prefixIcon: const Icon(
                                  Icons.attach_money_rounded,
                                  size: 28,
                                  color: kThemeRed,
                                ),
                              ),
                              isExpanded: true,
                              hint: const Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  'Select Forex Instrument',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 18,
                                color: kBlack,
                                fontWeight: FontWeight.w600,
                              ),
                              itemPadding: const EdgeInsets.only(left: 30),
                              icon: const Icon(Icons.expand_more_rounded),
                              iconOnClick:
                                  const Icon(Icons.expand_less_rounded),
                              iconSize: 34,
                              buttonHeight: 60,
                              buttonPadding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: kWhite,
                              ),
                              items: _forexController.currencyPairs
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select currency pair.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _forexController.instrument =
                                    RxString(value.toString());
                              },
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.calendar_today_outlined),
                                  title: Obx(
                                    () => Text(
                                      _forexController.convertStringToDateTime(
                                          _forexController.entryDate.string),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
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
                          CustomTextField(
                            controller: _forexController.bookValueController,
                            hintText: "Book value?",
                            hintTextColor: kBlack.withOpacity(0.5),
                            prefixIcon: Icons.attach_money_rounded,
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => ListTile(
                              title:
                                  const Text("Are you still in this position?"),
                              trailing: Switch.adaptive(
                                value: _forexController.isOpen.value,
                                activeColor: kThemeRed.withOpacity(0.7),
                                onChanged: (val) =>
                                    _forexController.toggleIsOpen(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GetX<ForexController>(
                            builder: (controller) {
                              return controller.isOpen.isTrue
                                  ? const SizedBox()
                                  : AnimatedOpacity(
                                      opacity:
                                          controller.isOpen.isTrue ? 0.0 : 1.0,
                                      duration:
                                          const Duration(milliseconds: 800),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  leading: const Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                  ),
                                                  title: Obx(
                                                    () => Text(
                                                      controller
                                                          .convertStringToDateTime(
                                                        controller
                                                            .exitDate.string,
                                                      ),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              GestureDetector(
                                                child: Container(
                                                  height: 60,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    color: kWhite,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
                                            controller: controller
                                                .marketValueController,
                                            hintText: "Market value?",
                                            hintTextColor:
                                                kBlack.withOpacity(0.5),
                                            prefixIcon:
                                                Icons.money_off_csred_rounded,
                                          ),
                                        ],
                                      ),
                                    );
                            },
                          ),
                          const SizedBox(height: 40),
                          CustomButton(
                            title: "Add",
                            onTap: () {
                              var id = storageBox.read("id");
                              log("id: $id");
                              id ??= 0;
                              id++ ?? 0;
                              // id++;

                              _forexController.addTrade(
                                id: id.toString(),
                                currencyPair:
                                    _forexController.instrument.toString(),
                                entryDate: DateTime.parse(
                                    _forexController.entryDate.string),
                                exitDate: _forexController.isOpen.isTrue
                                    ? DateTime.parse(
                                        _forexController.entryDate.string)
                                    : DateTime.parse(
                                        _forexController.exitDate.string),
                                bookValue:
                                    _forexController.bookValueController.text,
                                marketValue: _forexController.isOpen.isTrue
                                    ? _forexController.bookValueController.text
                                    : _forexController
                                        .marketValueController.text,
                                isOpen: _forexController.isOpen.value,
                              );
                              storageBox.write("id", id);
                              Get.back();
                              _forexController.resetFormValues();
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
}
