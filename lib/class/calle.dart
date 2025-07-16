import 'package:lionxcode_finalproject/class/juego.dart';

class Calle extends Juego{
  final Map<String,bool> respuestas;

  Calle({required super.materia, required super.pregunta,required this.respuestas});
}