import 'package:flutter/material.dart';

class AdminHomeTab extends StatefulWidget {
  const AdminHomeTab({super.key});

  @override
  _AdminHomeTabState createState() => _AdminHomeTabState();
}

class _AdminHomeTabState extends State<AdminHomeTab> {
  List<String> availableTimes = [
    '09:00 AM',
    '11:00 AM',
    '01:00 PM',
    '03:00 PM'
  ];
  List<Tournament> tournaments = [
    Tournament(
      name: 'Summer Cup 2024',
      date: 'June 1 - June 30, 2024',
      registrationDeadline: 'May 15, 2024',
    ),
  ];
  int weekdayPrice = 25;
  int weekendPrice = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Center(
                child: Text(
                  'Available Booking Times',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    availableTimes.map((time) => _buildTimeSlot(time)).toList(),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _showAddTimeDialog,
                child: const Text('Add Time'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Upcoming Tournaments',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              ...tournaments
                  .map((tournament) => _buildTournamentCard(tournament))
                  ,
              ElevatedButton(
                onPressed: _showAddTournamentDialog,
                child: const Text('Add Tournament'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Hourly Rent Price',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => _showEditPriceDialog('Weekday', weekdayPrice),
                    child: _buildPriceCard('\$$weekdayPrice', 'Weekday'),
                  ),
                  GestureDetector(
                    onTap: () => _showEditPriceDialog('Weekend', weekendPrice),
                    child: _buildPriceCard('\$$weekendPrice', 'Weekend'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditTimeDialog(time),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteTime(time),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(String price, String label) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            price,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentCard(Tournament tournament) {
    return GestureDetector(
      onTap: () => _showEditTournamentDialog(tournament),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tournament.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Date: ${tournament.date}'),
            Text('Registration Deadline: ${tournament.registrationDeadline}'),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => _deleteTournament(tournament),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTimeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Time'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter time',
          ),
          onSubmitted: (value) {
            setState(() {
              availableTimes.add(value);
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showEditTimeDialog(String time) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Time'),
        content: TextField(
          controller: TextEditingController(text: time),
          onSubmitted: (value) {
            setState(() {
              availableTimes[availableTimes.indexOf(time)] = value;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _deleteTime(String time) {
    setState(() {
      availableTimes.remove(time);
    });
  }

  void _showAddTournamentDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController registrationDeadlineController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tournament'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Tournament Name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                hintText: 'Tournament Date',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: registrationDeadlineController,
              decoration: const InputDecoration(
                hintText: 'Registration Deadline',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text.trim();
                String date = dateController.text.trim();
                String registrationDeadline =
                    registrationDeadlineController.text.trim();

                if (name.isNotEmpty &&
                    date.isNotEmpty &&
                    registrationDeadline.isNotEmpty) {
                  _addTournament(name, date, registrationDeadline);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all the fields'),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTournamentDialog(Tournament tournament) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tournament'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Tournament Name',
              ),
              onSubmitted: (value) {
                _updateTournament(
                  tournament,
                  value,
                  tournament.date,
                  tournament.registrationDeadline,
                );
              },
              controller: TextEditingController(text: tournament.name),
            ),
            const SizedBox(height: 8.0),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Tournament Date',
              ),
              onSubmitted: (value) {
                _updateTournament(
                  tournament,
                  tournament.name,
                  value,
                  tournament.registrationDeadline,
                );
              },
              controller: TextEditingController(text: tournament.date),
            ),
            const SizedBox(height: 8.0),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Registration Deadline',
              ),
              onSubmitted: (value) {
                _updateTournament(
                  tournament,
                  tournament.name,
                  tournament.date,
                  value,
                );
                Navigator.pop(context);
              },
              controller:
                  TextEditingController(text: tournament.registrationDeadline),
            ),
          ],
        ),
      ),
    );
  }

  void _addTournament(String name, String date, String registrationDeadline) {
    setState(() {
      tournaments.add(
        Tournament(
          name: name,
          date: date,
          registrationDeadline: registrationDeadline,
        ),
      );
    });
  }

  void _updateTournament(Tournament tournament, String name, String date,
      String registrationDeadline) {
    setState(() {
      tournaments[tournaments.indexOf(tournament)] = Tournament(
        name: name,
        date: date,
        registrationDeadline: registrationDeadline,
      );
    });
  }

  void _deleteTournament(Tournament tournament) {
    setState(() {
      tournaments.remove(tournament);
    });
  }

  void _showEditPriceDialog(String label, int currentPrice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label Price'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter price',
          ),
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: currentPrice.toString()),
          onSubmitted: (value) {
            setState(() {
              if (label == 'Weekday') {
                weekdayPrice = int.parse(value);
              } else {
                weekendPrice = int.parse(value);
              }
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class Tournament {
  final String name;
  final String date;
  final String registrationDeadline;
  Tournament({
    required this.name,
    required this.date,
    required this.registrationDeadline,
  });
}
