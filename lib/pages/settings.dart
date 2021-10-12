import 'package:flutter/material.dart';
import 'package:listas_de_compras/layout.dart';

class SettingsPage extends StatelessWidget {
  static String tag = 'settings-page';

  @override
  Widget build(BuildContext context) {
    return Layout.getContent(
        context,
        Center(
          child: Text(
            'Aqui vamos modificar coisas',
            style: TextStyle(color: Layout.dark()),
          ),
        ));
  }
}
