import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:event_bus_tutorial/event/theme_change_event.dart';
import 'package:flutter/material.dart';

EventBus eventBus = EventBus();

class EventBusWidget extends StatefulWidget {
  const EventBusWidget({Key? key}) : super(key: key);

  @override
  _EventBusWidgetState createState() => _EventBusWidgetState();
}

class _EventBusWidgetState extends State<EventBusWidget> {
  TextEditingController color =  TextEditingController();
  Color? _primaryColor;
  StreamSubscription? _colorStreamSub;
  static const Color primaryColor = Color(0xff7C46B3);

  static Color getColor(String colorStr) {
      if (colorStr.substring(0, 1) != "#") {
        return primaryColor;
      }
      String substring = colorStr.substring(1, colorStr.length);
      return Color(int.parse('0xff' + substring));
  }

  @override
  void dispose() {
    super.dispose();
    _colorStreamSub?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _colorStreamSub = eventBus.on<ThemeChangeEvent>().listen((event) {
      Color color = getColor(event.colorStr);
      setState(() {
        _primaryColor = color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor,
      appBar: AppBar(
        title: const Text("Event Bus"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
                height: 48.00,
                width: 343.00,
                child: TextFormField(
                    controller: color,
                    decoration: InputDecoration(
                        hintText:
                        "Theme Color HexCode",
                        hintStyle: const TextStyle(
                          fontSize: 16
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                5.00),
                            borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.00),
                            borderSide: const BorderSide(color: Colors.blue, width: 1)),
                        isDense: true,
                        contentPadding: const EdgeInsets.only(top: 16.80, bottom: 16.80, left: 10)),
                    style: const TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Poppins', fontWeight: FontWeight.w400))),
            Container(
              padding: const EdgeInsets.all(18.0),
              width: 143.00,
              child: ElevatedButton(
                  onPressed: () {
                    eventBus.fire(ThemeChangeEvent(color.text));
                  },
                  child: const Text("Enter"),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
