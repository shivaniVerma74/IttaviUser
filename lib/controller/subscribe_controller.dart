// ignore_for_file: unused_field, prefer_final_fields, avoid_print, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings

import 'dart:ffi';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:table_calendar/table_calendar.dart';

class SubScibeController extends GetxController implements GetxService {
  bool isLoading = false;

  List<String> selectedIndexes = [];

  String selectDate = "";

  int? currentIndex;
  List <int> selectedMonth = [];
  List <String> selectedMonth1 = [];
  String deliveries = "";
  String selectTime = "";

  String selectDay = "";
  DateTime? selectedDate;
  String selectMonth = "";
  String selectYear = "";

  String editDate = "";

  List<String> onSelectedWeek2 = [];

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  List<String> day = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  addAndRemovedays(index) {
    if (selectedIndexes.contains(day[index])) {
      selectedIndexes.remove(day[index]);
      print("jhhsdghjsghdg ${selectedIndexes}");
      update();
    } else {
      selectedIndexes.add(day[index]);
      update();
    }
  }

  dailySelection() {
    whichDaySelected = '0';

    selectedIndexes = [];
    for (var i = 0; i < day.length; i++) {
      selectedIndexes.add(day[i]);
    }
selectDay = '';
    editDate ='';
    update();
  }

  weekdaysSelection() {
    whichDaySelected = '1';

    selectedIndexes = [];
    for (var i = 0; i < 5; i++) {
      selectedIndexes.add(day[i]);
    }
    selectDay = '';
    editDate ='';
    update();
  }

  weekendsSelection() {
    whichDaySelected = '2';
    selectedIndexes = [];
    for (var i = 0; i < day.length; i++) {
      if (day[i] == "Saturday" || day[i] == "Sunday") {
        selectedIndexes.add(day[i]);
      }
    }
    selectDay = '';
    editDate ='';
    update();
  }

  int tempDelivery = 0;

  changeIndex(index, String? title, String? month) {
    //currentIndex = index;

    if (selectedMonth.contains(index)) {
      selectedMonth.remove(index);
      selectedMonth1.remove(month);
      tempDelivery -= int.parse(title ?? '0');
    } else {
      if (selectedMonth.length < 3) {
        selectedMonth.add(index);
        selectedMonth1.add(month ?? '');
        tempDelivery += int.parse(title ?? '0');
      }
    }



    // deliveries = title ?? '0';
    deliveries = tempDelivery.toString();
    selectDay = '';
    editDate ='';
    update();
  }

  changeIndexWiseValue({String? time}) {
    selectTime = time ?? "";
    update();
  }

  getDate( {String? day1, month1, year1, selectdate1, DateTime? selectedDate1}) {
    selectDay = day1 ?? "";
    selectMonth = month1;
    selectYear = year1;
    selectDate = selectdate1;
    selectedDate = selectedDate1;
    editDate = "${selectDay}-${selectMonth}-${selectYear}";
    if(selectedMonth.isNotEmpty && selectedIndexes.isNotEmpty){
      getdeleiveryData();
    }else {
      Fluttertoast.showToast(msg: 'Please select month and day first');
    }
    update();
  }

  getSelectedItemEditValue({
    List<String>? selectDay1,
    String? selectDeliveris1,
    selectTime1,
    selectDate1,
  }) {
    print("----------(selectDay1)------->>" + selectDay1.toString());
    print(
        "----------(selectDeliveris1)------->>" + selectDeliveris1.toString());
    print("----------(selectTime1)------->>" + selectTime1.toString());
    print("----------(selectDate1)------->>" + selectDate1.toString());
    selectedIndexes = [];
    selectedIndexes = selectDay1 ?? [];
    deliveries = selectDeliveris1 ?? "";
    editDate = selectDate1;
    selectTime = selectTime1;

   // selectedDate = DateTime.parse('${selectDate1} 00:00:000');
    update();
  }

  DateTime? endDate;
  String? whichDaySelected = '0';
  int totalweekdaysCount = 0 ;

  finalDays(int month, int i) {
    //DateTime startDate = DateTime.parse(startDateController.text);
    // Calculate end date based on the selected month
    int selectedMonthNumber = month.toString().length==2 ? DateTime
        .parse('2024-${month + 1}-01 00:00:00.000Z')
        .month  : DateTime
        .parse('2024-0${month + 1}-01 00:00:00.000Z').month;
    endDate = DateTime(selectedDate!.year, selectedMonthNumber + 1, 0);
    if (selectedMonth.length > 1 && i != 0) {
      selectedDate = DateTime(selectedDate!.year, selectedMonthNumber, 1);
    }
    // Display the result

  }

  int getMonthNumber(String month) {
    print("n=moyhhhh ${month}");
    switch (month) {
      case 'Jan':
        return 01;
      case 'Feb':
        return 02;
      case 'Mar':
        return 03;
      case 'Apr':
        return 04;
      case 'May':
        return 05;
      case 'Jun':
        return 06;
      case 'Jul':
        return 07;
      case 'Aug':
        return 08;
      case 'Sep':
        return 09;
      case 'Oct':
        return 10;
      case 'Nov':
        return 11;
      case 'Dec':
        return 12;
      default:
        return 0;
    }
  }



  getdeleiveryData() {
    totalweekdaysCount = 0;
    for (int i = 0; i < selectedMonth.length; i++) {
      finalDays(selectedMonth[i], i);
      if (whichDaySelected == '0') {
        dailyDays(i);
      }
      else if (whichDaySelected == '1') {
        wekdays(i);
      }
      else {
        wekenddays();
      }
    }
  }

  dailyDays(int i) {

    int daysDifference = endDate!.difference(selectedDate!).inDays;


    if(i == 0) {
      totalweekdaysCount+= daysDifference+2;
    } else if(i == 1) {
    totalweekdaysCount+= daysDifference+1;;
    }else {
    totalweekdaysCount+= daysDifference+1;
    }



    deliveries = totalweekdaysCount.toString();

  }

  wekdays(int i) {
    int weekdaysCount = 0;
    DateTime? currentDate = selectedDate;
    while (currentDate!.isBefore(endDate!) || currentDate.isAtSameMomentAs(endDate!)) {
      // Check if the current day is a weekday (Monday to Friday)
      if (currentDate.weekday >= DateTime.monday && currentDate.weekday <= DateTime.friday) {
        weekdaysCount++;
      }
      // Move to the next day
      currentDate = currentDate.add(Duration(days: 1));
    }
    if(i == 0)
      {
        totalweekdaysCount+= weekdaysCount+1;
      }else if(i == 1) {
      totalweekdaysCount+= weekdaysCount;
    }else {
      totalweekdaysCount+= weekdaysCount+1;
    }

    deliveries = totalweekdaysCount.toString();
    // Display the result
    // setState(() {
    //   result = 'Weekdays between ${_selectedDay?.toLocal()} and ${endDate!.toLocal()}: $weekdaysCount days';
    // });
  }

  wekenddays() {
    int weekendsCount = 0;
    DateTime? currentDate = selectedDate;
    while (currentDate!.isBefore(endDate!) || currentDate.isAtSameMomentAs(endDate!)) {
      // Check if the current day is a weekend (Saturday or Sunday)
      if (currentDate.weekday == DateTime.saturday || currentDate.weekday == DateTime.sunday) {
        weekendsCount++;
      }
      // Move to the next day
      currentDate = currentDate.add(Duration(days: 1));
    }
    totalweekdaysCount+= weekendsCount;
    deliveries = totalweekdaysCount.toString();
    // Display the result
    /*setState(() {
      result =
      'Weekends between ${_selectedDay?.toLocal()} and ${endDate!.toLocal()}: $weekendsCount days';
    });*/
  }
}