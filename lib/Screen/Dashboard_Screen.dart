import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fortline_customer_app/Screen/Invoice_Details_Screen.dart';
import 'package:fortline_customer_app/Screen/Login_Screen.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String,dynamic>> res = [];
  final Uri _url = Uri.parse('tel://+923342242836');
  final number = '+923342242836';

  var totalRebate = 0;
  var amount = 0;
  var invoiceNo = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<List<Map<String,dynamic>>> getData() async{

    var cust_Id;
    var firstCollection = await FirebaseFirestore.instance.collection('Invoice').get();
    var secondCollection = await FirebaseFirestore.instance.collection('Customers').get();

    var customer = secondCollection.docs;
    print("Customer: ${customer}");
    for(int i = 0 ; i < customer.length; i++ ){
      var record = customer[i].data();
      if(record['Email'] == _auth.currentUser!.email){
        cust_Id = customer[i].reference.id;
        print("Customer Id: ${cust_Id}");
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
        totalRebate = record['Rebate'] + totalRebate;
        amount = record['Invoice_Amount'] + amount;
        invoiceNo++;

      }

    }
    print("TotalRebate:$totalRebate");
    print("TotalAmount:$amount");
    print("Totalinvoice: $invoiceNo");

    return res;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero,() async{
      await getData();
      setState(() {

      });
    });


  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffce0505),
      appBar: AppBar(
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
                    ),),
                  ],
                ),),
                ),

                DropdownMenuItem(value: 'logout',child: Container(child: Row(
                  children: const <Widget>[
                    Icon(Icons.exit_to_app,color: Color(0xFF0f388a),),

                    SizedBox(width: 8,),

                    Text('logout',style: TextStyle(
                      fontFamily: "SpaceGrotesk",
                    ),),
                  ],
                ),),
                ),
              ],
              onChanged: (itemIdentifier) {
                if(itemIdentifier == 'logout'){
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView(),
                  ),
                  );
                }
                else if(itemIdentifier == 'Call') {
                        UrlLauncher.launchUrl(_url);

                }
                },),
          ),


        ],
          backgroundColor: const Color(0xffce0505),
          title: const Text('Dashboard',style: TextStyle(
            fontFamily: "SpaceGrotesk",
          ),),
      ),
      body:
      SingleChildScrollView(
        child: SafeArea(

          child: Column(
            children:  [
             const SizedBox(height: 15,),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('WELCOME',style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: "SpaceGrotesk",
                    ),),
                  ),
                ),
              const SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(6.0),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const InvoiceDetailScreen()));
                  },
                  child: Container(
                    height: screenHeight * 18 / 100,
                    width: screenWidth * 100 / 100,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.red),
                          ],
                          borderRadius: BorderRadius.circular(20)
                        ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      elevation: 5,
                      color: Colors.black26,
                      child: Column(
                        children: [
                         const SizedBox(height: 8,),
                          Image.asset("assets/images/rebate.png"),
                          const Text('Total Rebate',style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                            fontFamily: "SpaceGrotesk",
                            color: Colors.white,
                          ),),
                        Text(totalRebate.toString(),style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          fontFamily: "SpaceGrotesk",
                          color: Colors.white,
                        ),
                        ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                      Container(
                        height: screenHeight * 20 / 100,
                        width: screenWidth * 45 / 100,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.red),
                            ],
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        color: Colors.black26,
                        child: Column(
                          children: [
                            const SizedBox(height: 15,),
                            Image.asset("assets/images/invoiceicon2.png"),
                            const Text('Total Invoices',style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              fontFamily: "SpaceGrotesk",
                              color: Colors.white,
                            ),),
                            Text(invoiceNo.toString(),style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              fontFamily: "SpaceGrotesk",
                              color: Colors.white,
                            ),)
                          ],
                        ),
                      ),
                      ),
                    const SizedBox(width: 20,),
                    Container(
                      height: screenHeight * 20 / 100,
                      width: screenWidth * 45 / 100,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.red),
                          ],
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        color: Colors.black26,
                        child: Column(
                          children: [
                            const SizedBox(height: 15,),
                            Image.asset("assets/images/amounticon.png"),
                            const Text('Total Amount',style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              fontFamily: "SpaceGrotesk",
                              color: Colors.white,
                            ),),
                            Text(amount.toString(),style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              fontFamily: "SpaceGrotesk",
                              color: Colors.white,
                            ),)

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    Container(
                      height: screenHeight * 20 / 100,
                      width: screenWidth * 45 / 100,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.red),
                          ],
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        color: Colors.black26,
                        child: Column(
                          children: [
                            const SizedBox(height: 15,),
                            Image.asset("assets/images/redeemicon.png"),
                            const Text('Total Redeem',style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              fontFamily: "SpaceGrotesk",
                              color: Colors.white,
                            ),),
                            const Text('20,000',style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              fontFamily: "SpaceGrotesk",
                              color: Colors.white,
                            ),)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Container(
                      height: screenHeight * 20 / 100,
                      width: screenWidth * 45 / 100,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.red),
                          ],
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        color: Colors.black26,
                        child: Column(
                          children: [
                            const SizedBox(height: 15,),
                            Image.asset("assets/images/balanceicon.png"),
                            const Text('Balance Rebate',style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              fontFamily: "SpaceGrotesk",
                              color: Colors.white,
                            ),),
                            const Text('0',style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              fontFamily: "SpaceGrotesk",
                              color: Colors.white,
                            ),)

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
