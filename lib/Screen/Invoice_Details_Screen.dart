import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fortline_app/Screen/Customer_Details_Screen.dart';
import 'package:fortline_app/Screen/Dashboard_Screen.dart';
import 'package:http/http.dart' as http;
class InvoiceDetailScreen extends StatefulWidget {
  String _email = "";
  dynamic _invoiceData = [];
  InvoiceDetailScreen(String userName){
    this._email = userName;
  }
  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  List<Map<String,dynamic>> res = [];



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
          return DashboardScreen(widget._email);
        }));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customer Invoice',style: TextStyle(
            fontFamily: "SpaceGrotesk",
          ),
          ),
        backgroundColor: const Color(0xffce0505),
        ),
        body: SafeArea(
            child: FutureBuilder<bool>(
              builder: (ctx, snapshot){
                if(snapshot.hasData){
                  if(snapshot.data!){
                    return Column(
                      children:  [
                        const SizedBox(height: 10,),
                        Flexible(
                          flex: 1,
                          child: ListView.builder(
                              itemCount: widget._invoiceData.length,
                              itemBuilder: (ctx, index){
                                return  InkWell(
                                  onTap: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomerDetailsScreen(record: widget._invoiceData[index]!, customerName: widget._email),));
                                  },
                                  child:  Card(

                                    child: ListTile(
                                      title:  Text('Inv: ${widget._invoiceData[index]['invno_c']}',style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        fontFamily: "SpaceGrotesk",
                                      ),
                                      ),
                                      trailing: Text('RedeemedBy: ${widget._invoiceData[index]['invstsid'] != null ? widget._invoiceData[index]['invstsid'] : "-"}' ,style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        fontFamily: "SpaceGrotesk",
                                      ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                          ),

                        ),

                      ],
                    );
                  }
                }
                return const Center(child: CircularProgressIndicator(),);
              },
              future: _getData(),
            ),
          ),

      ),
    );
  }
  Future<bool> _getData() async{
    try{
      //print("getting invoices invoice details:");
      var response = await http.get(Uri.http("194.163.154.21:1251","/ords/fortline/reg/invoice",{
        "insby" : widget._email
      }));
      print(jsonDecode(response.body.toString()).toString());
      if(response.statusCode == 200){
        var responseData = jsonDecode(response.body.toString())["items"];
        widget._invoiceData = responseData;
      }
      return true;
    }
    catch(e){
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error fetching invoices"),
      ),
      );
    }
    return false;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("invoice Details:");

  }
}
