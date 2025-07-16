import 'package:flutter/material.dart';
import 'package:lionxcode_finalproject/class/ahorcado.dart';
import 'package:lionxcode_finalproject/class/calle.dart';
import 'package:lionxcode_finalproject/firebase/firestore.dart';
import 'package:lionxcode_finalproject/providers/menu_provider.dart';
import 'package:lionxcode_finalproject/services/shared_preferences.dart';
import 'package:lionxcode_finalproject/views/loading_view.dart';
import 'package:lionxcode_finalproject/widgets/card_game.dart';
import 'package:lionxcode_finalproject/widgets/card_materia.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class JuegosPage extends StatelessWidget {
  
  JuegosPage({super.key});

  final prefs = PreferenciasUsuario();
  
  final List<String> descripciones = [
    "¡Bienvenido al Ahorcado!\nElige una materia y adivina el concepto oculto con una sola palabra.\nCada error acerca a nuestro amigo al peligro… ¡sálvalo usando tu ingenio!\n¿Listo para el reto?",
    "¡Tres en calle con truco!\n¿Crees que es solo marcar casillas? ¡Piénsalo otra vez!\nElige tu cuadro, responde bien… y gana el derecho a llenar tu cuadro.\n¡Aquí gana quien juega y también piensa!"
  ];

  final List<String> materias = [
    "Algebra lineal",
    "Comunicación efectiva",
    "Cálculo de una variable",
    "Metodología de la investigación",
    "Programación 1"
  ];

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    
    return menuProvider.getmateria() == "none" ? Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
      menuProvider.getjuego() == "none" ? 
      [
        CardGame(titulo: "Ahorcado", descripcion: descripciones[0]),
        CardGame(titulo: "Tres en calle", descripcion: descripciones[1])
      ] 
      : materias.map((materia) => CardMateria(materia: materia)).toList() 
   
    ) 
    : menuProvider.getjuego() == "Ahorcado" ? 
      StreamProvider<List<Ahorcado>>.value(
        initialData: const [],
        value: Firestore(collection:  menuProvider.getjuego(),materia: menuProvider.getmateria()).ahorcado,
        child: LoadinView(juego: menuProvider.getjuego())) 
    : StreamProvider<List<Calle>>.value(
        initialData: const [],
        value: Firestore(collection:  "Calle",materia: menuProvider.getmateria()).calle,
        child: LoadinView(juego: menuProvider.getjuego()));
  }  
}