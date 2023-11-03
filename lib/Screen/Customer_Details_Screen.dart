import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fortline_app/Screen/Invoice_Details_Screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class CustomerDetailsScreen extends StatefulWidget {
  Map<String,dynamic> record;
  String customerName;
  CustomerDetailsScreen({super.key, required this.record, required this.customerName});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  TextEditingController commentsController = TextEditingController();
  var statuss;
  _CustomerDetailsScreenState(){

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("customer details init");
  }
  Future<void> _updateStatus(String? status) async{

    try{
      var response = await http.put(Uri.http("194.163.154.21:1251","/ords/fortline/reg/paysts"),headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: jsonEncode(<String, String?>{
        "invstsid" : status,
        "invno_c" : widget.record['invno_c'],
        "comments": commentsController.text
      }));
      widget.record["invstsid"] = status;
      setState(() {

      });
      print("status : $status");
      print("invid : ${widget.record['invno_c']}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully updated",style: TextStyle(
        fontSize: 16,
        fontFamily: "SpaceGrotesk",
        color: Color(0xffce0505),

      ),
      ),
      ),
      );
    }
    catch(e){
      print("put error");
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not update",style: TextStyle(
        fontSize: 16,
        fontFamily: "SpaceGrotesk",
        color: Color(0xffce0505),

      ),
      ),
      ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("customer details : ${widget.record["invstsid"]}");
    statuss = widget.record["invstsid"];
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var formattedDate =  DateFormat('dd-MM-yyyy');
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
          return InvoiceDetailScreen(widget.customerName);
        }));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
          title:  const Text('Invoice Details',style: TextStyle(
            fontFamily: "SpaceGrotesk",
          ),),
          backgroundColor: const Color(0xffce0505),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: SizedBox(
                  height: screenHeight * 90 / 100,
                  width: screenWidth * 100 / 100,

                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text('Date:',style:TextStyle(
                                fontSize: 16,
                                fontFamily: "SpaceGrotesk",
                              ),),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(formattedDate.format(DateTime.parse(widget.record['invdt'])) ,style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "SpaceGrotesk",
                              ),),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text('Invoice No:',style:TextStyle(
                                fontSize: 16,
                                fontFamily: "SpaceGrotesk",
                              ),),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text('${widget.record['invno_c']}',style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "SpaceGrotesk",
                              ),),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           const Align(
                              alignment: Alignment.topLeft,
                              child: Text('Invoice Amount:',style:TextStyle(
                                fontSize: 16,
                                fontFamily: "SpaceGrotesk",
                              ),),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(NumberFormat.decimalPattern().format(widget.record['invamt']),style:const TextStyle(
                                fontSize: 16,
                                fontFamily: "SpaceGrotesk",
                              ),),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text('Rebate:',style:TextStyle(
                                fontSize: 16,
                                fontFamily: "SpaceGrotesk",
                              ),),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text('${widget.record['rewrdamt'] != null ? NumberFormat.decimalPattern().format(widget.record['rewrdamt']) : 0}',style:const TextStyle(
                                fontSize: 16,
                                fontFamily: "SpaceGrotesk",
                              ),),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6,),
                       const Padding(
                         padding: EdgeInsets.all(6.0),
                         child: Align(
                           alignment: Alignment.topLeft,
                           child: Text('Redeem By:',style: TextStyle(
                             fontSize: 16,
                             fontFamily: "SpaceGrotesk",

                           ),),
                         ),
                       ) ,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                              Align(
                                alignment: Alignment.topLeft,
                                child: ElevatedButton(
                                  onPressed: widget.record['rewrdamt'] == null || widget.record['invstsid'] != null  ? null : (){
                                    _updateStatus("C");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffce0505),
                                  ),
                                  child: const Text('By Cash',style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: "SpaceGrotesk",

                                  ),),
                                )  ,
                              ),

                            Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                onPressed: widget.record['rewrdamt'] == null || widget.record['invstsid'] != null ? null :(){
                                  _updateStatus("A");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffce0505),
                                ),
                                child: const Text('By Adjustment',style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: "SpaceGrotesk",

                                ),),
                              )  ,
                            ),
                          ],
                        ),

                      ),

                      const SizedBox(height: 10,),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: commentsController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Comments",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide( color: Color(0xffce0505) ),
                            ),
                          ),

                        ),
                      ),
                      const SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffce0505),
                            ),
                            onPressed: (){
                              print("Comments : ${commentsController.text}");
                              _updateStatus(statuss);
                            },
                            child: const Text('Submit',style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: "SpaceGrotesk",

                            ),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

            ],
          ),
        )
      ),
    );
  }

}
