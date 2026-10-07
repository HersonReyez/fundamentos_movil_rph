import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Registro de Preferencias'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _selectedCountry = 'MX';
  bool _isChecked = false;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  String _selectedRadio = 'Masculino';
  bool _isSwitchOn = false;
  double _sliderValue = 50;
  int _counter = 0;

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Cerrar',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seccion 1 //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue, size: 30),
                              SizedBox(width: 12),
                              Text(
                                'Seccion 1: Informacion General',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Completa los siguientes datos personales basicos',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Seccion 2 //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.green, size: 30),
                              SizedBox(width: 12),
                              Text(
                                'Seccion 2: Datos personales',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 12),

                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Nombre completo',
                              hintText: 'Escribe tu nombre',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 12),

                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Edad',
                              hintText: 'Escribe tu edad',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Seccion 3 //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.orange, size: 30),
                              SizedBox(width: 12),
                              Text(
                                'Seccion 3: Distribucion en Filas',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 12),

                          // Fila 1
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.favorite, color: Colors.red),

                                SizedBox(width: 10),

                                Text(
                                  'Fila 1 - Color Rojo',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),

                          // Fila 2
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.favorite, color: Colors.yellow),

                                SizedBox(width: 10),

                                Text(
                                  'Fila 2 - Color Amarillo',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),

                          // Fila 3
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.favorite, color: Colors.blue),

                                SizedBox(width: 10),

                                Text(
                                  'Fila 3 - Color Azul',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Seccion 4 //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.purple, size: 30),
                              SizedBox(width: 12),
                              Text(
                                'Seccion 4: Cuatro Hijos en Colores',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 12),

                          Row(
                            children: [
                              // Hijo 1
                              Container(
                                width: 70.0,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Hijo 1',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),

                              // Hijo 2
                              Container(
                                width: 70.0,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.yellow.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Hijo 2',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),

                              // Hijo 3
                              Container(
                                width: 70.0,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Hijo 3',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),

                              // Hijo 4
                              Container(
                                width: 70.0,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Hijo 4',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Seccion 5 //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.grey, size: 30),
                              SizedBox(width: 12),
                              Text(
                                'Seccion 5: Controles UI',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 12),

                          Text('Genero', style: TextStyle(fontSize: 16)),

                          Radio<String>(
                            value: 'Masculino',
                            groupValue: _selectedRadio,
                            onChanged: (value) {
                              setState(() {
                                _selectedRadio = value!;
                              });
                              _showSnackBar(
                                context,
                                'Opcion seleccionada: $value',
                              );
                            },
                          ),
                          Text(
                            'Masculino ${_selectedRadio == "Masculino" ? "Seleccionada" : ""}',
                            style: TextStyle(
                              fontWeight: _selectedRadio == "Masculino"
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _selectedRadio == "Masculino"
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 20),

                          Radio<String>(
                            value: 'Femenino',
                            groupValue: _selectedRadio,
                            onChanged: (value) {
                              setState(() {
                                _selectedRadio = value!;
                              });
                              _showSnackBar(
                                context,
                                'Opcion seleccionada: $value',
                              );
                            },
                          ),
                          Text(
                            'Femenino ${_selectedRadio == "Femenino" ? "Seleccionada" : ""}',
                            style: TextStyle(
                              fontWeight: _selectedRadio == "Femenino"
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _selectedRadio == "Femenino"
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 20),

                          Radio<String>(
                            value: 'Otro',
                            groupValue: _selectedRadio,
                            onChanged: (value) {
                              setState(() {
                                _selectedRadio = value!;
                              });
                              _showSnackBar(
                                context,
                                'Opcion seleccionada: $value',
                              );
                            },
                          ),
                          Text(
                            'Otro ${_selectedRadio == "Otro" ? "Seleccionada" : ""}',
                            style: TextStyle(
                              fontWeight: _selectedRadio == "Otro"
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _selectedRadio == "Otro"
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 20),

                          Text('Intereses', style: TextStyle(fontSize: 16)),

                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked1,
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked1 = value ?? false;
                                  });
                                  _showSnackBar(
                                    context,
                                    'Checkbox: ${_isChecked1 ? "Activado" : "Desactivado"}',
                                  );
                                },
                              ),
                              Text(
                                _isChecked1 ? 'Deporte' : 'Deporte',
                                style: TextStyle(
                                  color: _isChecked1
                                      ? Colors.green
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked2,
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked2 = value ?? false;
                                  });
                                  _showSnackBar(
                                    context,
                                    'Checkbox: ${_isChecked2 ? "Activado" : "Desactivado"}',
                                  );
                                },
                              ),
                              Text(
                                _isChecked2 ? 'Musica' : 'Musica',
                                style: TextStyle(
                                  color: _isChecked2
                                      ? Colors.green
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked3,
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked3 = value ?? false;
                                  });
                                  _showSnackBar(
                                    context,
                                    'Checkbox: ${_isChecked3 ? "Activado" : "Desactivado"}',
                                  );
                                },
                              ),
                              Text(
                                _isChecked3 ? 'Cine' : 'Cine',
                                style: TextStyle(
                                  color: _isChecked3
                                      ? Colors.green
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked4,
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked4 = value ?? false;
                                  });
                                  _showSnackBar(
                                    context,
                                    'Checkbox: ${_isChecked4 ? "Activado" : "Desactivado"}',
                                  );
                                },
                              ),
                              Text(
                                _isChecked4 ? 'Lectura' : 'Lectura',
                                style: TextStyle(
                                  color: _isChecked4
                                      ? Colors.green
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Text('Pais', style: TextStyle(fontSize: 16)),

                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Selecciona tu pais',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedCountry,
                            items: const [
                              DropdownMenuItem(
                                value: 'MX',
                                child: Text('Mexico'),
                              ),
                              DropdownMenuItem(
                                value: 'US',
                                child: Text('Estados Unidos'),
                              ),
                              DropdownMenuItem(
                                value: 'ES',
                                child: Text('Espana'),
                              ),
                              DropdownMenuItem(
                                value: 'AR',
                                child: Text('Argentina'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedCountry = value;
                              });
                              _showSnackBar(
                                context,
                                'Pais seleccionado: $value',
                              );
                            },
                          ),

                          if (_selectedCountry != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Pais seleccionado: $_selectedCountry',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          Row(
                            children: [
                              // Hijo 1
                              Container(
                                width: 160.0,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Mostrar Preferencias',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),

                              // Hijo 2
                              Container(
                                width: 160.0,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Guardar Registro',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
