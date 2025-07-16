import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lionxcode_finalproject/class/ahorcado.dart';
import 'package:lionxcode_finalproject/class/calle.dart';
import 'package:lionxcode_finalproject/class/usuarios.dart';
import 'package:lionxcode_finalproject/providers/login_block.dart';

class Firestore {

  final String collection;
  final String ? materia;
  Firestore({required this.collection,this.materia});

  final _database = FirebaseFirestore.instance;

  Stream<List<Ahorcado>> get ahorcado {
    return _database.collection(collection)
    .where('materia', isEqualTo: materia)
    .snapshots()
    .map(_listAhorcado);
  }

  List<Ahorcado> _listAhorcado(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Ahorcado(
        materia: data["materia"], 
        pregunta: data["pregunta"], 
        respuesta: data["respuesta"]);
    }).toList();
  }

  Stream<List<Calle>> get calle {
    return _database.collection(collection)
    .where('materia', isEqualTo: materia)
    .snapshots()
    .map(_listCalle);
  }

  List<Calle> _listCalle(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Calle(
        materia: data["materia"], 
        pregunta: data["pregunta"], 
        respuestas: Map<String, bool>.from(data["respuestas"])
      );
    }).toList();
  }

  Stream<List<Usuarios>> get usuarios {
    return _database.collection(collection)
    .snapshots()
    .map(_listUsuarios);
  }

  List<Usuarios> _listUsuarios(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Usuarios(
        uid: doc.id,
        nombre: data["nombre"],
        puntos: Map<String, int>.from(data["puntos"]),
        intentos: Map<String, int>.from(data["intentos"]),
      );
    }).toList();
  }

  Future<bool> crearNuevoUsuario(LoginBlock block, String idUser) async {
    
    Map<String,int> data = {
      "Algebra lineal" : 0,
      "Comunicación efectiva" : 0,
      "Metodología de la investigación" : 0,
      "Programación 1" : 0,
      "Cálculo de una variable": 0
    };

    try{
      await _database.collection(collection).doc(idUser).set({
        "nombre": block.name,
        "email": block.email,
        "puntos": data,
        "intentos": data
      });
      return true;
    }catch(e){
      return false;
    }
  }

  Future getDataUser(String uid) async {
    final snapshot = await _database.collection(collection).doc(uid).get();
    return snapshot.data();
  }
  
  Future updateIntentos(String uid) async{
    await _database.collection(collection).doc(uid).update({
      'intentos.$materia': FieldValue.increment(1)
    });
  }

  Future updatePuntos(String uid) async{
    await _database.collection(collection).doc(uid).update({
      'puntos.$materia': FieldValue.increment(100)
    });
  }
}