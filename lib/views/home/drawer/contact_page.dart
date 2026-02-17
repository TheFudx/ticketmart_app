import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        // centerTitle: true,
        // backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.support_agent, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "We're here to help!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Reach out to us anytime",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Contact Info Cards
            _buildContactCard(
              icon: Icons.phone,
              title: "Phone",
              detail: "+91 98195 55357",
              color: Colors.green,
            ),
            _buildContactCard(
              icon: Icons.email,
              title: "Email",
              detail: "info@ticketmart.co",
              color: Colors.redAccent,
            ),
            _buildContactCard(
              icon: Icons.location_on,
              title: "Office Address",
              detail:
                  "202 A Wing Naman Midtown, Senapati Bapat Marg, Prabhadevi, Mumbai 400013.",
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 30),

            // Footer Section
            Text(
              "We usually respond within 24 hours.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Card Widget
  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String detail,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(detail, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}
