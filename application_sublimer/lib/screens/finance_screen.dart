import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FinanceScreen extends StatefulWidget {
  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedType = 'Recette';
  String _selectedCategory = 'Général';
  DateTime? _startDate;
  DateTime? _endDate;

  final List<Map<String, dynamic>> _transactions = [];

  void _addTransaction() {
    if (_amountController.text.isEmpty) return;
    setState(() {
      _transactions.add({
        'amount': double.tryParse(_amountController.text) ?? 0,
        'description': _descriptionController.text,
        'type': _selectedType,
        'category': _selectedCategory,
        'date': DateTime.now(),
      });
      _amountController.clear();
      _descriptionController.clear();
    });
  }

  void _editTransaction(int index) {
    final tx = _transactions[index];
    _amountController.text = tx['amount'].toString();
    _descriptionController.text = tx['description'];
    _selectedType = tx['type'];
    _selectedCategory = tx['category'];
    setState(() {
      _transactions.removeAt(index);
    });
  }

  void _deleteTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
    });
  }

  double _calculateBalance() {
    double total = 0;
    for (var tx in _transactions) {
      if (tx['type'] == 'Recette') {
        total += tx['amount'];
      } else {
        total -= tx['amount'];
      }
    }
    return total;
  }

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_startDate == null || _endDate == null) return _transactions;
    return _transactions.where((tx) {
      return tx['date'].isAfter(_startDate!.subtract(Duration(days: 1))) &&
          tx['date'].isBefore(_endDate!.add(Duration(days: 1)));
    }).toList();
  }

  void _exportToPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Rapport Financier", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ..._filteredTransactions.map((tx) => pw.Text(
                  "${DateFormat('dd/MM/yyyy').format(tx['date'])} - ${tx['type']} - ${tx['category']} - ${tx['description']} : ${tx['amount']} FCFA",
                  style: pw.TextStyle(fontSize: 12),
                )),
            pw.SizedBox(height: 20),
            pw.Text("Solde total : ${_calculateBalance()} FCFA", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _pickDateRange() async {
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (result != null) {
      setState(() {
        _startDate = result.start;
        _endDate = result.end;
      });
    }
  }

  Map<String, double> _groupByCategory() {
    Map<String, double> data = {};
    for (var tx in _filteredTransactions) {
      if (!data.containsKey(tx['category'])) {
        data[tx['category']] = 0;
      }
      data[tx['category']] = data[tx['category']]! + tx['amount'];
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Général', 'Achat matériel', 'Paiement employés', 'Transport', 'Autres'];
    final groupedData = _groupByCategory();

    return Scaffold(
      appBar: AppBar(
        title: Text('Finance', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _exportToPdf,
            icon: Icon(Icons.picture_as_pdf, color: Colors.orange),
          ),
          IconButton(
            onPressed: _pickDateRange,
            icon: Icon(Icons.date_range, color: Colors.orange),
          ),
        ],
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
                "Gestion Financière",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              // Solde actuel
              Text(
                "Solde actuel : ${_calculateBalance().toStringAsFixed(2)} FCFA",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = _filteredTransactions[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          "${tx['type']} - ${tx['amount']} FCFA (${tx['category']})",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${DateFormat('dd/MM/yyyy').format(tx['date'])} - ${tx['description']}",
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editTransaction(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTransaction(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              // Répartition par catégorie
              Text(
                'Répartition par catégorie :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
              ),
              ...groupedData.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "${e.key} : ${e.value.toStringAsFixed(2)} FCFA",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Color.fromARGB(221, 78, 77, 77),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Montant',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: _selectedType,
                  items: ['Recette', 'Dépense']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedType = value!),
                ),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: categories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value!),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Ajouter', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}