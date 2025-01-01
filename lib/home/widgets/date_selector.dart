import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milo/core/constants/utilities.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChange;
  const DateSelector(
      {super.key, required this.selectedDate, required this.onDateChange});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int weekOffset = 0;
  @override
  Widget build(BuildContext context) {
    final weekDays = generateWeekDates(weekOffset);
    String monthName = DateFormat("MMMM").format(weekDays[3]);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      weekOffset--;
                    });
                  },
                  icon: Icon(CupertinoIcons.arrow_left)),
              GestureDetector(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1960),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      currentDate: widget.selectedDate,
                      builder: (context, child) {
                        return Theme(
                            data: ThemeData(
                              colorScheme: ColorScheme.dark(
                                brightness:
                                    MediaQuery.platformBrightnessOf(context),
                                primary: Colors.orange,
                                onPrimary: Colors.white,
                              ),
                            ),
                            child: child!);
                      });
                  if (selectedDate != null) {
                    widget.onDateChange(selectedDate);
                    setState(() {
                      // get the first week of today
                      final moveValue = ((selectedDate.millisecondsSinceEpoch -
                              DateTime.now().millisecondsSinceEpoch) /
                          (1000 * 3600 * 24 * 7));
                      if (moveValue < 0 ||
                          (moveValue >= 0 &&
                              selectedDate.weekday <= DateTime.now().weekday)) {
                        weekOffset = moveValue.ceil();
                      } else {
                        weekOffset = moveValue.floor();
                      }
                    });
                  }
                },
                child: Text(monthName),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      weekOffset++;
                    });
                  },
                  icon: Icon(CupertinoIcons.arrow_right)),
            ],
          ),
        ),
        SizedBox(
          height: 48,
          child: Center(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weekDays.length,
                itemBuilder: (context, index) {
                  final day = weekDays[index];
                  bool isSelected =
                      DateFormat.yMMMd().format(widget.selectedDate) ==
                          DateFormat.yMMMd().format(day);
                  return GestureDetector(
                    onTap: () => widget.onDateChange(day),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blueGrey.shade200
                            : Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 50,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              day.day.toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat("EEE").format(day),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }
}
