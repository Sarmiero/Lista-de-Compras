import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:listas_de_compras/layout.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static String tag = 'about-page';

  @override
  Widget build(BuildContext context) {
    Container theLogoThizer = Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/logo_cetic.png',
              scale: 2.0,
              width: 200,
            )));

    Container linkThizer = Container(
      width: 180,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onSurface: Colors.black,
          elevation: 20,
          shadowColor: Colors.blue,
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(FontAwesomeIcons.externalLinkAlt, color: Colors.white, size: 10),
          SizedBox(width: 5),
          Text(' sepm.rj.gov.br', style: TextStyle(color: Colors.white))
        ]),
        onPressed: () {
          String url = 'https://sepm.rj.gov.br/';
          canLaunch(url).then((status) {
            if (status) {
              launch(url);
            } else {
              // Show an snackbar error
              ScaffoldMessenger.of(Layout.scaffoldContext)
                  .showSnackBar(SnackBar(
                content: Text(
                    'Não foi possível abrir o site, tente novamente mais tarde'),
                duration: Duration(seconds: 15),
              ));
            }
          });
        },
      ),
    );

    Container linkYoutube = Container(
      width: 180,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          onSurface: Colors.green,
          elevation: 20,
          shadowColor: Colors.red,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.youtube, color: Colors.white, size: 15),
            SizedBox(width: 5),
            Text('  TV PMERJ no YouTube', style: TextStyle(color: Colors.white))
          ],
        ),
        onPressed: () {
          String url = 'https://www.youtube.com/c/TVPMERJ';
          canLaunch(url).then((status) {
            if (status) {
              launch(url);
            } else {
              // Show an snackbar error
              ScaffoldMessenger.of(Layout.scaffoldContext)
                  .showSnackBar(SnackBar(
                content: Text(
                    'Não foi possível abrir o site, tente novamente mais tarde'),
                duration: Duration(seconds: 15),
              ));
            }
          });
        },
      ),
    );

    return Layout.getContent(
        context,
        Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Center(
                  child: Text('CETIC_MOBILE',
                      style: TextStyle(
                          fontSize: 22,
                          color: Layout.primary(),
                          fontWeight: FontWeight.bold))),
              SizedBox(height: 10),
              Center(
                  child: Text('Listas de Supermercado',
                      style: TextStyle(fontSize: 16))),
              SizedBox(height: 20),
              // Center(child: Text('Um aplicativo Flutter por:')),
              Center(child: theLogoThizer),
              SizedBox(height: 20),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[linkThizer, linkYoutube])
            ],
          ),
        ));
  }
}
