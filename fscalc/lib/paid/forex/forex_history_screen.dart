import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fscalc/free/components/cupertino_close_icon.dart';
import 'package:fscalc/free/components/cupertino_slideup_bar.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/components/custom_textfield.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/forex/forex_controller.dart';
import 'package:fscalc/paid/forex/forex_isClosed_widget.dart';
import 'package:fscalc/paid/forex/forex_isOpen_widget.dart';
import 'package:get/get.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

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
        actions: [
          IconButton(
            onPressed: () {
              _forexController.resetFormValues();
              addTradeModalBottomSheet();
              // Get.to(() => const ForexAddTrade());
              // Get.back();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Column(
            children: [
              Material(
                color: kThemeRed.withOpacity(0.97),
                child: TabBar(
                  indicatorColor: kThemeRed,
                  tabs: const [
                    Tab(
                      text: "Open",
                    ),
                    Tab(
                      text: "Closed",
                    ),
                  ],
                  labelColor: kWhite,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  indicator: MaterialIndicator(
                    height: 4,
                    topLeftRadius: 8,
                    topRightRadius: 8,
                    horizontalPadding: 50,
                    tabPosition: TabPosition.bottom,
                    color: kWhite,
                  ),
                ),
              ),
              const Expanded(
                child: AnimationLimiter(
                  child: AnimationConfiguration.staggeredList(
                    position: 0,
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: TabBarView(
                          children: [
                            //* isOpen = true
                            ForexIsOpenWidget(),
                            // * isOpen = false
                            ForexIsClosedWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                              id++;

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
