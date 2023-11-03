import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'dart:convert';

class ProductItem extends StatefulWidget{
  late Uint8List _iMage;
  ProductItem(Uint8List iMage){
    this._iMage = iMage;
  }
  @override
  State<ProductItem> createState() {
    // TODO: implement createState
    return _ProductItemState();
  }
}
class _ProductItemState extends State<ProductItem>{
  @override
  Widget build(BuildContext context) {
    /*return Padding(padding: EdgeInsets.all(10),
    child: LayoutBuilder(
      builder: (ctx, constraints){
        return InkWell(
          onTap: (){
            print("IMage tap");
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
              return PdfScreen();
            }));
          },
          child: ClipRRect(
            child: GridTile(
              child: Image.asset("assets/images/ups.jpg",
                fit: BoxFit.cover,),
              footer: Container(
                height: constraints.maxHeight * .2,
                child: GridTileBar(backgroundColor: Colors.black,
                  title: Text("Laptop"),
                ),
              ),
            ),
            borderRadius: BorderRadius.circular(15),

          ),
        );

      },
    ),);*/
    return InkWell(
      onTap: (){
        print("laptop");
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      image: DecorationImage(
                        image: MemoryImage(widget._iMage
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffce0505),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15))
                    ),
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: <Widget>[
                          Text("Ups",style: TextStyle(
                            fontFamily: "SpaceGrotesk",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),),
                          SizedBox(width: 5,),
                          Expanded(child: Text("40\$" ,style: TextStyle(
                            fontFamily: "SpaceGrotesk",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                            textAlign: TextAlign.right,)),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}