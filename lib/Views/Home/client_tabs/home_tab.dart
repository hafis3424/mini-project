import 'package:flutter/material.dart';
import 'TurfBookingForm.dart';
import 'Turf.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> locations = [
    'Perintalmanna',
    'Malappuram',
    'Melattur',
    'Pattikad',
    'Manjeri',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Find and Book'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'The Best Football Turfs',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: locations
                    .map(
                      (location) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Chip(
                          label: Text(location),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Featured',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FeaturedTurfs(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Recommended',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RecommendedTurfs(),
          ],
        ),
      ),
    );
  }
}

class FeaturedTurfs extends StatelessWidget {
  final List<Turf> turfs = [
    Turf(id: '1', name: "7's Turf", type: 'Grass', price: 1000),
    Turf(id: '2', name: "Greenfield Arena", type: 'Synthetic', price: 1200),
    Turf(id: '3', name: "Soccer City", type: 'Hybrid', price: 1100),
  ];

  FeaturedTurfs({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: turfs.map((turf) => FeaturedTurfCard(turf: turf)).toList(),
      ),
    );
  }
}

class FeaturedTurfCard extends StatelessWidget {
  final Turf turf;

  const FeaturedTurfCard({super.key, required this.turf});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TurfBookingForm(turf: turf)),
        );
      },
      child: Container(
        width: 250,
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/${turf.id}.jpg',
                height: 150.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      turf.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Rs${turf.price}/hr',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: const [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '4.5',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecommendedTurfs extends StatelessWidget {
  final List<Turf> turfs = [
    Turf(id: '4', name: '5s Turf', type: 'Synthetic', price: 900),
    Turf(id: '5', name: 'Goal Zone', type: 'Grass', price: 950),
    Turf(id: '6', name: 'Kicks & Tricks', type: 'Hybrid', price: 1000),
  ];

  RecommendedTurfs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: turfs.map((turf) => RecommendedTurfCard(turf: turf)).toList(),
    );
  }
}

class RecommendedTurfCard extends StatelessWidget {
  final Turf turf;

  const RecommendedTurfCard({super.key, required this.turf});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TurfBookingForm(turf: turf)),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Image.asset(
              'assets/images/${turf.id}.jpg',
              height: 100.0,
              width: 100.0,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      turf.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: const [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '4.5',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Rs${turf.price}/hr',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}