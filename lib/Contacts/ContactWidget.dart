import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/Contacts/SinglePersonModel.dart';
import 'package:open_university_rsvpu/Contacts/SinglePersonWidget.dart';

class ContactWidget extends StatefulWidget {
  const ContactWidget({Key? key}) : super(key: key);

  @override
  _WithContactWidgetState createState() => _WithContactWidgetState();
}

class _WithContactWidgetState extends State<ContactWidget>
    with AutomaticKeepAliveClientMixin<ContactWidget> {
  //TODO change link
  final url = "https://koralex.fun/back/persons";
  var _postsJson = [];
  void fetchDataPersons() async {

    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {
        _postsJson = jsonData;
      });
    } catch (err) {
      print(err);
    }
  }

  void initState(){
    super.initState();
    fetchDataPersons();
  }

  Future onRefresh() async{
    setState(() {
      fetchDataPersons();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Align(alignment: Alignment.centerLeft,child: Text("Наставники", style: TextStyle(fontSize: 24))),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Center(
          child: ListView.builder(
            itemCount: _postsJson.length,
            itemBuilder: (context, index) {
              var name = "";
              if (_postsJson[index]['name'] != "" && _postsJson[index]['name'] != null){
                name = _postsJson[index]['name'];
              }
              var main_desc = Map<String, dynamic>();
              if (_postsJson[index]['description'] != null){
                main_desc = _postsJson[index]['description'];
              }
              var job_title = "";
              if (main_desc['Должность'] != "" && main_desc['Должность'] != null){
                job_title = main_desc['Должность'];
              }
              var structure = "";
              if (main_desc['Структурное подразделение'] != "" && main_desc['Структурное подразделение'] != null){
                structure = main_desc['Структурное подразделение'];
              }
              var academic_degree = "";
              if (main_desc['Ученая степень'] != "" && main_desc['Ученая степень'] != null){
                academic_degree = main_desc['Ученая степень'];
              }
              var academic_title = "";
              if (main_desc['Ученое звание'] != "" && main_desc['Ученое звание']  != null){
                academic_title = main_desc['Ученое звание'] ;
              }
              var desc = "";
              if (main_desc['Краткие биографические данные'] != "" && main_desc['Краткие биографические данные'] != null){
                desc = main_desc['Краткие биографические данные'];
              }
              var scientific_interests = "";
              if (main_desc['Область научных интересов'] != "" && main_desc['Область научных интересов'] != null){
                scientific_interests = main_desc['Область научных интересов'] ;
              }
              var prizes = "";
              if (main_desc['Награды'] != "" && main_desc['Награды'] != null){
                prizes = main_desc['Награды'];
              }
              var publishing = "";
              if (main_desc['Значимые публикации'] != "" && main_desc['Значимые публикации'] != null){
                publishing = main_desc['Значимые публикации'];
              }
              var phone = "";
              if (_postsJson[index]['phone'] != "" && _postsJson[index]['phone'] != null){
                phone = _postsJson[index]['phone'];
              }
              var email = "";
              if (_postsJson[index]['email'] != "" && _postsJson[index]['email'] != null){
                email = _postsJson[index]['email'];
              }
              var img_link = "";
              if (_postsJson[index]['img'] != "" && _postsJson[index]['img'] != null){
                if (_postsJson[index]['img']['id'] != "" && _postsJson[index]['img']['id'] != null){
                  if (_postsJson[index]['img']['format'] != "" && _postsJson[index]['img']['format'] != null){
                    //TODO change link
                    img_link = "https://koralex.fun/back/imgs/${_postsJson[index]["img"]["id"]}.${_postsJson[index]["img"]["format"]}";
                  }
                }
              }
              return Card(
                shadowColor: Colors.black,
                elevation: 20,
                    child: InkWell(
                      onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                SinglePersonWidget(
                                  singlePersonModel:
                                  SinglePersonModel(
                                    name,
                                    job_title,
                                    structure,
                                    academic_degree,
                                    academic_title,
                                    desc,
                                    scientific_interests,
                                    prizes,
                                    publishing,
                                    phone,
                                    email,
                                    img_link
                                  )
                        )
                    )
                  );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        //padding: EdgeInsets.only(top: 3.0, left: 3.0, right: 3.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
                          color: Colors.blueAccent,
                        ),
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: FadeInImage.assetNetwork(
                            alignment: Alignment.topCenter,
                            placeholder: 'images/Loading_icon.gif',
                            //TODO change link
                            image: img_link != "" ? img_link : "http://koralex.fun:3000/_nuxt/assets/images/logo.png",
                            fit: BoxFit.cover,
                            width: double.maxFinite,
                            height: double.maxFinite,
                          ),
                        ),
                      ),
                      Text(name, style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 10.0, right: 10.0),
                        child: Text(job_title, style: const TextStyle(
                          fontSize: 14
                        ), textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}