import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de Viaje',
      debugShowCheckedModeBanner: false,
      // Se ajusta el color base a teal (verde azulado) para coincidir con las capturas
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
      home: const MyHomePage(title: 'Reserva de Viaje'),
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
  // VARIABLES //
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  String? _selectedTransport = 'Avión';
  String? _selectedDestination;
  
  bool _isCheckedHotel = false;
  bool _isCheckedTour = false;
  bool _isCheckedSeguro = false;
  bool _isSwitchOn = false;
  
  double _sliderValue = 3000;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // FUNCIONES //
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Cerrar',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _selectedTransport = 'Avión';
      _selectedDestination = null;
      _isCheckedHotel = false;
      _isCheckedTour = false;
      _isCheckedSeguro = false;
      _isSwitchOn = false;
      _sliderValue = 3000;
      _selectedDate = null;
    });
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Faltan datos'),
          ],
        ),
        content: const Text('Completa nombre, correo válido (@) y selecciona la fecha del viaje.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  void _showSummaryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        List<String> extras = [];
        if (_isCheckedHotel) extras.add('Hotel');
        if (_isCheckedTour) extras.add('Tour');
        if (_isCheckedSeguro) extras.add('Seguro');

        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.teal),
              SizedBox(width: 8),
              Text('Resumen del Viaje', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSummaryText(Icons.person, 'Nombre', _nameController.text.isNotEmpty ? _nameController.text : 'N/A'),
                const SizedBox(height: 8),
                _buildSummaryText(Icons.email, 'Correo', _emailController.text.isNotEmpty ? _emailController.text : 'N/A'),
                const SizedBox(height: 8),
                _buildSummaryText(Icons.location_on, 'Destino', _selectedDestination ?? 'No seleccionado'),
                const SizedBox(height: 8),
                _buildSummaryText(Icons.directions_bus, 'Transporte', _selectedTransport ?? 'N/A'),
                const SizedBox(height: 8),
                _buildSummaryText(Icons.star, 'Extras', extras.isNotEmpty ? extras.join(', ') : 'Ninguno'),
                const SizedBox(height: 8),
                _buildSummaryText(Icons.notifications, 'Notificaciones', _isSwitchOn ? 'Activadas' : 'Desactivadas'),
                const SizedBox(height: 8),
                _buildSummaryText(Icons.attach_money, 'Presupuesto', '\$${_sliderValue.round()}'),
                const SizedBox(height: 8),
                _buildSummaryText(Icons.calendar_today, 'Fecha', _selectedDate != null 
                  ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}' 
                  : 'No seleccionada'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                _confirmarViaje(); // Llama a confirmar directamente
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryText(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text.rich(TextSpan(children: [
          TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ]))),
      ],
    );
  }

  void _confirmarViaje() {
    if (_nameController.text.isEmpty || 
        !_emailController.text.contains('@') || 
        _selectedDate == null) {
      _showErrorDialog();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BoletoScreen(
            nombre: _nameController.text,
            correo: _emailController.text,
            destino: _selectedDestination ?? 'No seleccionado',
            transporte: _selectedTransport ?? 'Avión',
            presupuesto: _sliderValue,
            fecha: _selectedDate!,
            hotel: _isCheckedHotel,
            notificaciones: _isSwitchOn,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: _clearAll,
            tooltip: 'Limpiar',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECCION 1 //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.teal, size: 30),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sección 1 • Información general',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                          ),
                          Text('Completa tu reserva paso a paso', style: TextStyle(color: Colors.grey)),
                          Divider(),
                          Text('Llena tus datos, elige destino y confirma tu viaje.', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SECCION 2 //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.person_outline, color: Colors.teal, size: 30),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sección 2 • Datos del viajero',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                            ),
                            Text('¿Quién se va de viaje?', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre completo',
                        hintText: 'Ej: Ana Garcia',
                        prefixIcon: const Icon(Icons.person, color: Colors.teal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        hintText: 'Ej: ana@correo.com',
                        prefixIcon: const Icon(Icons.email, color: Colors.teal),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SECCION 3 //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.orange, size: 30),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sección 3 • Destino y transporte',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange),
                            ),
                            Text('Elige tu aventura', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildDestinationCard('Playa', Icons.beach_access, Colors.blue),
                        const SizedBox(width: 8),
                        _buildDestinationCard('Ciudad', Icons.location_city, Colors.orange),
                        const SizedBox(width: 8),
                        _buildDestinationCard('Montaña', Icons.landscape, Colors.green),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Transporte:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: _selectedTransport,
                      items: const [
                        DropdownMenuItem(value: 'Avión', child: Row(children: [Icon(Icons.flight, color: Colors.orange), SizedBox(width:8), Text('Avión')])),
                        DropdownMenuItem(value: 'Autobús', child: Row(children: [Icon(Icons.directions_bus, color: Colors.orange), SizedBox(width:8), Text('Autobús')])),
                        DropdownMenuItem(value: 'Tren', child: Row(children: [Icon(Icons.train, color: Colors.orange), SizedBox(width:8), Text('Tren')])),
                        DropdownMenuItem(value: 'Barco', child: Row(children: [Icon(Icons.directions_boat, color: Colors.orange), SizedBox(width:8), Text('Barco')])),
                      ],
                      onChanged: (value) {
                        setState(() { _selectedTransport = value; });
                        _showSnackBar(context, 'Transporte seleccionado: $value');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SECCION 4 //
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tune, color: Colors.purple, size: 30),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sección 4 • Extras y preferencias',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple),
                            ),
                            Text('Personaliza tu experiencia', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // CheckboxListTiles
                    _buildCheckboxListTile(
                      'Hotel incluido', '+\$1200', Icons.hotel, _isCheckedHotel,
                      (val) {
                        setState(() => _isCheckedHotel = val!);
                        _showSnackBar(context, 'Hotel: ${val! ? "Agregado" : "Removido"}');
                      }
                    ),
                    const SizedBox(height: 8),
                    _buildCheckboxListTile(
                      'Tour guiado', '+\$600', Icons.tour, _isCheckedTour,
                      (val) {
                        setState(() => _isCheckedTour = val!);
                        _showSnackBar(context, 'Tour: ${val! ? "Agregado" : "Removido"}');
                      }
                    ),
                    const SizedBox(height: 8),
                    _buildCheckboxListTile(
                      'Seguro de viaje', '+\$400', Icons.health_and_safety, _isCheckedSeguro,
                      (val) {
                        setState(() => _isCheckedSeguro = val!);
                        _showSnackBar(context, 'Seguro: ${val! ? "Agregado" : "Removido"}');
                      }
                    ),
                    const SizedBox(height: 16),

                    // SwitchListTile
                    Container(
                      decoration: BoxDecoration(
                        color: _isSwitchOn ? Colors.purple.shade100 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SwitchListTile(
                        title: const Text('Recibir notificaciones', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(_isSwitchOn ? 'Activadas' : 'Desactivadas', style: TextStyle(color: _isSwitchOn ? Colors.green : Colors.grey)),
                        value: _isSwitchOn,
                        activeColor: Colors.purple,
                        onChanged: (value) {
                          setState(() => _isSwitchOn = value);
                          _showSnackBar(context, 'Notificaciones: ${value ? "Activadas" : "Desactivadas"}');
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Presupuesto Slider
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Presupuesto:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(16)),
                                child: Text('\$${_sliderValue.round()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          Slider(
                            value: _sliderValue,
                            min: 500,
                            max: 10000,
                            divisions: 20,
                            activeColor: Colors.purple,
                            label: '\$${_sliderValue.round()}',
                            onChanged: (value) => setState(() => _sliderValue = value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Selector de Fecha
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (pickedDate != null) {
                          setState(() => _selectedDate = pickedDate);
                          _showSnackBar(context, 'Fecha seleccionada');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.calendar_month, color: Colors.purple, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Fecha del viaje', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedDate == null
                                        ? 'Toca para elegir fecha'
                                        : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SECCION 5 //
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal.shade800,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
                        SizedBox(width: 12),
                        Text('Sección 5 • Confirmar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Revisa tus datos antes de despegar', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.teal.shade900,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.visibility),
                            label: const Text('Ver Resumen'),
                            onPressed: _showSummaryDialog,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.flight_takeoff),
                            label: const Text('Confirmar'),
                            onPressed: _confirmarViaje,
                          ),
                        ),
                      ],
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

  // Widget de ayuda para construir tarjetas de destino seleccionables
  Expanded _buildDestinationCard(String title, IconData icon, Color color) {
    bool isSelected = _selectedDestination == title;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() => _selectedDestination = title);
          _showSnackBar(context, 'Destino seleccionado: $title');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: isSelected ? 2 : 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget de ayuda para construir CheckboxListTile con su contenedor
  Widget _buildCheckboxListTile(String title, String subtitle, IconData icon, bool value, ValueChanged<bool?> onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: value ? Colors.purple.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: CheckboxListTile(
        secondary: Icon(icon, color: Colors.grey.shade700),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        value: value,
        activeColor: Colors.purple,
        onChanged: onChanged,
      ),
    );
  }
}

// PANTALLA 2 - MI BOLETO
class BoletoScreen extends StatelessWidget {
  final String nombre;
  final String correo;
  final String destino;
  final String transporte;
  final double presupuesto;
  final DateTime fecha;
  final bool hotel;
  final bool notificaciones;

  const BoletoScreen({
    super.key,
    required this.nombre,
    required this.correo,
    required this.destino,
    required this.transporte,
    required this.presupuesto,
    required this.fecha,
    required this.hotel,
    required this.notificaciones,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Boleto'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabecera Verde
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(16)),
                      child: Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white30,
                    child: Icon(Icons.airplane_ticket, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text('¡Buen viaje, ${nombre.split(' ').first}!', 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(destino.toUpperCase(), 
                      style: const TextStyle(fontSize: 16, letterSpacing: 2, color: Colors.white70)),
                ],
              ),
            ),
            
            // Tarjeta de detalles
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                  ]
                ),
                child: Column(
                  children: [
                    // Imagen placeholder de destino
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500&q=80',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildInfoRow(Icons.email, 'Correo', correo, color: Colors.teal),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildInfoRow(Icons.location_on, 'Destino', destino, color: Colors.orange)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(border: Border.all(color: Colors.orange.shade200), borderRadius: BorderRadius.circular(8)),
                          child: Text(transporte, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                        )
                      ],
                    ),
                    const Divider(height: 30),
                    _buildInfoRow(Icons.star, 'Extras', hotel ? 'Hotel' : 'Ninguno', color: Colors.purple),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildInfoRow(Icons.notifications, 'Notificaciones', notificaciones ? 'Activadas' : 'Desactivadas', color: Colors.blue)),
                        Text('\$${presupuesto.round()}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Botón de regresar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Regresar y editar', style: TextStyle(fontSize: 16)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle, {required Color color}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
