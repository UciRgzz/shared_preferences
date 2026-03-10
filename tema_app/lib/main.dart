import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variable que guarda si el modo oscuro está activado
  bool _modoOscuro = false;

  @override
  void initState() {
    super.initState();
    // Al iniciar la app, leemos el valor guardado
    _cargarTema();
  }

  // Lee el tema guardado en shared_preferences
  Future<void> _cargarTema() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _modoOscuro = prefs.getBool('modo_oscuro') ?? false;
    });
  }

  // Guarda el tema en shared_preferences
  Future<void> _guardarTema(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modo_oscuro', valor);
    setState(() {
      _modoOscuro = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tema App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _modoOscuro ? ThemeMode.dark : ThemeMode.light,
      home: PantallaInicio(
        modoOscuro: _modoOscuro,
        alCambiarTema: _guardarTema,
      ),
    );
  }
}

class PantallaInicio extends StatelessWidget {
  final bool modoOscuro;
  final ValueChanged<bool> alCambiarTema;

  const PantallaInicio({
    super.key,
    required this.modoOscuro,
    required this.alCambiarTema,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferencias de Tema'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono según el tema actual
            Icon(
              modoOscuro ? Icons.dark_mode : Icons.light_mode,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              modoOscuro ? 'Modo Oscuro' : 'Modo Claro',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            // Switch para cambiar el tema
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.light_mode),
                Switch(
                  value: modoOscuro,
                  onChanged: alCambiarTema,
                ),
                const Icon(Icons.dark_mode),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Tu preferencia se guarda\naun si cierras la app',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
