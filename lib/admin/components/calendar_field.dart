import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class CalendarPickerField extends StatefulWidget {
  const CalendarPickerField({
    super.key,
    this.restorationId,
    this.dateText,
    this.name,
    this.icon,
    this.backgroundColor,
    this.value,
    this.dateTime,
    this.onChange,
  });

  final String? restorationId;
  final String? dateText;
  final String? name;
  final Icon? icon;
  final Color? backgroundColor;
  final String? value;
  final String? dateTime;
  final Function(String)? onChange;

  @override
  State<CalendarPickerField> createState() => _CalendarPickerFieldState();
}

class _CalendarPickerFieldState extends State<CalendarPickerField> with RestorationMixin {

  late TextEditingController textController;

  DateTime? dateTime;

  @override
  void initState() {
    textController = TextEditingController(text: widget.value ?? '');

    if(widget.dateTime != null) {
      dateTime = DateTime.parse(widget.dateTime.toString());
    }

    super.initState();
  }

  @override
  String? get restorationId => widget.restorationId;


  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());

  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture = RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
    Route<DateTime> _datePickerRoute(
      BuildContext context,
      Object? arguments,
      ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {

        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: dateTime ?? DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(1980),
          lastDate: DateTime(DateTime.now().year + 5)
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

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        widget.onChange!(newSelectedDate.toString());
        textController = TextEditingController(text: Jiffy.parse(newSelectedDate.toString()).format(pattern: 'dd/MM/yyyy'));
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (widget.name != null) ?
        Row(
          children: [
            widget.icon ?? const SizedBox.shrink(),
            Text(
              widget.name ?? '',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        ) : const SizedBox.shrink(),
        const SizedBox(height: 5),
        Container(
          color: widget.backgroundColor ?? Colors.transparent,
          child: getTextField(),
        )

      ],

    );
  }

  Widget getTextField() {
    return TextField(
      // readOnly: true,
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: Colors.deepPurple,
        fontWeight: FontWeight.bold,
        fontSize: 14.0
      ),
      controller: textController,
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
              color: Colors.grey
          ),
          // gapPadding: 1.0
        ),
        border: const OutlineInputBorder(
          // borderRadius: BorderRadius.circular(30.0),
        ),
        fillColor: Colors.white24,
        filled: true,
        hintStyle:  TextStyle(
            color: Colors.black.withOpacity(0.4),
            fontWeight: FontWeight.bold
        ),
        hintText: widget.dateText,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      onTap: () {
        _restorableDatePickerRouteFuture.present();
      },
    );
  }
}
