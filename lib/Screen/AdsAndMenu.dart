import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortline_app/Screen/Dashboard_Screen.dart';
import 'package:fortline_app/Screen/customer_complain.dart';
import 'package:fortline_app/Screen/user_complain.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Login_Screen.dart';
class AdsAndMenu extends StatefulWidget {
  late String _email;
  AdsAndMenu(String email){
    this._email = email;
  }

  @override
  State<AdsAndMenu> createState() => _AdsAndMenuState();
}
final List<String> imgList = [
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];
/*final List<Widget> imageSliders = imgList
    .map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.network(item, fit: BoxFit.cover, width: 1000.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'No. ${imgList.indexOf(item)} image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )),
  ),
))
    .toList();*/
class _AdsAndMenuState extends State<AdsAndMenu> {
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  List<Map<String, String>> _iteMsData = [
    {"name" : "Invoices", "icon" : "assets/images/invoices3.png"},
    {"name" : "Complains", "icon" : "assets/images/complain.png"},
    {"name" : "Profile", "icon" : "assets/images/profile.png"},
    {"name" : "Products", "icon" : "assets/images/products.png"}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard',style: TextStyle(
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
                DropdownMenuItem(value: 'Call',child: Container(child: Row(
                  children: const <Widget>[
                    Icon(Icons.call,color: Color(0xFF0f388a),),

                    SizedBox(width: 8,),

                    Text('Call',style: TextStyle(
                      fontFamily: "SpaceGrotesk",
                    ),
                    ),
                  ],
                ),),
                ),
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
                DropdownMenuItem(value: 'Account',child: Container(
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.manage_accounts,color: Color(0xFF0f388a),),

                      SizedBox(width: 8,),

                      Text('Account',style: TextStyle(
                        fontFamily: "SpaceGrotesk",
                      ),
                      ),
                    ],
                  ),
                ),)
              ],
              onChanged: (itemIdentifier) async{
                if(itemIdentifier == 'Account'){
                  //showAds = true;
                  /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView(),
                  ),
                  );*/
                }
                else if(itemIdentifier == 'Call') {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: "123456789",
                  );
                  await launchUrl(launchUri);

                }
              },
            ),
          ),


        ],
      ),
      body: Column(children: [
        Expanded(child: LayoutBuilder(builder: (ctx, constraints){
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    print(currentIndex);
                  },
                  child: CarouselSlider(
                    items: imgList
                        .map(
                          (item) => ClipRRect(child: Image.network(
                        item,
                        fit: BoxFit.cover,
                        width: constraints.maxWidth,
                      ),
                        borderRadius: BorderRadius.circular(30),
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
            ),
          );
        })),
        Expanded(child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5
        ), itemBuilder: (ctx, position){

          return InkWell(
            onTap: (){
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
                ),
                Text(_iteMsData[position]["name"]!, style: TextStyle(color: Colors.red),
                )
              ],
            ),
          );
        },
          itemCount: 4,
        ),
        )

      ]),
    );
  }
}