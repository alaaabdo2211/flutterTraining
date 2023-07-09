import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DatePickerWidget extends StatefulWidget {
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  String _selectedDate = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showDatePicker(context);
          },
          child: Text('Select Date of Birth'),
        ),
        SizedBox(height: 16),
        Text('DOB: $_selectedDate'),
      ],
    );
  }

  void showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900),
      maxTime: DateTime.now(),
      onChanged: (date) {
      },
      onConfirm: (date) {
        setState(() {
          _selectedDate = '${date.year}-${date.month}-${date.day}';
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en, // Set the language/locale of the picker
    );
  }
}
