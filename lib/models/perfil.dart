
class Perfil {
  final int id;         
  final String nombre;
  final String apellido;
  final String matricula;
  final String? fotoPath;
  final String frase;

  Perfil({
    this.id = 1,
    required this.nombre,
    required this.apellido,
    required this.matricula,
    this.fotoPath,
    required this.frase,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'apellido': apellido,
        'matricula': matricula,
        'foto_path': fotoPath,
        'frase': frase,
      };

  factory Perfil.fromMap(Map<String, dynamic> m) => Perfil(
        id: m['id'],
        nombre: m['nombre'],
        apellido: m['apellido'],
        matricula: m['matricula'],
        fotoPath: m['foto_path'],
        frase: m['frase'],
      );
}