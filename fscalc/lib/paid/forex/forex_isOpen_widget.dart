import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fscalc/free/components/cupertino_close_icon.dart';
import 'package:fscalc/free/components/cupertino_slideup_bar.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/components/custom_textfield.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/forex/forex_controller.dart';
import 'package:get/get.dart';

class ForexIsOpenWidget extends StatefulWidget {
  const ForexIsOpenWidget({Key? key}) : super(key: key);

  @override
  State<ForexIsOpenWidget> createState() => _ForexIsOpenWidgetState();
}

class _ForexIsOpenWidgetState extends State<ForexIsOpenWidget> {
  final ForexController _forexController = Get.find();

  final String _currencySymbol =
      storageBox.read("currencySymbol") ?? defaultCurrencySymbol;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _forexController.forexStreamOpenHistory(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              left: screenWidth * 0.1,
            ),
            child: ListTile(
              leading: Icon(
                Icons.info_outline_rounded,
                size: 30,
                color: kThemeRed.withOpacity(0.6),
              ),
              title: Text(
                "Something went wrong",
                style: TextStyle(
                  color: kBlack.withOpacity(0.5),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }

        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Text("Loading");
        // }'

        if (snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              var instrument = data['currencyPair'];
              var bookValue = data['bookValue'];
              var entryDate = data['entryDate'];
              var exitDate = data['exitDate'];
              var id = data['id'];
              var isOpen = data['isOpen'];
              var marketValue = data['marketValue'];
              var result = data['result'];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ExpandablePanel(
                  header: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      instrument,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  collapsed: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Entry: ${_forexController.readableDatefromMilliseconds(entryDate)}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: kBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  expanded: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          "Cost: " + _currencySymbol + bookValue,
                          style: const TextStyle(
                            fontSize: 16,
                            color: kBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Entry: ${_forexController.readableDatefromMilliseconds(entryDate)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: kBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Position Currently Open",
                          style: TextStyle(
                            fontSize: 16,
                            color: kBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    _forexController.resetFormValues();
                                    await editTradeModalBottomSheet(
                                      id: id,
                                      currencyPair: instrument,
                                      entryDate: entryDate,
                                      bookValue: bookValue,
                                      isOpen: isOpen,
                                      exitDate: exitDate,
                                      marketValue: marketValue,
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: kBlue,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                          color: kWhite,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await _forexController.confirmDelete(
                                      index: int.parse(id),
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: kBlue,
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: kWhite,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Column(
                        //   children: [
                        //     IconButton(
                        //       icon: Icon(
                        //         Icons.delete_forever_rounded,
                        //         color: kBlack.withOpacity(0.7),
                        //       ),
                        //       onPressed: () async {
                        //         await _forexController.confirmDelete(
                        //           index: id,
                        //         );
                        //       },
                        //     ),
                        //     IconButton(
                        //       icon: Icon(
                        //         Icons.edit,
                        //         color: kBlack.withOpacity(0.7),
                        //       ),
                        //       onPressed: () {
                        //         _forexController.resetFormValues();
                        //         editTradeModalBottomSheet(
                        //           id: id,
                        //           currencyPair: instrument,
                        //           entryDate: entryDate,
                        //           bookValue: bookValue,
                        //           isOpen: isOpen,
                        //           exitDate: exitDate,
                        //           marketValue: marketValue,
                        //         );
                        //       },
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  editTradeModalBottomSheet({
    required String id,
    required String currencyPair,
    required int entryDate,
    required int exitDate,
    required String bookValue,
    required String marketValue,
    required bool isOpen,
  }) {
    final ForexController _forexController = Get.put(ForexController());
    _forexController.isOpen.value = isOpen;
    _forexController.instrument = RxString(currencyPair);
    _forexController.entryDate = RxString(entryDate.toString());
    _forexController.bookValueController.text = bookValue;
    _forexController.exitDate = RxString(exitDate.toString());
    _forexController.marketValueController.text = marketValue;

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: kBackgroundColor.withOpacity(0),
      context: context,
      builder: (_) {
        Widget? child;
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.3,
          maxChildSize: 0.937,
          builder: (_, controller) {
            if (child == null) {
              return child =
                  StatefulBuilder(builder: (BuildContext context, modalState) {
                Future entryDateTimePicker() async {
                  MaterialColor colorCustom = MaterialColor(
                      0xffB61131, _forexController.dateSelectionMaterialColor);

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
                      paddingMonthHeader:
                          const EdgeInsets.symmetric(vertical: 10),
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
                    _forexController.entryDateEdit =
                        RxString(newDateTime.toString());
                  });
                }

                Future closeDateTimePicker() async {
                  MaterialColor colorCustom = MaterialColor(
                      0xffB61131, _forexController.dateSelectionMaterialColor);

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
                      paddingMonthHeader:
                          const EdgeInsets.symmetric(vertical: 10),
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
                    _forexController.exitDateEdit =
                        RxString(newDateTime.toString());
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
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              top: 20,
                              right: 15,
                              bottom: 10,
                            ),
                            child: Text(
                              "Edit Entry",
                              style: TextStyle(
                                color: kThemeRed,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: GestureDetector(
                              onTap: () {
                                _forexController.resetFormEditValues();
                              },
                              child: const CupertinoCloseIcon(),
                            ),
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
                                  hint: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      _forexController.instrument.string,
                                      style: const TextStyle(
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
                                  buttonPadding: const EdgeInsets.only(
                                      left: 20, right: 10),
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
                                    _forexController.instrumentEdit =
                                        RxString(value.toString());
                                  },
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      leading: const Icon(
                                          Icons.calendar_today_outlined),
                                      title: Obx(
                                        () => Text(
                                          "Current: " +
                                              _forexController
                                                  .readableDatefromMilliseconds(
                                                      int.parse(_forexController
                                                          .entryDate.string)),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      subtitle: Obx(
                                        () => Text(
                                          "New: " +
                                              _forexController
                                                  .convertStringToDateTime(
                                                      _forexController
                                                          .entryDateEdit
                                                          .string),
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
                                controller:
                                    _forexController.bookValueControllerEdit,
                                hintText: "Book value: \$" +
                                    _forexController.bookValueController.text,
                                hintTextColor: kBlack.withOpacity(0.5),
                                prefixIcon: Icons.attach_money_rounded,
                              ),
                              const SizedBox(height: 12),
                              ListTile(
                                title: const Text(
                                    "Are you still in this position?"),
                                trailing: Obx(
                                  () => Switch.adaptive(
                                    value: _forexController.isOpen.value,
                                    activeColor: kThemeRed.withOpacity(0.7),
                                    onChanged: (val) {
                                      _forexController.toggleIsOpen();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GetX<ForexController>(
                                builder: (controller) {
                                  return AnimatedOpacity(
                                    opacity:
                                        controller.isOpen.isTrue ? 0.0 : 1.0,
                                    duration: const Duration(milliseconds: 400),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                leading: const Icon(
                                                  Icons.calendar_today_outlined,
                                                ),
                                                title: Text(
                                                  "Curernt: " +
                                                      controller
                                                          .readableDatefromMilliseconds(
                                                        int.parse(
                                                            _forexController
                                                                .exitDate
                                                                .string),
                                                      ),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  "New: " +
                                                      controller
                                                          .convertStringToDateTime(
                                                              _forexController
                                                                  .exitDateEdit
                                                                  .string),
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
                                                      BorderRadius.circular(8),
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
                                              .marketValueControllerEdit,
                                          hintText: "Market value: \$" +
                                              controller
                                                  .marketValueController.text,
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
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.only(bottom: 30),
                        child: CustomButton(
                          title: "Submit",
                          width: double.maxFinite,
                          onTap: () {
                            _forexController.editTrade(
                              id: id,
                              currencyPair:
                                  _forexController.instrumentEdit.string,
                              entryDate: DateTime.parse(
                                  _forexController.entryDateEdit.string),
                              exitDate: _forexController.isOpenEdit.isTrue
                                  ? DateTime.parse(
                                      _forexController.entryDateEdit.string)
                                  : DateTime.parse(
                                      _forexController.exitDateEdit.string),
                              bookValue:
                                  _forexController.bookValueControllerEdit.text,
                              marketValue: _forexController.isOpenEdit.isTrue
                                  ? _forexController
                                      .bookValueControllerEdit.text
                                  : _forexController
                                      .marketValueControllerEdit.text,
                              isOpen: _forexController.isOpenEdit.value,
                            );

                            _forexController.resetFormEditValues();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
            }
            return child!;
          },
        );
      },
    );
  }
}
