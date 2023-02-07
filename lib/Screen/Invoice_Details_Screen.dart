import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fortline_customer_app/Screen/Customer_Details_Screen.dart';
import 'package:fortline_customer_app/Screen/Login_Screen.dart';

class InvoiceDetailScreen extends StatefulWidget {
  const InvoiceDetailScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {

  User? _currentUser;
  List<Map<String,dynamic>> res = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future <List<Map<String,dynamic>?>> getData() async{

    var cust_Id;
   var firstCollection = await FirebaseFirestore.instance.collection('Invoice').get();
   var secondCollection = await FirebaseFirestore.instance.collection('Customers').get();

    var customer = secondCollection.docs;
    print("Customer: $customer");
    for(int i = 0 ; i < customer.length; i++ ){
      var record = customer[i].data();
      if(record['Email'] == _auth.currentUser!.email){
        cust_Id = customer[i].reference.id;
        print("Customer Id: $cust_Id");
        break;
      }
    }

   var invoices = firstCollection.docs;
   for(int i = 0; i < invoices.length; i++)
   {
    var record = invoices[i].data();
    if(cust_Id == record["Customer_Id"]){
      res.add(record);
      print("Invoice Data : $res");

    }

   }
   return res;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Invoice',style: TextStyle(
          fontFamily: "SpaceGrotesk",
        ),),
      backgroundColor: const Color(0xffce0505),
      ),
      body: SafeArea(
          child: Column(
            children:  [
              const SizedBox(height: 10,),
              Flexible(
                flex: 1,
                child: FutureBuilder<List<Map<String,dynamic>?>>(
                  future: getData(),
                  builder: (context,snapshot){
                  if(snapshot.hasData){
                    print("inside future");
                    print(snapshot.data);
                    return ListView.builder(
                       itemCount: res.length,
                        itemBuilder: (ctx, index){
                          return  InkWell(
                            onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDetailsScreen(record: snapshot.data![index]!,),));
                            },
                            child:  Card(

                              child: ListTile(
                               title:  Text('Inv: ${snapshot.data![index]!['Invoice_No']}',style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  fontFamily: "SpaceGrotesk",
                                ),),
                                 trailing: Text('Rebate: ${snapshot.data![index]!['Rebate']}',style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  fontFamily: "SpaceGrotesk",
                                ),),
                              ),),
                           );
                        }
                        );
                  }
                  else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffce0505),
                      ),
                    );
                  }
  },

                ),
              ),

            ],
          ),
        ),

    );
  }
}
