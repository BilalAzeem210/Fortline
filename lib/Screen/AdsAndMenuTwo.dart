import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fortline_app/Screen/Login_Screen.dart';
import 'package:fortline_app/Screen/customer_complain.dart';
import 'package:fortline_app/Screen/pdf_viewer.dart';
import 'package:fortline_app/Screen/products.dart';
import 'package:fortline_app/Screen/user_complain.dart';
import 'package:transparent_pointer/transparent_pointer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'Dashboard_Screen.dart';



class AdsAndMenuTwo extends StatefulWidget {
  late String _email;

  AdsAndMenuTwo(String email){
   this._email = email;
  }

  @override
  State<AdsAndMenuTwo> createState() => _AdsAndMenuTwoState();
}

class _AdsAndMenuTwoState extends State<AdsAndMenuTwo> {
  final List<Uint8List> imgList = [
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  List<Map<String, String>> _iteMsData = [
    {"name" : "Invoices", "icon" : "assets/images/invoices3.png"},
    {"name" : "Complaints", "icon" : "assets/images/complain.png"},
    {"name" : "Fortline profile", "icon" : "assets/images/solution.png"},
    {"name" : "Products", "icon" : "assets/images/products.png"},
    {"name" : "My account", "icon" : "assets/images/account.png"},
    {"name" : "Call", "icon" : "assets/images/call.png"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Fortline',style: TextStyle(
            fontFamily: "SpaceGrotesk",
          ),
          ),
          backgroundColor: const Color(0xffce0505),
          actions:  [


            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: DropdownButton(underline: Container() ,icon:const Icon(
                Icons.more_vert,
                color: Colors.white,

              ),
                items: [
                  DropdownMenuItem(value: 'logout',child: Container(
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.exit_to_app,color: Color(0xFF0f388a),),

                        SizedBox(width: 8,),

                        Text('logout',style: TextStyle(
                          fontFamily: "SpaceGrotesk",
                        ),
                        ),
                      ],
                    ),
                  ),
                  ),
                ],
                onChanged: (itemIdentifier) async{
                  if(itemIdentifier == "logout"){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                      return LoginView();
                    }));
                  }
                },
              ),
            ),


          ],
        ),
      body: Container(height: double.infinity,width: double.infinity,child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 1,
              color: Colors.white,
              /*decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))
            ),*/
              child: FutureBuilder<bool>(future: _getImages(),
                builder: (ctx, snapshot){
                if(snapshot.hasData){
                  if(snapshot.data!){
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        InkWell(
                          onTap: () {
                            print(currentIndex);
                          },
                          child: CarouselSlider(
                            items: imgList
                                .map(
                                  (item) => ClipRRect(child: Image.memory(
                                item,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 1,
                              ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            )
                                .toList(),
                            carouselController: carouselController,
                            options: CarouselOptions(
                              scrollPhysics: const BouncingScrollPhysics(),
                              autoPlay: true,
                              aspectRatio: 2,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imgList.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => carouselController.animateToPage(entry.key),
                                child: Container(
                                  width: currentIndex == entry.key ? 17 : 7,
                                  height: 7.0,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3.0,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      color: currentIndex == entry.key
                                          ? Colors.red
                                          : Colors.teal),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }
                }
                return Center(
                  child: Text("Something went wrong"),
                );
              },)
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.29),
              child: Container(
                  height: MediaQuery.of(context).size.height * 1,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.red,
                        Colors.black54
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      tileMode: TileMode.repeated
                    ),
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(13), topLeft: Radius.circular(13)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0,3)
                        )
                      ]
                  ),
                  child: Column(children: <Widget>[
                    SizedBox(height: (MediaQuery.of(context).size.height * 0.7) * 0.04,),
                    Expanded(child: GridView.builder(scrollDirection: Axis.vertical,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5
                    ), itemBuilder: (ctx, position){

                      return InkWell(
                        onTap: () async{
                          switch(position){
                            case 0:
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                                return DashboardScreen(widget._email);
                              }));
                              break;
                            case 1:
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                                return CustomerComplain(widget._email);
                              }));
                              break;
                            case 2:
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                                return PdfScreen(widget._email);
                              }));
                              break;
                            case 3:
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                                return Products(widget._email);
                              }));
                              break;
                            case 5:
                              final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: "021111992999",
                                    );
                                  await launchUrl(launchUri);
                                  break;
                          }
                          print("tap");
                        },
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(backgroundImage: AssetImage(
                                _iteMsData[position]["icon"]!
                            ),
                              radius: 30,
                            ),
                            SizedBox(
                              height: 5,
                            ),Text(_iteMsData[position]["name"]!, style: TextStyle(color: Colors.black)),

                          ],
                        ),
                      );
                    },
                      itemCount: _iteMsData.length,
                    ),
                    )
                  ],)
              ))
        ],
      ),), //Center,
    );
  }
  Future<bool> _getImages() async{
    try{
      var response = await http.get(Uri.http("194.163.154.21:1251","/ords/fortline/reg/notification"));
      var data = jsonDecode(response.body.toString());
      var blobs = data["items"];
      if(blobs.length > 0){
        for(int i = 0; i < blobs.length; i++){
          imgList.add(base64Decode(blobs[i]["contents_blob"]));
        }
        return true;
      }
    }
    catch(e){
      print(e.toString());
    }
    return false;
  }
}
