import 'package:flutter/material.dart';
import 'TurfBookingForm.dart';
import 'Turf.dart';

class TurfListPage extends StatefulWidget {
  const TurfListPage({super.key});

  @override
  _TurfListPageState createState() => _TurfListPageState();
}

class _TurfListPageState extends State<TurfListPage> {
  List<Turf> turfs = [
    Turf(id: '1', name: "7's Turf", type: 'Grass', price: 1000),
    Turf(id: '2', name: "Greenfield Arena", type: 'Synthetic', price: 1200),
    Turf(id: '3', name: "Soccer City", type: 'Hybrid', price: 1100),
    Turf(id: '4', name: '5s Turf', type: 'Synthetic', price: 900),
    Turf(id: '5', name: 'Goal Zone', type: 'Grass', price: 950),
    Turf(id: '6', name: 'Kicks & Tricks', type: 'Hybrid', price: 1000),
  ];

  List<Turf> filteredTurfs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredTurfs = turfs;
  }

  void _filterTurfs(String query) {
    setState(() {
      filteredTurfs = turfs
          .where((turf) =>
              turf.name.toLowerCase().contains(query.toLowerCase()) ||
              turf.type.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turf List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterTurfs,
              decoration: const InputDecoration(
                hintText: 'Search turfs',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTurfs.length,
              itemBuilder: (context, index) {
                final turf = filteredTurfs[index];
                return TurfCard(
                  turf: turf,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TurfBookingForm(turf: turf)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TurfCard extends StatelessWidget {
  final Turf turf;
  final VoidCallback onTap;

  const TurfCard({
    super.key,
    required this.turf,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.asset(
          'assets/images/${turf.id}.jpg',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(turf.name),
        subtitle: Text('Type: ${turf.type}'),
        trailing: Text('Rs${turf.price}/hr'),
        onTap: onTap,
      ),
    );
  }
}