import 'package:card_swiper/card_swiper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lionxcode_finalproject/class/desempeno.dart';
import 'package:lionxcode_finalproject/class/promedio.dart';
import 'package:lionxcode_finalproject/class/usuarios.dart';
import 'package:lionxcode_finalproject/firebase/auth.dart';
import 'package:lionxcode_finalproject/services/shared_preferences.dart';
import 'package:provider/provider.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  
  final preferencias = PreferenciasUsuario();
  final auth = AuthFirebase();
  late List<Usuarios> usuarios;
  int posSwiper = 0;
  final List<String> _tareas = [
    "Mi Desempeño",
    "Promedio Todos Los Jugadores",
    "Desempeño por materia",
    "Barras Comparativas De Intentos"
  ];

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    usuarios = Provider.of<List<Usuarios>>(context); 
    return ListView(
      children: [
        _portada(size.height * 0.25),
        Text(" ${_tareas[posSwiper]}"),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          height: size.height * 0.84,
          margin: const EdgeInsets.all(5.0),
          width: double.infinity,
          child: usuarios.isEmpty ? const CircularProgressIndicator() 
            : _crearSwiperCard()
        )
      ]
    );
  }

  Widget _portada(double altura){
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      height: altura,
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset("assets/foco.png",fit: BoxFit.fill,width: double.infinity),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(preferencias.getName),
            Text(preferencias.getEmail),
            ElevatedButton(onPressed: () async {
              await auth.logOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacementNamed("home");
            }, child: const Text("Cerrar Sesión"))
          ])
        ],
      ),
    );
  }

  Widget _crearSwiperCard(){
    return Swiper(
      itemCount: _tareas.length,
      itemBuilder: (_,i){
        return _listaWidget(i);
      },
      onIndexChanged: (int j){
        setState(() {
          posSwiper = j;
        });
      },
      pagination: const SwiperPagination(
        alignment: Alignment.topLeft,
        builder: DotSwiperPaginationBuilder(
          activeColor: Color(0xFFCC9932),
          color: Color(0xff0f1424),

        )
      ),
    );
  }

  Widget _listaWidget(int pos){
    switch (pos) {
      case 0:
        final miUsuario = usuarios.firstWhere(
          (user) => user.uid == preferencias.getUid
        );
        return _crearBarras(miUsuario);
      case 1:
        List<Promedio> listaPronedios = _promedios();
        return Column(
          children: listaPronedios.map((prm)=> _crearBarraPromedio(prm)).toList()
        ); 
      case 2:
        return _crearPastel();

      case 3:
        final miUsuario = usuarios.firstWhere(
          (user) => user.uid == preferencias.getUid
        );
        return _mostrarGraficoIntentos(miUsuario);

      default:
        return const Text("fue Default");
    }
  }

  Widget leyenda(List<Promedio> listaPromedios) {
  List<Color> colores = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(listaPromedios.length, (index) {
      final color = colores[index % colores.length];
      final materia = listaPromedios[index].nombre;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(width: 20, height: 20, color: color),
            const SizedBox(width: 8),
            Text(materia, style: const TextStyle(fontSize: 14)),
          ],
        ),
      );
    }),
  );
}

  Widget _crearPastel(){
    final listaPromedios = _promedioMateria();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: generarSeccionesPastel(listaPromedios),
              centerSpaceRadius: size.width * 0.25,
              sectionsSpace: 2,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 100),
        leyenda(listaPromedios),
      ],
    );
  }

  Widget _crearBarras( Usuarios user){
    
  final intentos = user.intentos;
  final puntos = user.puntos;

  final List<DesempenoMateria> datosGraficar = intentos.entries.map((entry) {
    final materia = entry.key;
    final intento = entry.value;
    final punto = puntos[materia] ?? 0;
    return DesempenoMateria(materia: materia, intentos: intento, puntos: punto);
  }).toList();

   return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta){
                  final iniciales = obtenerIniciales(datosGraficar[value.toInt()].materia);
                  return Text(iniciales);
              },
            )
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value,meta){
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 8),  // tamaño más pequeño
                );
              }
              )),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)
          ),
        ),
        
        barGroups: datosGraficar.asMap().entries.map((valor){
          final index = valor.key;
          final data = valor.value;
          return BarChartGroupData(
            x:index,
            barRods: [
              BarChartRodData(
                toY: data.puntos.toDouble(),
                color: const Color(0xFFCC9932),
                width: 16,
                borderRadius: BorderRadius.circular(4),
            ),
          ],
          );
        }).toList()
      ),
    );
  }

  Widget _crearBarraPromedio(Promedio prm){
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: const RadialGradient(
          center: Alignment.centerLeft,
          radius: 12,
          colors: [
          Color(0xFFCC9932),
          Colors.white
          ]
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(prm.nombre),
          Text(prm.promedio.toString())
        ],
      ),
    );
  }

  String obtenerIniciales(String frase) {
    List<String> palabras = frase.split(' ');
    String iniciales = palabras
      .where((palabra) => palabra.isNotEmpty) // evitar palabras vacías
      .map((palabra) => palabra[0].toUpperCase()) // tomar la inicial en mayúscula
      .join();
    return iniciales;
  }

  List<Promedio> _promedios(){
    
    List<Promedio> promedios = [];
    
    for(int i = 0; i < usuarios.length; i++){
      
      Usuarios usr = usuarios[i];
      int suma = 0;

      usr.puntos.forEach((clave,valor){
        suma = suma + valor;
      });

      double prm = suma/5;

      promedios.add(Promedio(promedio: prm, nombre: usr.nombre));
    }

    promedios.sort((a, b) => b.promedio.compareTo(a.promedio));

    return promedios;
  }

  List<Promedio> _promedioMateria(){
    
    List<Promedio> promMateria = [];
    Map<String,int> sumaMateria = {};

    for(Usuarios usr in usuarios){
      usr.puntos.forEach((materia,puntos){
        if(sumaMateria.containsKey(materia)){
          sumaMateria[materia] = sumaMateria[materia]! + puntos;
        }
        else{
          sumaMateria[materia] = puntos;
        }
        
      });
    }

    sumaMateria.forEach((materia,suma){
      promMateria.add(Promedio(promedio: suma.toDouble(), nombre: materia));
    });

    return promMateria;

  }

  List<PieChartSectionData> generarSeccionesPastel(List<Promedio> listaPromedios) {
  double total = listaPromedios.fold(0, (sum, item) => sum + item.promedio);
  List<Color> colores = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
  ];

  int colorIndex = 0;

  return listaPromedios.map((p) {
    final porcentaje = (p.promedio / total) * 100;
    final color = colores[colorIndex % colores.length];
    colorIndex++;

    return PieChartSectionData(
      color: color,
      value: p.promedio,
      title: '${porcentaje.toStringAsFixed(1)}%',
      titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
      radius: 60,
    );
  }).toList();
}

  Widget _mostrarGraficoIntentos(Usuarios usr){

    final materias = usr.puntos.keys.toSet().union(usr.intentos.keys.toSet()).toList();

    List<FlSpot> puntosSpots = [];
    List<FlSpot> intentosSpots = [];

    for (int i = 0; i < materias.length; i++) {
      final materia = materias[i];
      double puntos = (usr.puntos[materia] ?? 0).toDouble();
      double intentos = (usr.intentos[materia] ?? 0).toDouble();

      puntosSpots.add(FlSpot(i.toDouble(), puntos));
      intentosSpots.add(FlSpot(i.toDouble(), intentos * 100));
    }

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: materias.length - 1,
        minY: 0,
        maxY: 1200,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value,meta){
                // Solo mostrar si es entero exacto
                if (value % 1 != 0) return const SizedBox.shrink();

                int index = value.toInt();

                if (index < 0 || index >= materias.length) return const SizedBox.shrink();

                return Text(obtenerIniciales(materias[index]),style: const TextStyle(fontSize: 10));
              }
            )
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 100,
              reservedSize: 28,
              showTitles: true,
              getTitlesWidget: (value,meta){
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 8),  // tamaño más pequeño
                );
              }
              )),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: puntosSpots,
            isCurved: true,
            color: const Color(0xff0f1424),
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: intentosSpots,
            isCurved: true,
            color: const Color(0xFFCC9932),
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        gridData: const FlGridData(show: true, horizontalInterval: 100),
        borderData: FlBorderData(show: false),
      )
    );
  }

}


