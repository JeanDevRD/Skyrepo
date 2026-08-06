import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/observacion.dart';
import '../services/database_service.dart';
import '../widgets/filter_bar.dart';
import '../widgets/observation_card.dart';
import 'new_observation_screen.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _categoria;
  String? _lugarTexto;
  DateTime? _fechaDesde;
  DateTime? _fechaHasta;
  late Future<List<Observacion>> _futuro;

  @override
  void initState() {
    super.initState();
    _recargar();
  }

  void _recargar() {
    _futuro = context.read<DatabaseService>().getObservaciones(
          categoria: _categoria,
          lugarTexto: _lugarTexto,
          fechaDesde: _fechaDesde?.toIso8601String(),
          fechaHasta: _fechaHasta?.toIso8601String(),
        );
  }

  Future<void> _elegirFecha() async {
    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (rango != null) {
      setState(() {
        _fechaDesde = rango.start;
        _fechaHasta = rango.end;
        _recargar();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observaciones del cielo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
              setState(_recargar); // por si se usó "Borrar todo"
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FilterBar(
            categoriaSeleccionada: _categoria,
            onCategoriaChanged: (c) => setState(() {
              _categoria = c;
              _recargar();
            }),
            onFiltrarFecha: _elegirFecha,
            onBuscarLugar: (texto) => setState(() {
              _lugarTexto = texto;
              _recargar();
            }),
          ),
          Expanded(
            child: FutureBuilder<List<Observacion>>(
              future: _futuro,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final lista = snapshot.data ?? [];
                if (lista.isEmpty) {
                  return const Center(child: Text('Aún no hay observaciones registradas'));
                }
                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, i) => ObservationCard(
                    observacion: lista[i],
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailScreen(observacion: lista[i])),
                      );
                      setState(_recargar);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewObservationScreen()),
          );
          setState(_recargar);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}