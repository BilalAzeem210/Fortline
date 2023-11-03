import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fortline_app/Screen/AdsAndMenuTwo.dart';
import 'package:fortline_app/Screen/user_complain.dart';
import 'package:http/http.dart' as http;

import 'homescreen.dart';

class CustomerComplain extends StatefulWidget {
  late String _email;
  CustomerComplain(String email){
    this._email = email;
  }
  @override
  State<CustomerComplain> createState() => _CustomerComplainState();
}

class _CustomerComplainState extends State<CustomerComplain> {
  List<dynamic> _complaints = [];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: const Text('Complaints',style: TextStyle(
          fontFamily: "SpaceGrotesk",
        ),
        ),
        backgroundColor: const Color(0xffce0505),
      ),
      body: FutureBuilder<bool>(
        future: _fetchComplaints(),
        builder: (ctx, snapshot){
          if(snapshot.hasData){
            if(snapshot.data!){
              return ListView.builder(itemBuilder: (ctx, position){
                return Card(
                  color: position % 2 == 0 ? const Color(0xffce0505) : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                    child: Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          Text("Ticket no : ", style: TextStyle(color: position % 2 == 0 ? Colors.white : const Color(0xffce0505)),
                          softWrap: true,
                          ),
                          Text(_complaints[position]["tktno_c"], style: TextStyle(color: position % 2 == 0 ? Colors.white : const Color(0xffce0505)),)
                        ],
                        ),
                        SizedBox(height: 10,),
                        Row(children: <Widget>[
                          Text("Reference no : ",softWrap: true, style: TextStyle(color: position % 2 == 0 ? Colors.white : const Color(0xffce0505)),),
                          Text(_complaints[position]["prncplrefno"],softWrap: true, style: TextStyle(color: position % 2 == 0 ? Colors.white : const Color(0xffce0505)),)
                        ],
                        ),
                        SizedBox(height: 10,),
                        Row(children: <Widget>[
                          Text("Complaint : ", style: TextStyle(color: position % 2 == 0 ? Colors.white : const Color(0xffce0505)),),
                          Expanded(
                            child: Text(_complaints[position]["tktremarks"], style: TextStyle(color: position % 2 == 0 ? Colors.white : const Color(0xffce0505)),),
                            flex: 1,
                          )
                        ],
                        ),
                        SizedBox(height: 10,),
                        Row(children: <Widget>[
                          Text("Customer : ",softWrap: true, style: TextStyle(color: position % 2 == 0 ? Colors.white : const Color(0xffce0505)),),
                          Text(_complaints[position]["sbsname"],softWrap: true, style: TextStyle(color: position % 2 == 0 ? Colors.white : const Color(0xffce0505)),)
                        ],
                        ),
                        SizedBox(height: 10,),
                        Row(children: <Widget>[
                          Text("Status : ",softWrap: true, style: TextStyle(color: position % 2 == 0 ? Colors.white : const Color(0xffce0505)),),
                          Text(_complaints[position]["tktstsid"] != null ? _complaints[position]["tktstsid"] : "O", style: TextStyle(color: position % 2 == 0 ? Colors.white : const Color(0xffce0505)),)
                        ],
                        ),
                      ],
                    ),
                  ),
                );
              },
                itemCount: _complaints.length,
              );
            }
          }
          return Center(
            child: const CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffce0505)),
        onPressed: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
            return UserComplain(widget._email);
          }));
        },
        child: const Text(
            "Complaint"
        ),
      ),
    ), onWillPop: () async{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
        return HomeScreen(widget._email);
      }));
      return true;
    });
  }
  Future<bool> _fetchComplaints() async{
    try{
      print("fetch complains : ${widget._email}");
      var response = await http.get(Uri.http("194.163.154.21:1251", "/ords/fortline/reg/getcmpln", {
        "insby" : widget._email
      }));
      print("complains : ${response.body.toString()}");
      _complaints = (jsonDecode(response.body.toString()))["items"];
      if(_complaints.length > 0) {
        _complaints = _complaints.reversed.toList();
        return true;
      }
    }
    catch(e){
      print("fetchComplaintsError : ${e.toString()}");
    }
    return false;
  }
}
