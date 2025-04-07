import 'package:flutter/material.dart';
import '../models/equipment.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class LogisticsScreen extends StatefulWidget {
  @override
  _LogisticsScreenState createState() => _LogisticsScreenState();
}

class _LogisticsScreenState extends State<LogisticsScreen> {
  final List<Equipment> _equipments = [];
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _type = '';
  int _quantity = 0;
  String _event = '';
  String _searchQuery = '';

  void _addOrUpdateEquipment({Equipment? existingEquipment}) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        if (existingEquipment != null) {
          existingEquipment.name = _name;
          existingEquipment.type = _type;
          existingEquipment.quantity = _quantity;
          existingEquipment.event = _event;
        } else {
          _equipments.add(
            Equipment(
              name: _name,
              type: _type,
              quantity: _quantity,
              event: _event,
            ),
          );
        }
      });
      Navigator.pop(context);
    }
  }

  void _deleteEquipment(Equipment equipment) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Supprimer ${equipment.name}?'),
        content: Text('Voulez-vous vraiment supprimer cet équipement?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _equipments.remove(equipment);
              });
              Navigator.pop(context);
            },
            child: Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEquipmentForm({Equipment? equipment}) {
    if (equipment != null) {
      _name = equipment.name;
      _type = equipment.type;
      _quantity = equipment.quantity;
      _event = equipment.event;
    } else {
      _name = '';
      _type = '';
      _quantity = 0;
      _event = '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(equipment != null ? 'Modifier Équipement' : 'Ajouter un Équipement'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSaved: (value) => _name = value!,
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _type,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSaved: (value) => _type = value!,
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _quantity.toString(),
                  decoration: InputDecoration(
                    labelText: 'Quantité',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _quantity = int.parse(value!),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _event,
                  decoration: InputDecoration(
                    labelText: 'Événement',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSaved: (value) => _event = value!,
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler')),
          ElevatedButton(
            onPressed: () => _addOrUpdateEquipment(existingEquipment: equipment),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Valider', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _exportPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Rapport des équipements',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Nom', 'Type', 'Quantité', 'Événement'],
              data: _equipments.map((e) => [e.name, e.type, e.quantity.toString(), e.event]).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    List<Equipment> filteredEquipments = _equipments.where((e) =>
        e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        e.type.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        e.event.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestion des équipements',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(221, 78, 77, 77),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _exportPdf,
            icon: Icon(Icons.picture_as_pdf, color: Colors.orange),
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
                "Liste des équipements",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              // Champ de recherche
              TextField(
                decoration: InputDecoration(
                  labelText: 'Rechercher par nom/type/événement',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEquipments.length,
                  itemBuilder: (context, index) {
                    final equipment = filteredEquipments[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          '${equipment.name} (${equipment.type})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Quantité: ${equipment.quantity} | Événement: ${equipment.event}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEquipmentForm(equipment: equipment),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteEquipment(equipment),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEquipmentForm(),
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}