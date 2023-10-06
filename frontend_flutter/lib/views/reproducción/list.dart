import 'package:flutter/material.dart';

class Farm {
  final String name;
  final String location;
  final int size;

  Farm(this.name, this.location, this.size);
}

class ReproduccionTable extends StatelessWidget {
  final List<Farm> farms = [
    Farm('Finca A', 'Ubicación A', 100),
    Farm('Finca B', 'Ubicación B', 150),
    Farm('Finca C', 'Ubicación C', 200),
    Farm('Finca D', 'Ubicación D', 120),
    Farm('Finca E', 'Ubicación E', 180),
  ];

  ReproduccionTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text('Nombre'),
          ),
          DataColumn(
            label: Text('Ubicación'),
          ),
          DataColumn(
            label: Text('Tamaño (acres)'),
          ),
        ],
        rows: farms
            .map(
              (farm) => DataRow(
                cells: [
                  DataCell(Text(farm.name)),
                  DataCell(Text(farm.location)),
                  DataCell(Text(farm.size.toString())),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
