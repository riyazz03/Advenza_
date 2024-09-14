import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/api.dart';
import 'get_started.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        DocumentSnapshot documentSnapshot =
            await _firestore.collection('users').doc(uid).get();

        if (documentSnapshot.exists) {
          setState(() {
            userData = documentSnapshot.data() as Map<String, dynamic>;
          });
        } else {
          print('No user data found for UID: $uid');
        }
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _logOut() async {
    try {
      await Auth().signOut(); // Use the Auth class to sign out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const GetStartedPage()), // Redirect to Get Started Page
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile Page',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 42, 88, 42),
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userData!['name'] ?? 'No name',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Email', style: TextStyle(fontSize: 16)),
                          Text(userData!['email'] ?? 'No email',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Location',
                              style: TextStyle(fontSize: 16)),
                          Text(userData!['location'] ?? 'No location',
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Recently Visited',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildVisitedCard('assests/sm-park-1.png', 'India'),
                          _buildVisitedCard(
                              'assests/sm-park-2.png', 'Singapore'),
                          _buildVisitedCard('assests/sm-park-3.png', 'Germany'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 42, 88, 42),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn('4.3', 'Average Rating'),
                            _buildStatColumn('37', 'Parks Visited'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn('13,000', 'Tickets'),
                            _buildStatColumn('02', 'Booked Rides'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _logOut, // Use the log out function
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 111, 10, 10),
                            foregroundColor:
                                const Color.fromARGB(255, 42, 88, 42),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildVisitedCard(String imagePath, String location) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(
            imagePath,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          location,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 40, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
