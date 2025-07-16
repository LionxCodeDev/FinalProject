import 'dart:async';
import 'package:lionxcode_finalproject/services/validators.dart';
import 'package:rxdart/rxdart.dart';


class LoginBlock implements Validators {
  final _nameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get nameStream =>
      _nameController.stream.transform(validarNombre);

  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<bool> get submitRegister =>
      Rx.combineLatest3(nameStream, emailStream, passwordStream,(n, e, p) => true);
  
  Stream<bool> get submitLogin =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);    

  // Insertar valores al Stream
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get name => _nameController.value;
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _nameController.close();
    _emailController.close();
    _passwordController.close();
  }

  void reset() {
    _nameController.add('');
    _emailController.add('');
    _passwordController.add('');
  }

  @override
  StreamTransformer<String, String> get validarNombre =>
      StreamTransformer<String, String>.fromHandlers(
          handleData: (nombre, sink) {
        if (nombre.isNotEmpty) {
          nombre.length >= 4
              ? sink.add(nombre)
              : sink.addError("Nombre debe tener mínimo 4 letras ");
        }
      });

  @override
  StreamTransformer<String, String> get validarEmail =>
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
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
  });

  @override
  StreamTransformer<String, String> get validarPassword =>
      StreamTransformer<String, String>.fromHandlers(handleData: (password, sink) {
    if (password.isNotEmpty) {
      if (password.length >= 6) {
        sink.add(password);
      } else {
        sink.addError("Contraseña debe tener al menos 6 caracteres");
      }
    }
  });
}
