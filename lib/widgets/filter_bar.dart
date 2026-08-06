import 'package:flutter/material.dart';

const categoriasCielo = [
  'Fenómeno atmosférico',
  'Astronomía',
  'Aves',
  'Aeronave/Objeto artificial',
];

class FilterBar extends StatelessWidget {
  final String? categoriaSeleccionada;
  final ValueChanged<String?> onCategoriaChanged;
  final VoidCallback onFiltrarFecha;
  final ValueChanged<String> onBuscarLugar;

  const FilterBar({
    super.key,
    required this.categoriaSeleccionada,
    required this.onCategoriaChanged,
    required this.onFiltrarFecha,
    required this.onBuscarLugar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: categoriaSeleccionada,
              hint: const Text('Categoría'),
              isExpanded: true,
              items: [
                const DropdownMenuItem(value: null, child: Text('Todas')),
                ...categoriasCielo.map((c) => DropdownMenuItem(value: c, child: Text(c))),
              ],
              onChanged: onCategoriaChanged,
              decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Filtrar por fecha',
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: onFiltrarFecha,
          ),
          IconButton(
            tooltip: 'Buscar por lugar',
            icon: const Icon(Icons.place_outlined),
            onPressed: () async {
              final texto = await showDialog<String>(
                context: context,
                builder: (context) {
                  final controller = TextEditingController();
                  return AlertDialog(
                    title: const Text('Buscar por lugar'),
                    content: TextField(controller: controller, autofocus: true),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                      TextButton(
                        onPressed: () => Navigator.pop(context, controller.text),
                        child: const Text('Buscar'),
                      ),
                    ],
                  );
                },
              );
              if (texto != null && texto.trim().isNotEmpty) onBuscarLugar(texto.trim());
            },
          ),
        ],
      ),
    );
  }
}