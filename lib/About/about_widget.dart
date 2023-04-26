import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/About/Contacts/contact_widget.dart';
import 'package:open_university_rsvpu/About/Information/about_project.dart';
import 'package:open_university_rsvpu/About/Settings/app_settings.dart';
import 'package:open_university_rsvpu/About/Information/about_app.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/rsvpu_icon_class_icons.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';

class AboutWidget extends StatefulWidget {
  const AboutWidget({super.key});

  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          leadingWidth: 40,
          leading:
          const Padding(
            padding: EdgeInsets.only(left: 3),
            child: Icon(RsvpuIconClass.universityLogo, color: Colors.white),
          ),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
              ? const Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
          title: const Align(
              alignment: Alignment.centerLeft,
              child: Text("О нас", style: TextStyle(fontSize: 24))),
          elevation: 0,
        ),
        body: Center(
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    top: 15.0, bottom: 5.0, left: 5.0, right: 5.0),
                child: Image(
                  image: AssetImage('images/Logo.png'),
                  width: 250,
                  height: 141,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Text("Открытый университет РГППУ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))),
              ),
              const Divider(),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AboutProjectWidget()));
                },
                visualDensity:
                    const VisualDensity(vertical: -4, horizontal: -4),
                title: const Text("О проекте", style: TextStyle(fontSize: 15)),
                leading: const Icon(Icons.info_rounded, size: 15.0),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15.0),
              ),
              const Divider(),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ContactWidgetNew()));
                },
                visualDensity:
                    const VisualDensity(vertical: -4, horizontal: -4),
                title: const Text("Наставники", style: TextStyle(fontSize: 15)),
                leading: const Icon(Icons.people, size: 15.0),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15.0),
              ),
              const Divider(),
              // ListTile(
              //   onTap: (){
              //     Navigator.of(context).push(
              //         MaterialPageRoute(
              //             builder: (context) => const VideoSettingsWidget()
              //         )
              //     );
              //   },
              //   visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
              //   title: const Text("Настройки видео", style:TextStyle(fontSize: 15)),
              //   leading: const Icon(Icons.video_settings, size: 15.0),
              //   trailing: const Icon(Icons.arrow_forward_ios, size: 15.0),
              // ),
              // const Divider(),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AppSettingsWidget()));
                },
                visualDensity:
                    const VisualDensity(vertical: -4, horizontal: -4),
                title: const Text("Настройки", style: TextStyle(fontSize: 15)),
                leading: const Icon(Icons.settings, size: 15.0),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15.0),
              ),
              const Divider(),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AboutAppWidget()));
                },
                visualDensity:
                    const VisualDensity(vertical: -4, horizontal: -4),
                title:
                    const Text("О приложении", style: TextStyle(fontSize: 15)),
                leading: const Icon(Icons.perm_device_information, size: 15.0),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15.0),
              ),
              const Divider(),
            ],
          ),
        ),
      );
    });
  }
}