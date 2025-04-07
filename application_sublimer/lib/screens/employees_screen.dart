import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Employee {
  String name;
  List<Map<String, dynamic>> attendance;

  Employee({required this.name, required this.attendance});

  double get totalSalary => attendance.fold(0.0, (sum, day) => sum + (day['salary'] as double));

  int get daysWorked => attendance.length;
}

class EmployeesScreen extends StatefulWidget {
  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  List<Employee> employees = [];

  void _addEmployee() {
    String name = "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Ajouter un employé'),
        content: TextField(
          decoration: InputDecoration(
            labelText: 'Nom',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => name = value,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (name.isNotEmpty) {
                setState(() {
                  employees.add(Employee(name: name, attendance: []));
                });
                Navigator.pop(context);
              }
            },
            child: Text('Ajouter', style: TextStyle(color: Colors.green)),
          )
        ],
      ),
    );
  }

  void _modifyEmployee(Employee employee) {
    double dailySalary = 0.0;
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Ajouter une rémunération pour ${employee.name}'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Rémunération du jour',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => dailySalary = double.tryParse(value) ?? 0.0,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (dailySalary > 0) {
                setState(() {
                  employee.attendance.add({
                    'date': date,
                    'salary': dailySalary,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: Text('Ajouter', style: TextStyle(color: Colors.orange)),
          )
        ],
      ),
    );
  }

  void _deleteEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Supprimer ${employee.name}?'),
        content: Text('Voulez-vous vraiment supprimer cet employé?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                employees.remove(employee);
              });
              Navigator.pop(context);
            },
            child: Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _exportToPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(child: pw.Text('Rapport des employés', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 20),
          ...employees.map(
            (e) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('${e.name}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                pw.Text('Jours travaillés: ${e.daysWorked}'),
                pw.Text('Salaire total: ${e.totalSalary.toStringAsFixed(2)} F'),
                pw.Text('Détails:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Column(
                  children: e.attendance
                      .map(
                        (a) => pw.Text('${a['date']} - ${a['salary']} F'),
                      )
                      .toList(),
                ),
                pw.Divider(),
              ],
            ),
          )
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des employés', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(221, 78, 77, 77),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: Colors.orange),
            onPressed: _exportToPDF,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: employees.isEmpty
          ? Center(
              child: Text(
                'Aucun employé enregistré.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Liste des employés et leur salaire',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (_, index) {
                      final emp = employees[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(emp.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Jours travaillés: ${emp.daysWorked}'),
                              Text('Salaire total: ${emp.totalSalary.toStringAsFixed(2)} F'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _modifyEmployee(emp),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteEmployee(emp),
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
    );
  }
}