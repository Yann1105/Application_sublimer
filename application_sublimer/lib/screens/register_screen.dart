import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    // Implémentez ici la connexion avec Google
    print("Connexion avec Google...");
  }

  Future<void> _signInWithFacebook() async {
    // Implémentez ici la connexion avec Facebook
    print("Connexion avec Facebook...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sublime'r",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(221, 78, 77, 77),
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[200], // Fond gris clair
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image responsive
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.35, // Hauteur responsive
              //   child: Image.asset(
              //     // "assets/images/logo.png", // Chemin vers votre image
              //     fit: BoxFit.contain, // Ajustement de l'image
              //   ),
              // ),
              SizedBox(height: 16),
              // Titre principal
              Text(
                "Inscription",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              _buildTextField(
                controller: _firstNameController,
                labelText: 'Prénom',
                obscureText: false,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _lastNameController,
                labelText: 'Nom',
                obscureText: false,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                obscureText: false,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                labelText: 'Mot de passe',
                obscureText: true,
              ),
              SizedBox(height: 24),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "S'inscrire",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Vous avez déjà un compte ? ",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Connexion",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Ou inscrivez-vous avec :",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bouton Google
                  ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: Icon(Icons.g_mobiledata, color: Colors.white),
                    label: Text("Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Bouton Facebook
                  ElevatedButton.icon(
                    onPressed: _signInWithFacebook,
                    icon: Icon(Icons.facebook, color: Colors.white),
                    label: Text("Facebook"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: obscureText,
    );
  }
}