import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_app/screens/edit_alarm.dart';
import 'package:fyp_app/widget/expiry_alarm_tile.dart';
import 'package:intl/intl.dart';

class ExpiryManagerScreen extends StatefulWidget {
  const ExpiryManagerScreen({Key? key}) : super(key: key);

  @override
  State<ExpiryManagerScreen> createState() => _ExpiryManagerScreenState();
}

class ExpiryInfo {
  AlarmSettings alarm;
  DateTime expiryDate;
  String foodItem;

  ExpiryInfo(this.alarm, this.expiryDate, this.foodItem);
}

// this is supposed to be imported from firestore
class ReminderModel {}

class _ExpiryManagerScreenState extends State<ExpiryManagerScreen> {
  // late List<ExpiryInfo> expiryInfos;
  // late ReminderModel _model;

  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    loadAlarms();
    // subscription ??= Alarm.ringStream.stream.listen(
    //     (alarmSettings) => navigateToRingScreen(alarmSettings),
    // );
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  // Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) =>
  //           ExpiryRingScreen(alarmSettings: alarmSettings),
  //     ));
  //   loadAlarms();
  // }

  Future<void> navigateToAlarmScreen(
      String? id, AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.5,
            child: EditAlarmModal(id: id, alarmSettings: settings),
          );
        });

    if (res != null && res == true) loadAlarms();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("expiry_infos")
                      .snapshots(),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    // if (!snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data?.docs[index]
                              as DocumentSnapshot<Object?>;
                          return ExpiryAlarmTile(
                            key: Key(data.id),
                            title: data['food_name'],
                            expiry:
                                "Expiring on ${DateFormat('MM/dd/yyyy').format(data['expiry'].toDate())}",
                            onPressed: () => {
                              navigateToAlarmScreen(
                                  data.id,
                                  alarms.firstWhere((element) =>
                                      element.id.toString() ==
                                      data["alarm_id"].toString()))
                            },
                          );
                        },
                      );
                    }
                    return Text("No alarms");
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAlarmScreen(null, null),
        child: const Icon(Icons.alarm_add_rounded, size: 33),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
