import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isGenerating = false;
  String? _message;

  Future<void> _generateReport(String reportType) async {
    setState(() {
      _isGenerating = true;
      _message = null;
    });

    try {
      await PDFService.generateReport(reportType);
      setState(() => _message = "Rapport $reportType généré avec succès !");
    } catch (e) {
      setState(() => _message = "Erreur lors de la génération du rapport : $e");
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rapports PDF",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor:Color.fromARGB(221, 78, 77, 77),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white, // Fond blanc
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre principal
              Text(
                "Les différents rapports",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildReportButton("employes", "Rapport Présences & Salaires"),
                    SizedBox(height: 16),
                    _buildReportButton("logistique", "Rapport Logistique"),
                    SizedBox(height: 16),
                    _buildReportButton("finances", "Rapport Financier"),
                  ],
                ),
              ),
              if (_isGenerating)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                ),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _message!.contains("succès") ? Colors.green : Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportButton(String reportType, String label) {
    return ElevatedButton(
      onPressed: () => _generateReport(reportType),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.picture_as_pdf, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}