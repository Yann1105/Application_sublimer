import 'package:flutter/material.dart';
import 'employees_screen.dart';
import 'logistics_screen.dart';
import 'finance_screen.dart';
import 'reports_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simulez la récupération du prénom (à remplacer par votre logique réelle)
    String firstName = FirebaseAuth.instance.currentUser?.displayName?.split(' ').first ?? "Utilisateur";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tableau de Bord",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(221, 78, 77, 77),
        elevation: 0,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: MediaQuery.of(context).size.width * 0.2, // Responsive
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Bienvenue $firstName",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? '',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(Icons.people, "Employés", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EmployeesScreen()),
                );
              }),
              _buildDrawerItem(Icons.inventory, "Équipements", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LogisticsScreen()),
                );
              }),
              _buildDrawerItem(Icons.attach_money, "Financier", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FinanceScreen()),
                );
              }),
              _buildDrawerItem(Icons.picture_as_pdf, "Rapports PDF", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReportsScreen()),
                );
              }),
              Divider(color: Colors.grey),
              _buildDrawerItem(Icons.logout, "Déconnexion", () => _logout(context),
                  iconColor: Colors.red, textColor: Colors.red),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Fond blanc
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre principal
              Text(
                "Gestionnaire",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.08, // Responsive
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4, // Responsive
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildDashboardCard(
                      context,
                      icon: Icons.people,
                      label: "Employés",
                      destination: EmployeesScreen(),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.inventory,
                      label: "Équipements",
                      destination: LogisticsScreen(),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.attach_money,
                      label: "Financier",
                      destination: FinanceScreen(),
                    ),
                    _buildDashboardCard(
                      context,
                      icon: Icons.picture_as_pdf,
                      label: "Rapports PDF",
                      destination: ReportsScreen(),
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

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap,
      {Color iconColor = Colors.black87, Color textColor = Colors.black87}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon, required String label, required Widget destination}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destination),
      ),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.orange, // Cartes orange pour contraste
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: MediaQuery.of(context).size.width * 0.1, // Responsive
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive
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