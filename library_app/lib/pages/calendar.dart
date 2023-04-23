import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Event {
  final String bookTitle;

  const Event(this.bookTitle);
}

FirebaseFirestore db = FirebaseFirestore.instance;

class MyCalendar extends StatefulWidget {
  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};
  User? user = FirebaseAuth.instance.currentUser;

  void _retrieveEvents() async {
    db.collection("users").doc(user?.uid).get().then((docSnapshot) async {
      List<dynamic> loanedBooks = docSnapshot.data()?["loanedBooks"];

      Map<DateTime, List<Event>> events = {};

      loanedBooks.forEach((loanedBook) {
        DateTime dueDate = loanedBook["returnDate"].toDate();

        if (events[dueDate] == null) {
          events[dueDate] = [];
        }
        events[dueDate]!.add(Event(loanedBook["bookName"]));
      });

      setState(() {
        _events = events;
      });

      print(_events);
    }).catchError((e) => print("Error completing: $e"));
  }

  @override
  void initState() {
    super.initState();
    _retrieveEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(68, 255, 255, 255),
        elevation: 0,
        title: const Text(
          'Kalenteri',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime(2010),
            lastDay: DateTime(2050),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                final isSelectedDay = isSameDay(_selectedDay, day);
                final isEventDay = _events.keys.contains(day);
                final color = isSelectedDay
                    ? Colors.blue
                    : isEventDay
                        ? Colors.red
                        : Colors.transparent;
                return Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                );
              },
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              if (_events[day] != null) {
                return _events[day]!
                    .map((event) => ListTile(
                          title: Text(event.bookTitle),
                        ))
                    .toList();
              }
              return [];
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Upcoming Events",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final eventDate = _events.keys.elementAt(index);
                final events = _events[eventDate]!;
                final formattedDate = DateFormat.yMMMMd().format(eventDate);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        formattedDate,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    for (final event in events)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(event.bookTitle),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
