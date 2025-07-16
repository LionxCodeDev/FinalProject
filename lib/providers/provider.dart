import 'package:flutter/material.dart';
import 'login_block.dart';

class Provide extends InheritedWidget {
  static Provide? _instancia;

  factory Provide({required Key key, required Widget child}) {
    _instancia ??= Provide._internal(key: key, child: child);

    return _instancia!;
  }

  Provide._internal({required Key super.key, required super.child});

  final loginBloc = LoginBlock();

  // Provider({ Key key, Widget child })
  //   : super(key: key, child: child );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBlock of(BuildContext context) {
    // ignore: deprecated_member_use
    // ignore: unnecessary_cast
    return (context.dependOnInheritedWidgetOfExactType<Provide>() as Provide)
        .loginBloc;
  }
}
