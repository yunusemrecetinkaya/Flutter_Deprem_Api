import 'dart:convert';
import 'dart:ui';
import 'dart:async';
import 'package:deprem_api/api/api.dart';
import 'package:deprem_api/models/deprem_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<DepremModel> veriler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    veriler = GetApi().getApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Son Depremler'),
        centerTitle: true,

      ),
      body: Center(
        child: FutureBuilder<DepremModel>(
          future: veriler,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Veriler Yükleniyor'),
                    ],
                  ),
                );
                break;
              default:
                if (snapshot.hasError) {
                  return Text('HATA : ${snapshot.hasError}');
                } else {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.result.length,
                    itemBuilder: (context, index) {
                      List<Result> veriler = snapshot.data.result;
                      Result item = veriler[index];
                      return ListTile(
                        ///BAŞLIK
                        title: Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(),
                        ),

                        ///ALT BAŞLIK
                        subtitle: Text(
                          item.date,
                          textAlign: TextAlign.center,
                        ),


                        ///CİRCLE AVATAR
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Text(
                            item.mag.toString(),
                            style: TextStyle(color: item.mag < 5 ? Colors.blue: Colors.red),
                          ),
                        ),

                        ///MAP İCON
                        trailing: InkWell(
                          onTap: () async {
                            var mapLink =
                                'https://maps.google.com/maps?q=${item.lat},${item.lng}';
                            await launch(mapLink);
                          },
                          child: Icon(
                            Icons.place,
                            color: Colors.green,
                          ),
                        ),
                      );
                    },
                  );
                }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            veriler = GetApi().getApi();
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
