import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/advice.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AdviceProvider with ChangeNotifier {
  final List<Advice> _advices = [];
  TimeOfDay notifyTime = TimeOfDay.now();

  AdviceProvider() : super() {
    init();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int hour = prefs.getInt('hour') ?? TimeOfDay.now().hour;
    int minute = prefs.getInt('minute') ?? TimeOfDay.now().minute;
    notifyTime = TimeOfDay(hour: hour, minute: minute);
    await loadAdvice();
    notifyListeners();
  }

  List<Advice> get advices {
    return [..._advices];
  }

  int get length {
    return _advices.length;
  }

  void addAdvice(Advice advice) {
    _advices.add(advice);
    saveAdvice().then((value) => notifyListeners());
  }

  void editAdvice(int index, Advice advice) {
    _advices[index] = advice;
    saveAdvice().then((value) => notifyListeners());
    notifyListeners();
  }

  void deleteAdvice(int index) {
    _advices.removeAt(index);
    saveAdvice().then((value) => notifyListeners());
    notifyListeners();
  }

  Future<void> saveAdvice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('advices', _advices.map((e) => e.title).toList());
  }

  Future<void> loadAdvice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getStringList('advices')?.forEach((element) {
      _advices.add(Advice(title: element));
    });
    notifyListeners();
  }

  Future<void> saveFile(String filename) async {
    File file = File(filename);
    var writer = file.openWrite();
    for (var advice in _advices) {
      writer.writeln(advice.title.replaceAll('\n', '\\n'));
    }
    writer.close();
  }

  Future<void> loadFile(String filename) async {
    File file = File(filename);
    if (file.existsSync() == false) {
      debugPrint('File does not exist');
      return;
    }
    Stream<String> lines =
        file.openRead().transform(utf8.decoder).transform(const LineSplitter());

    await for (var line in lines) {
      _advices.add(Advice(title: line.replaceAll('\\n', '\n')));
    }
    notifyListeners();
  }

  void setNotifyTime(TimeOfDay time) {
    notifyTime = time;
    // var initializationSettingsIOS = DarwinInitializationSettings();
    // InitializationSettings initializationSettings = InitializationSettings(iOS: initializationSettingsIOS);
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // flutterLocalNotificationsPlugin.zonedSchedule(0, title, body, scheduledDate, notificationDetails, uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation)

    notifyListeners();
  }
}
