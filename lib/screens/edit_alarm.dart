import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditAlarmModal extends StatefulWidget {
  final String? id;
  final AlarmSettings? alarmSettings;
  final String? restorationId;

  const EditAlarmModal(
      {Key? key, this.id, this.alarmSettings, this.restorationId})
      : super(key: key);

  @override
  State<EditAlarmModal> createState() => _EditAlarmModalState();
}

class _EditAlarmModalState extends State<EditAlarmModal> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;
  String? get documentId => widget.id;

  bool loading = false;

  late bool creating;
  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late bool volumeMax;
  late bool showNotification;
  late String assetAudio;

  final textController = TextEditingController();

  final RestorableDateTime _selectedDate = RestorableDateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime.now(),
          lastDate: DateTime(2024),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) async {
    if (newSelectedDate != null) {
      final selectedDate = newSelectedDate.copyWith(hour: 21, minute: 0);
      setState(() {
        _selectedDate.value = selectedDate;
        selectedDateTime = selectedDate;
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}   ${_selectedDate.value.hour}:${_selectedDate.value.minute}'),
        // ));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volumeMax = false;
      showNotification = true;
      assetAudio = 'assets/one_piece.mp3';
    }
    // } else {
    //   selectedDateTime = widget.alarmSettings!.dateTime;
    //   loopAudio = widget.alarmSettings!.loopAudio;
    //   vibrate = widget.alarmSettings!.vibrate;
    //   volumeMax = widget.alarmSettings!.volumeMax;
    //   showNotification = widget.alarmSettings!.notificationTitle != null &&
    //       widget.alarmSettings!.notificationTitle!.isNotEmpty &&
    //       widget.alarmSettings!.notificationBody != null &&
    //       widget.alarmSettings!.notificationBody!.isNotEmpty;
    //   assetAudio = widget.alarmSettings!.assetAudioPath;
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text(
    //         'Selected: ${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year}'),
    //   ));
    // }
  }

  Future<void> pickDate() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        selectedDateTime = selectedDateTime.copyWith(
          hour: res.hour,
          minute: res.minute,
        );
        if (selectedDateTime.isBefore(DateTime.now())) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000
        : widget.alarmSettings!.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime.subtract(const Duration(days: 3)),
      loopAudio: loopAudio,
      vibrate: vibrate,
      volumeMax: volumeMax,
      notificationTitle: showNotification ? 'Your food is expiring!!' : null,
      notificationBody: showNotification ? 'Your food is dying' : null,
      assetAudioPath: assetAudio,
      stopOnNotificationOpen: true,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    final db = FirebaseFirestore.instance.collection("expiry_infos");
    AlarmSettings alarm;
    alarm = buildAlarmSettings();
    setState(() => loading = true);
    Alarm.set(alarmSettings: alarm).then((res) {
      if (res) Navigator.pop(context, true);
    });
    final data = {
      'alarm_id': alarm.id.toString(),
      'expiry': Timestamp.fromDate(alarm.dateTime.add(const Duration(days: 3))),
      'food_name': textController.text,
    };
    if (creating) {
      db.add(data).then((documentSnapshot) =>
          print("Added new alarm data with ID: ${documentSnapshot.id}"));
    } else {
      db.doc(documentId).update(data).then(
          (value) => print("Firebase: DocumentSnapshot successfully updated!"),
          onError: (e) => print("Firebase: Error updating document $e"));
    }

    setState(() => loading = false);
  }

  void deleteAlarm() {
    final db = FirebaseFirestore.instance.collection("expiry_infos");
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res) Navigator.pop(context, true);
    });
    db.doc(documentId).delete().then(
            (doc) => print("Firebase: Document deleted!"),
        onError: (e) => print("Firebase: Error updating document $e"));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Create new expiry alarm',
            style: TextStyle(fontSize: 20),
          ),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter food item name',
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              _restorableDatePickerRouteFuture.present();
            },
            fillColor: Colors.grey[200],
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.blueAccent),
              ),
            ),
          ),
          Text(
            'An alarm will be created 3 days before the expiry date',
            style: TextStyle(fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancel",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: saveAlarm,
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(
                        "Save",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.blueAccent),
                      ),
              ),
            ],
          ),
          if (!creating)
            TextButton(
              onPressed: deleteAlarm,
              child: Text(
                'Delete Alarm',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }
}
