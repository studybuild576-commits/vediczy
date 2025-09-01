import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Wallpaper
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/ssc_wallpaper.jpg'), // Add your wallpaper image here
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Content
          Column(
            children: [
              // User Greeting Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'नमस्ते!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Vediczy में आपका स्वागत है।',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Exam Cards Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: const [
                      ExamCard(
                        title: 'SSC CGL',
                        icon: Icons.school,
                        color: Colors.blue,
                      ),
                      ExamCard(
                        title: 'SSC CHSL',
                        icon: Icons.school,
                        color: Colors.green,
                      ),
                      ExamCard(
                        title: 'SSC MTS',
                        icon: Icons.school,
                        color: Colors.orange,
                      ),
                      ExamCard(
                        title: 'SSC GD',
                        icon: Icons.school,
                        color: Colors.red,
                      ),
                      ExamCard(
                        title: 'SSC CPO',
                        icon: Icons.school,
                        color: Colors.purple,
                      ),
                      ExamCard(
                        title: 'SSC Stenographer',
                        icon: Icons.school,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const ExamCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          onTap: () {
            // Exam details screen navigation
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
