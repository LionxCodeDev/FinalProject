import 'dart:async';

class Validators {
  //////
  ///
  final validarNombre = StreamTransformer<String, String>.fromHandlers(
      handleData: (nombre, sink) {
    if (nombre.isNotEmpty) {
      nombre.length >= 4
          ? sink.add(nombre)
          : sink.addError("Nombre debe tener mínimo 4 letras ");
    }
  });

  final validarEmail = StreamTransformer<String, String>.fromHandlers(handleData: (email,sink){
    Pattern pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; // Expresión regular para correos
    RegExp regExp = RegExp(pattern.toString());
      if (email.isNotEmpty) {
      if (regExp.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError("Correo no válido");
      }
    }
    }
  );

  final validarPassword = StreamTransformer<String,String>.fromHandlers(handleData: (password,sink){
    if (password.isNotEmpty) {
      if (password.length >= 6) {
        sink.add(password);
      } else {
        sink.addError("Contraseña debe tener al menos 6 caracteres");
      }
    }
  });

}
