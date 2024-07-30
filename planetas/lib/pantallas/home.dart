import 'package:flutter/material.dart';
import '../database/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final db = BaseDatos.instance;
  List<Map<String, dynamic>> planetas = [];
  TextEditingController nombrep = TextEditingController();
  TextEditingController colorp = TextEditingController();
  int? _editId;

  void cargarPlanetas() async {
    final data = await db.queryAll();
    setState(() {
      planetas = data;
    });
  }

  void agregarPlaneta() async {
    await db.create({
      'name': nombrep.text,
      'description': colorp.text,
    });
    cargarPlanetas();
  }

  void actualizarPlaneta() async {
    if (_editId != null) {
      await db.update({
        'id': _editId!,
        'name': nombrep.text,
        'description': colorp.text,
      });
      setState(() {
        _editId = null;
      });
      cargarPlanetas();
    }
  }

  void borrarPlaneta(int id) async {
    await db.delete(id);
    cargarPlanetas();
  }

  @override
  void initState() {
    super.initState();
    cargarPlanetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planetas'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombrep,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.star_border_purple500_sharp),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: colorp,
              decoration: InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.color_lens),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: agregarPlaneta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text('Crear'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: actualizarPlaneta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text('Editar'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: planetas.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(planetas[index]['name']),
                      subtitle: Text(planetas[index]['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              setState(() {
                                nombrep.text = planetas[index]['name'];
                                colorp.text = planetas[index]['description'];
                                _editId = planetas[index]['id'];
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => borrarPlaneta(planetas[index]['id']),
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
    );
  }
}
