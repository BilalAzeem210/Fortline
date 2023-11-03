import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortline_app/Screen/customer_complain.dart';

import 'customclipper.dart';
import 'package:http/http.dart' as http;

class UserComplain extends StatefulWidget {
  late String _email;
  UserComplain(String email){
    this._email = email;
  }

  @override
  State<UserComplain> createState() => _UserComplainState();
}

class _UserComplainState extends State<UserComplain> {
  final _formKey = GlobalKey<FormState>();
  String _coMplain = "";
  var _referenceNo;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text("Complaint form",style: TextStyle(
          fontFamily: "SpaceGrotesk",
        ),),
        backgroundColor: const Color(0xffce0505),
      ),
      body: Center(child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[TextFormField(
                onSaved: (val){
                  _referenceNo = val!;
                },
                validator: (val){
                  if(val == null || val == ""){
                    return "Please enter valid reference no";
                  }
                },
                decoration: InputDecoration(
                    hintText: "Reference no",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black12)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: const Color(0xffce0505))
                    )
                ),
              ),
                SizedBox(height: 10,),
                TextFormField(
                  maxLines: 7,
                  onSaved: (val){
                    _coMplain = val!;
                  },
                  validator: (val){
                    if(val == null || val == ""){
                      return "Please enter some sort of complaint message";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Complaints",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black12)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: const Color(0xffce0505))
                      )
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                  _submitComplaint();
                }, child: Text("Submit"),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffce0505)),
                )
              ],
            ),),
        ),
      ),)
    ),
    onWillPop: ()async{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
        return CustomerComplain(widget._email);
      }));
      return true;
    },
    );
  }
  void _submitComplaint() async{
    bool isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
      try {
        var response = await http.post(
            Uri.http("194.163.154.21:1251", "/ords/fortline/reg/complain"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode({
              "insby": widget._email,
              "tktremarks": _coMplain,
              "prncplrefno": _referenceNo
            })
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Complain successfully posted",style: TextStyle(
          fontSize: 16,
          fontFamily: "SpaceGrotesk",
          color: Color(0xffce0505),

        ),
        ))
        );
        return;
      }
      catch(e){
        print("Complain post error: ${e.toString()}");
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Error in posting the complain",style: TextStyle(
        fontSize: 16,
        fontFamily: "SpaceGrotesk",
        color: Color(0xffce0505),

      ),
      ))
      );
    }
  }
}
