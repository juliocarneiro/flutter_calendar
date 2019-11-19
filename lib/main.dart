import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import "Calendar/Calendar.dart";
import 'package:intl/intl.dart' show DateFormat;

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Calendar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime _selectedDay;
  DateTime _selectedMonth;
  String _monthName;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedMonth = DateTime.now();
    _monthName = '';
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day) {
    setState(() {
      _selectedDay = day;
    });
    print(_selectedDay);
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
      child: TableCalendar(
        formatAnimation: FormatAnimation.slide,
        startDay: DateTime.now(),
        endDay: DateTime.now().add(Duration(days: 30)),
        locale: 'pt_BR',
        calendarController: _calendarController,
        initialCalendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableGestures: AvailableGestures.all,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: true,
          weekendStyle: TextStyle().copyWith(color: Colors.black),
          holidayStyle: TextStyle().copyWith(color: Colors.black),
          contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle().copyWith(color: Colors.black),
        ),
        headerStyle: HeaderStyle(
            //headerMargin: EdgeInsets.fromLTRB(20, 30, 20, 0),
            centerHeaderTitle: true,
            formatButtonVisible: false,
            headerMargin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            titleTextStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            titleTextBuilder: (date, context) {
              String monthName = DateFormat.LLLL("pt_BR").format(date);
              return "${monthName[0].toUpperCase()}${monthName.substring(1)}";
              // _onTitleChange(date);
              //return "";
            }),
        builders: CalendarBuilders(
          dowWeekdayBuilder: (context, date) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Text(
                  '${date[0].toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          },
          todayDayBuilder: (context, date, _) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  '${date.day}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
          selectedDayBuilder: (context, date, _) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  '${date.day}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
        onDaySelected: (date, events) {
          _onDaySelected(date);
          //_animationController.forward(from: 0.0);
        },
        onVisibleDaysChanged: _onVisibleDaysChanged,
      ),
    );
  }
}
