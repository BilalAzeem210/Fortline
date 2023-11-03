
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fortline_app/Screen/AdsAndMenuTwo.dart';
import 'package:fortline_app/Screen/product_item.dart';
import 'package:http/http.dart' as http;

import 'homescreen.dart';

class Products extends StatefulWidget {
  late String _email;
  Products(String email){
    this._email = email;
  }
  @override
  State<Products> createState() {
    // TODO: implement createState
    return _ProductsState();
  }
}
class _ProductsState extends State<Products>{
  List<Uint8List> images = [];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffce0505),
        title: Text("Products",style: TextStyle(
          fontFamily: "SpaceGrotesk",
        ),),
      ),
      body: FutureBuilder<bool>(
        future: _getProducts(),
        builder: (ctx, snapshot){
          if(snapshot.hasData){
            if(snapshot.data!){
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  //childAspectRatio: 1.5,
                  //crossAxisSpacing: 15,
                ),
                itemBuilder: (ctx, position){
                  return ProductItem(images[position]);
                },
                itemCount: images.length,
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    ), onWillPop: () async{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
        return HomeScreen(widget._email);
      }));
      return true;
    });
  }
  Future<bool> _getProducts() async{
    try{
      var response = await http.get(Uri.http("194.163.154.21:1251","/ords/fortline/reg/product"));
      var blobs = jsonDecode(response.body.toString())["items"];
      if(blobs.length > 0) {
        for (int i = 0; i < blobs.length; i++) {
          images.add(base64Decode(blobs[i]["contents_blob"]));
        }
        return true;
      }
    }
    catch(e){
      print("Error fetching : ${e.toString()}");
    }
    return false;
  }
}
