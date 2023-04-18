import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/About/Contacts/SinglePersonModelNew.dart';
import 'package:open_university_rsvpu/About/Contacts/SinglePersonWidgetNew.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactWidgetNew extends StatefulWidget {
  const ContactWidgetNew({Key? key}) : super(key: key);

  @override
  State<ContactWidgetNew> createState() => _WithContactWidgetNewState();
}

class _WithContactWidgetNewState extends State<ContactWidgetNew>
    with AutomaticKeepAliveClientMixin<ContactWidgetNew> {
  var _url = "";
  var _postsJson = [];
  final _postsJsonFiltered = [];
  String _searchValue = '';
  void fetchDataPersons() async {
    try {
      if (kIsWeb) {
        setState(() {
          _url = "https://koralex.fun/news_api/buffer.php?type=json&link=http://api.bytezone.online/persons";
        });
      }
      else{
        setState(() {
          _url = 'http://api.bytezone.online/persons';
        });
      }
      final response = await get(Uri.parse(_url));
      var jsonData = jsonDecode(response.body) as List;
      var prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setString("persons_output", json.encode(jsonData));
        _postsJson = jsonData;
      });
    } catch (err) {
      var prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("persons_output")){
        setState(() {
          _postsJson = json.decode(prefs.getString("persons_output")!);
        });
      }
    }
  }
  @override
  void initState() {
    super.initState();
    fetchDataPersons();
  }

  Future onRefresh() async {
    setState(() {
      fetchDataPersons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      super.build(context);
      if (_searchValue != "") {
        _postsJsonFiltered.clear();
        for (int i = 0; i < _postsJson.length; i++) {
          if (_postsJson[i]["name"]
                  .toString()
                  .toLowerCase()
                  .contains(_searchValue.toLowerCase()) ||
              _postsJson[i]["description"]["Должность"]
                  .toString()
                  .toLowerCase()
                  .contains(_searchValue.toLowerCase())) {
            _postsJsonFiltered.add(_postsJson[i]);
          }
        }
      } else {
        _postsJsonFiltered.clear();
        for (int i = 0; i < _postsJson.length; i++) {
          _postsJsonFiltered.add(_postsJson[i]);
        }
      }

      return Scaffold(
        appBar: EasySearchBar(
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
              ? const Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
          title: const Align(
              alignment: Alignment.centerLeft,
              child: Text("Наставники", style: TextStyle(fontSize: 24))),
          onSearch: (value) {
            setState(() {
              _searchValue = value;
            });
          },
        ),
        body: RefreshIndicator(
          color: const Color.fromRGBO(34, 76, 164, 1),
          onRefresh: onRefresh,
          child: Center(
            child: ListView.builder(
              itemCount: _postsJsonFiltered.length,
              itemBuilder: (context, index) {
                var name = "";
                if (_postsJsonFiltered[index]['name'] != "" &&
                    _postsJsonFiltered[index]['name'] != null) {
                  name = _postsJsonFiltered[index]['name'];
                  name = name.replaceAll(r"\n", "");
                  name = name.toUpperCase();
                }
                var mainDesc = <String, dynamic>{};
                if (_postsJsonFiltered[index]['description'] != null) {
                  mainDesc = _postsJsonFiltered[index]['description'];
                }
                var jobTitle = "";
                if (mainDesc['Должность'] != null && mainDesc['Должность'] != "") {
                  jobTitle = mainDesc['Должность'];
                }

                var interview = "";
                if (_postsJsonFiltered[index]['interview'] != "" &&
                    _postsJsonFiltered[index]['interview'] != null) {
                  interview = _postsJsonFiltered[index]['interview'];
                  String br = "";
                  interview = interview.replaceAll(r"\n", br);

                }
                var imgLink = "";
                if (_postsJsonFiltered[index]['img'] != "" &&
                    _postsJsonFiltered[index]['img'] != null) {
                  if (_postsJsonFiltered[index]['img']['id'] != "" &&
                      _postsJsonFiltered[index]['img']['id'] != null) {
                    if (_postsJsonFiltered[index]['img']['format'] != "" &&
                        _postsJsonFiltered[index]['img']['format'] != null) {
                      if (kIsWeb) {
                        imgLink = "https://koralex.fun/news_api/buffer.php?type=image&link=http://api.bytezone.online/imgs/${_postsJsonFiltered[index]["img"]["id"]}.${_postsJsonFiltered[index]["img"]["format"]}";
                      }
                      else{
                        imgLink =
                        "http://api.bytezone.online/imgs/${_postsJsonFiltered[index]["img"]["id"]}.${_postsJsonFiltered[index]["img"]["format"]}";
                      }
                    }
                  }
                }
                return Card(
                  shadowColor: Colors.black,
                  elevation: 20,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SinglePersonWidget(
                              singlePersonModelNew: SinglePersonModelNew(name,
                                  mainDesc,interview, imgLink))));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5.0),
                          //padding: EdgeInsets.only(top: 3.0, left: 3.0, right: 3.0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)),
                          ),
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  10.0,
                              height: (MediaQuery.of(context).size.width -
                                  10.0) /
                                  16 *
                                  9,
                              child: CachedNetworkImage(
                                placeholder: (context, url) => const Image(image: AssetImage('images/Loading_icon.gif')),
                                imageUrl: imgLink,
                                fit: BoxFit.cover,
                                width: double.maxFinite,
                                height: double.maxFinite,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 10.0, right: 10.0),
                          child: Text(
                            jobTitle,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
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
    });
  }

  @override
  bool get wantKeepAlive => true;
}
