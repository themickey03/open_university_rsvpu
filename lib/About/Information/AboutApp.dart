import 'package:flutter/material.dart';


class AboutAppWidget extends StatefulWidget {
  const AboutAppWidget({super.key});

  @override
  _AboutAppWidgetState createState() => _AboutAppWidgetState();
}

class _AboutAppWidgetState extends State<AboutAppWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MediaQuery.of(context).platformBrightness != Brightness.dark ? const Color.fromRGBO(34,76,164, 1) : ThemeData.dark().primaryColor,
        title: const Align(alignment: Alignment.centerLeft,child: Text("О приложении", style: TextStyle(fontSize: 24))),
        elevation: 0,
      ),
      body: Center(
        child: ListView(
          children: [
            SizedBox(
              height: 40,
              child: Text(""),
            ),
             Align(
               alignment: Alignment.center,
              child: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 5.0, right: 5.0),
                    child: Image(
                      image: AssetImage('images/Logo.png'),
                      width: 250,
                      height: 141,
                    ),
                  ),
                  Text("Открытый университет РГППУ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("Приложение-компаньон для веб-ресурса", style: TextStyle(fontSize: 18)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0, bottom: 20.0),
                      child: Text("С его помощью Вы можете проверять новости нашего проекта, "
                          "просматривать наши лекции и истории в видео-формате, а также узнать о наших Наставниках, "
                          "которые помогают нам быть лучше", textAlign: TextAlign.left,),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0, bottom: 20.0),
                      child: Text("Версия: 1.0.0\nРоссийский Государственный Профессионально-Педагогический Университет\n2023 г.", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}