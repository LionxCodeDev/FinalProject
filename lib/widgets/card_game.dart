import 'package:flutter/material.dart';
import 'package:lionxcode_finalproject/providers/menu_provider.dart';
import 'package:provider/provider.dart';

class CardGame extends StatelessWidget {
  final String titulo;
  final String descripcion;
  const CardGame({super.key,required this.titulo,required this.descripcion});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20,right: 20),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xff0f1424),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titulo,style: Theme.of(context).textTheme.labelLarge),
            const Divider(color: Colors.white,indent: 20.0,endIndent: 20.0),
            SingleChildScrollView(child: Text(descripcion,style: Theme.of(context).textTheme.labelMedium)),
            _buttonPlay(context)
          ],
      ),
    );
  }

  Widget _buttonPlay(BuildContext context){
    final menuProvider = Provider.of<MenuProvider>(context);
    return SizedBox(width: double.infinity,child: ElevatedButton(onPressed: ()=> menuProvider.changeJuego(titulo) , child: const Text("JUGAR")));
  }
}