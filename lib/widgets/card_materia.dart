import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lionxcode_finalproject/providers/menu_provider.dart';
import 'package:provider/provider.dart';

class CardMateria extends StatelessWidget {
  final String materia;
  const CardMateria({super.key,required this.materia});

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);  
    return GestureDetector(
      onTap: () => menuProvider.changeMateria(materia),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color(0xff0f1424)
        ),
        child: Text(materia,style: GoogleFonts.bangers(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
        color: Colors.white//Color(0xFFCC9932)
        ))),
    );
  }
}