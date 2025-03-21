import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'PaymentScreen.dart';
import 'Turf.dart';

class TurfBookingForm extends StatefulWidget {
  final Turf turf;

  const TurfBookingForm({Key? key, required this.turf}) : super(key: key);

  @override
  _TurfBookingFormState createState() => _TurfBookingFormState();
}

class _TurfBookingFormState extends State<TurfBookingForm> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  double _startSliderValue = 0;
  double _endSliderValue = 2;
  final List<String> _timeSlots = _generateTimeSlots();
  double _totalPrice = 0;
  List<bool> _slotAvailability = List.filled(48, true);

  static List<String> _generateTimeSlots() {
    List<String> slots = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final time = TimeOfDay(hour: hour, minute: minute);
        slots.add(DateFormat('HH:mm').format(DateTime(2022, 1, 1, time.hour, time.minute)));
      }
    }
    return slots;
  }

  @override
  void initState() {
    super.initState();
    _fetchBookings();
    _updatePrice();
  }

  void _fetchBookings() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    QuerySnapshot bookings = await _firestore
        .collection('bookings')
        .where('turfId', isEqualTo: widget.turf.id)
        .where('date', isEqualTo: formattedDate)
        .get();

    List<bool> newAvailability = List.filled(48, true);

    for (var doc in bookings.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String startTime = data['startTime'];
      String endTime = data['endTime'];
      
      int startSlot = _timeToSlotIndex(TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(startTime)));
      int endSlot = _timeToSlotIndex(TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(endTime)));
      
      for (int i = startSlot; i < endSlot; i++) {
        newAvailability[i] = false;
      }
    }

    setState(() {
      _slotAvailability = newAvailability;
      _updateSliderValue();
    });
  }

  int _timeToSlotIndex(TimeOfDay time) {
    return time.hour * 2 + (time.minute >= 30 ? 1 : 0);
  }

  void _updatePrice() {
    int durationInMinutes = (_endSliderValue - _startSliderValue).round() * 30;
    double durationInHours = durationInMinutes / 60;
    setState(() {
      _totalPrice = durationInHours * widget.turf.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Book ${widget.turf.name}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(Icons.sports_soccer, color: Colors.white, size: 40),
                  ),
                ),
                SizedBox(height: 20),
                Text('Turf Type: ${widget.turf.type}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                _buildDateSelection(),
                SizedBox(height: 20),
                Text('Slide to select time range', style: TextStyle(color: Colors.grey)),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.grey[300],
                    trackHeight: 4.0,
                    thumbColor: Colors.green,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    overlayColor: Colors.green.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  ),
                  child: RangeSlider(
                    values: RangeValues(_startSliderValue, _endSliderValue),
                    min: 0,
                    max: _timeSlots.length - 1.0,
                    divisions: _timeSlots.length - 1,
                    onChanged: (RangeValues values) {
                      int startSlot = values.start.round();
                      int endSlot = values.end.round();

                      // Find the nearest available start slot
                      while (startSlot < _slotAvailability.length && !_slotAvailability[startSlot]) {
                        startSlot++;
                      }

                      // Find the nearest available end slot
                      while (endSlot > startSlot && !_slotAvailability[endSlot - 1]) {
                        endSlot--;
                      }

                      if (startSlot < _slotAvailability.length && endSlot > startSlot) {
                        setState(() {
                          _startSliderValue = startSlot.toDouble();
                          _endSliderValue = endSlot.toDouble();
                          _selectedStartTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_timeSlots[startSlot]));
                          _selectedEndTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_timeSlots[endSlot]));
                          _updatePrice();
                        });
                      }
                    },
                  ),
                ),
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width - 32, 20),
                  painter: AvailabilityPainter(_slotAvailability),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeField('From', _selectedStartTime),
                    _buildTimeField('To', _selectedEndTime),
                  ],
                ),
                SizedBox(height: 20),
                Text('₹${_totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('**Partial payment is available', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    bookingData: {
                      'userId': FirebaseAuth.instance.currentUser?.uid,
                      'turfId': widget.turf.id,
                      'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
                      'startTime': DateFormat('HH:mm').format(DateTime(2022, 1, 1, _selectedStartTime.hour, _selectedStartTime.minute)),
                      'endTime': DateFormat('HH:mm').format(DateTime(2022, 1, 1, _selectedEndTime.hour, _selectedEndTime.minute)),
                      'totalPrice': _totalPrice,
                    },
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: Size(double.infinity, 50),
          ),
          child: const Text('Next'),
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30, // Show dates for the next 30 days
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _buildDateButton(date),
          );
        },
      ),
    );
  }

  Widget _buildDateButton(DateTime date) {
    final isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month && date.year == _selectedDate.year;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDate = date;
          _fetchBookings();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        side: BorderSide(color: isSelected ? Colors.green : Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'][date.month - 1],
            style: TextStyle(fontSize: 12),
          ),
          Text(
            '${date.day}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][date.weekday - 1],
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField(String label, TimeOfDay time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        GestureDetector(
          onTap: () => _selectTime(label),
          child: Text(
            DateFormat('HH:mm').format(DateTime(2022, 1, 1, time.hour, time.minute)),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _selectTime(String label) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: label == 'From' ? _selectedStartTime : _selectedEndTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (label == 'From') {
          _selectedStartTime = picked;
        } else {
          _selectedEndTime = picked;
        }
        _updateSliderValue();
        _updatePrice();
      });
    }
  }

  void _updateSliderValue() {
    int startSlot = _timeToSlotIndex(_selectedStartTime);
    int endSlot = _timeToSlotIndex(_selectedEndTime);

    // Find the nearest available start slot
    while (startSlot < _slotAvailability.length && !_slotAvailability[startSlot]) {
      startSlot++;
    }

    // Find the nearest available end slot
    while (endSlot > startSlot && !_slotAvailability[endSlot - 1]) {
      endSlot--;
    }

    if (startSlot < _slotAvailability.length && endSlot > startSlot) {
      setState(() {
        _startSliderValue = startSlot.toDouble();
        _endSliderValue = endSlot.toDouble();
        _selectedStartTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_timeSlots[startSlot]));
        _selectedEndTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(_timeSlots[endSlot]));
        _updatePrice();
      });
    }
  }
}

class AvailabilityPainter extends CustomPainter {
  final List<bool> availability;

  AvailabilityPainter(this.availability);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final slotWidth = size.width / availability.length;

    for (int i = 0; i < availability.length; i++) {
      paint.color = availability[i] ? Colors.green : Colors.red;
      canvas.drawRect(
        Rect.fromLTWH(i * slotWidth, 0, slotWidth, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}