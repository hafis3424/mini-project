import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentsTab extends StatefulWidget {
  const TournamentsTab({super.key});

  @override
  State<TournamentsTab> createState() => _TournamentsTabState();
}

class _TournamentsTabState extends State<TournamentsTab> {
  List<Map<String, dynamic>> tournaments = [
    {
      'name': 'Panthattam',
      'date': '15 July 2024',
      'location': 'Vengoor',
      'prize': 'Rs 10,000',
      'image': 'assets/images/3t.jpeg',
      'collectionName': 'panthattam_tournament',
    },
    {
      'name': '7S Tournament',
      'date': '25 July 2024',
      'location': 'Perinthalmanna',
      'prize': 'Rs 5,000',
      'image': 'assets/images/2t.jpeg',
      'collectionName': '7s_tournament',
    },
    {
      'name': 'Regional Championship',
      'date': '10 Aug 2024',
      'location': 'Manjeri',
      'prize': 'Rs 7000',
      'image': 'assets/images/1t.jpeg',
      'collectionName': 'regional_championship',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Tournaments', style: GoogleFonts.poppins()),
      ),
      body: ListView.builder(
        itemCount: tournaments.length,
        itemBuilder: (context, index) {
          final tournament = tournaments[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(tournament['image'] ?? 'assets/images/default.jpeg'),
              ),
              title: Text(tournament['name'] ?? 'Unknown Tournament', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${tournament['date'] ?? 'TBA'}', style: GoogleFonts.poppins()),
                  Text('Location: ${tournament['location'] ?? 'TBA'}', style: GoogleFonts.poppins()),
                  Text('Prize: ${tournament['prize'] ?? 'TBA'}', style: GoogleFonts.poppins()),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection(tournament['collectionName'] ?? 'tournaments').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading teams...', style: GoogleFonts.poppins());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}', style: GoogleFonts.poppins());
                      }
                      if (snapshot.hasData) {
                        int teamCount = snapshot.data!.docs.length;
                        return Text('Teams participating: $teamCount', style: GoogleFonts.poppins(fontWeight: FontWeight.bold));
                      }
                      return Text('No data available', style: GoogleFonts.poppins());
                    },
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TournamentBookingPage(tournament: tournament),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class TournamentBookingPage extends StatefulWidget {
  final Map<String, dynamic> tournament;

  const TournamentBookingPage({Key? key, required this.tournament}) : super(key: key);

  @override
  _TournamentBookingPageState createState() => _TournamentBookingPageState();
}

class _TournamentBookingPageState extends State<TournamentBookingPage> {
  final _formKey = GlobalKey<FormState>();
  String _teamName = '';
  String _managerName = '';
  String _contactDetails = '';

  Future<void> _bookTournament() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseFirestore.instance.collection(widget.tournament['collectionName'] ?? 'tournaments').add({
          'teamName': _teamName,
          'managerName': _managerName,
          'contactDetails': _contactDetails,
          'bookingDate': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking successful!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error booking tournament: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tournament Booking', style: GoogleFonts.poppins()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Column(
                  children: [
                    Image.asset(
                      widget.tournament['image'] ?? 'assets/images/default.jpeg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tournament['name'] ?? 'Unknown Tournament',
                            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Date: ${widget.tournament['date'] ?? 'TBA'}', style: GoogleFonts.poppins()),
                          Text('Location: ${widget.tournament['location'] ?? 'TBA'}', style: GoogleFonts.poppins()),
                          Text('Prize: ${widget.tournament['prize'] ?? 'TBA'}', style: GoogleFonts.poppins()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Team Registration',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Team Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your team name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _teamName = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Team Manager Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the team manager\'s name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _managerName = value!;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Contact Details',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact details';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _contactDetails = value!;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _bookTournament,
                      child: Text('Book Tournament', style: GoogleFonts.poppins()),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
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