import 'package:flutter/material.dart';

class TimePickerTextField1 extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onTimeChanged;

  TimePickerTextField1({
    required this.initialValue,
    required this.onTimeChanged,
  });

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(DateTime.parse("2023-09-10 $initialValue:00")),
    );

    if (selectedTime != null) {
      String formattedTime =
          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      onTimeChanged(formattedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            initialValue,
            style: TextStyle(fontSize: 16),
          ),
          Icon(Icons.access_time),
        ],
      ),
    );
  }
}
