import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fortline_customer_app/Screen/Invoice_Details_Screen.dart';
import 'package:fortline_customer_app/Screen/Login_Screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  late String _email;
  DashboardScreen(String email){
    this._email = email;
  }
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String,dynamic>> res = [];
  final Uri _url = Uri.parse('tel://021111992999');
  //final number = '+923342242836';
  static bool showAds = true;
  var totalRedeem = 0;
  var totalRebate = 0;
  var amount = 0;
  var invoiceNo = 0;
  var balanceRebate = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  var data;
  Future<bool>? _getFutureData;
  static const int maxFailedLoadAttempts = 3;

  /*void _createInterstitialAd() async{
    await InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-4101133175325037/2788711604'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: AdRequest(
          contentUrl: "https://myshop.pk/pub/media/catalog/product/cache/26f8091d81cea4b38d820a1d1a4f62be/m/i/microsoft-surface-laptop-go2-myshop-3_1_1.jpg"
        ),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            _showInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        showAds = false;
        setState(() {
          _getFutureData = _getData();
        });
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
      *//*onAdClicked: (InterstitialAd ad){
        ad.dispose();
      }*//*
    );
    _interstitialAd!.show();
  }*/
  Future<bool> _getData() async{
/*
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

    return res;*/
    try{
      var response = await http.get(Uri.http("142.132.194.26:1251","/ords/fortline/reg/invoice",{
        "insby" : widget._email
      }));
      print(jsonDecode(response.body.toString()).toString());
      if(response.statusCode == 200){
        var responseData = jsonDecode(response.body.toString())["items"];
        data = responseData;
        print("invoices");
        print(responseData.toString());
        invoiceNo = data.length;
        print("totinv: ${invoiceNo}");
        for(int i = 0; i < data.length; i++){
          amount = data[i]["invamt"] + amount;
          if(data[i]["rewrdamt"] != null){
            totalRebate = data[i]["rewrdamt"] + totalRebate;
            String? status = data[i]["invstsid"];
            if(status != null){
              totalRedeem = data[i]["rewrdamt"] + totalRedeem;
            }
          }
        }
        balanceRebate = totalRebate - totalRedeem;
      }
      return true;
    }
    catch(e){
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error fetching invoices")));
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("inside dashboard");
    if(showAds) {
      var image;
      Future.delayed(Duration.zero, () async{
        try{
          var response = await http.get(Uri.http("142.132.194.26:1251","/ords/fortline/reg/notification"));
          var responseData = jsonDecode(response.body.toString());
          if(responseData["items"][0]["contents_blob"] != null){
           image = base64Decode(responseData["items"][0]["contents_blob"]);
           showModalBottomSheet(isScrollControlled: true,context: context, builder: (ctx){
             return SizedBox(
               height: MediaQuery.of(context).size.height * 96 / 100,
               child: Column(
                 children: <Widget>[
                   Container(
                     width: double.infinity,

                     child: Stack(
                       alignment: Alignment.topRight,
                       children: <Widget>[

                         Ink(
                           child: InkWell(
                             onTap: (){
                               print("circle");
                               showAds = false;
                               Navigator.of(context).pop();
                             },
                             child: Container(

                               width: 25,
                               height: 25,
                               child: Icon(
                                 Icons.close,
                                 size: 25,
                                 color: Colors.white,
                               ),
                               decoration: BoxDecoration(
                                   color: Colors.black,
                                   borderRadius: BorderRadius.circular(60)
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                   SizedBox(height: 15,),
                   Container(
                     height: 300,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15),

                     ),
                     child: Center(child: Image.memory(image)),
                   ),
                 ],
               ),
             );
           },
               backgroundColor: Color(0xffce0505).withOpacity(0.6),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
           );
          }
        }
        catch(e){
          print(e.toString());
        }
      });
    }
    _getFutureData = _getData();
    setState(() {

      });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:  Colors.white,
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
              ],
              onChanged: (itemIdentifier) {
                if(itemIdentifier == 'logout'){
                  showAds = true;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView(),
                  ),
                  );
                }
                else if(itemIdentifier == 'Call') {
                        UrlLauncher.launchUrl(_url);

                }
                },
            ),
          ),


        ],
          backgroundColor: const Color(0xffce0505),
          title: const Text('Dashboard',style: TextStyle(
            fontFamily: "SpaceGrotesk",
          ),
          ),
      ),
      body:
      SingleChildScrollView(
        child: SafeArea(

          child: FutureBuilder<bool>(
            future: _getFutureData,
            builder: (ctx, snapshot){
              if(snapshot.hasData){
                if(snapshot.data!){
                   return Column(
                     children:  [
                       const SizedBox(height: 10,),
                       const Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Align(
                           alignment: Alignment.topLeft,
                           child: Text('WELCOME',style: TextStyle(
                             fontWeight: FontWeight.w700,
                             color: Colors.black,
                             fontSize: 30,
                             fontFamily: "SpaceGrotesk",
                           ),
                           ),
                         ),

                       ),

                       const SizedBox(height: 10,),
                       Padding(
                         padding: const EdgeInsets.all(6.0),
                         child: InkWell(
                           onTap: (){
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InvoiceDetailScreen(widget._email)));
                           },
                           child: Container(
                             height: screenHeight * 20 / 100,
                             width: screenWidth * 100 / 100,
                             decoration: BoxDecoration(
                                 boxShadow:  [
                                   BoxShadow(color: Color(0xff7a7979,).withOpacity(0.1)),
                                 ],
                                 borderRadius: BorderRadius.circular(20)
                             ),
                             child: Card(
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(15)
                               ),
                               elevation: 5,
                               color: Colors.white70,
                               child: Center(
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     const SizedBox(height: 8,),
                                     Image.asset("assets/images/invoices3.png"),
                                     const Text('Total Invoices',style: TextStyle(
                                       fontWeight: FontWeight.w300,
                                       fontSize: 18,
                                       fontFamily: "SpaceGrotesk",
                                       color: Colors.black,
                                     ),
                                     ),
                                     Text(NumberFormat.decimalPattern().format(invoiceNo),style: const TextStyle(
                                       fontWeight: FontWeight.w300,
                                       fontSize: 18,
                                       fontFamily: "SpaceGrotesk",
                                       color: Colors.black,
                                     ),
                                     ),
                                   ],
                                 ),
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
                               height: screenHeight * 23 / 100,
                               width: screenWidth * 45 / 100,
                               decoration: BoxDecoration(
                                   boxShadow:  [
                                     BoxShadow(color: Color(0xff7a7979,).withOpacity(0.1)),
                                   ],
                                   borderRadius: BorderRadius.circular(20)
                               ),
                               child: Card(
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(15),
                                 ),
                                 elevation: 5,
                                 color: Colors.white70,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     const SizedBox(height: 7,),
                                     Image.asset("assets/images/discount.png"),
                                     const Text('Total Rebate',style: TextStyle(
                                       fontWeight: FontWeight.w300,
                                       fontSize: 18,
                                       fontFamily: "SpaceGrotesk",
                                       color: Colors.black,
                                     ),
                                     ),
                                     Text(NumberFormat.decimalPattern().format(totalRebate),style: const TextStyle(
                                       fontWeight: FontWeight.w300,
                                       fontSize: 18,
                                       fontFamily: "SpaceGrotesk",
                                       color: Colors.black,
                                     ),
                                     ),

                                   ],
                                 ),
                               ),
                             ),
                             const SizedBox(width: 20,),
                             Container(
                               height: screenHeight * 23 / 100,
                               width: screenWidth * 45 / 100,
                               decoration: BoxDecoration(
                                   boxShadow:  [
                                     BoxShadow(color: Color(0xff7a7979,).withOpacity(0.1)),
                                   ],
                                   borderRadius: BorderRadius.circular(20)
                               ),
                               child: Card(
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(15),
                                 ),
                                 elevation: 5,
                                 color: Colors.white70,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     const SizedBox(height: 7,),
                                     Image.asset("assets/images/rupees.png"),
                                     const Text('Total Amount',style: TextStyle(
                                       fontWeight: FontWeight.w300,
                                       fontSize: 18,
                                       fontFamily: "SpaceGrotesk",
                                       color: Colors.black,
                                     ),
                                     ),
                                     Text(NumberFormat.decimalPattern().format(amount),style: const TextStyle(
                                       fontWeight: FontWeight.w300,
                                       fontSize: 18,
                                       fontFamily: "SpaceGrotesk",
                                       color: Colors.black,
                                     ),
                                     ),

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
                               height: screenHeight * 23 / 100,
                               width: screenWidth * 45 / 100,
                               decoration: BoxDecoration(
                                   boxShadow:  [
                                     BoxShadow(color: Color(0xff7a7979,).withOpacity(0.1)),
                                   ],
                                   borderRadius: BorderRadius.circular(20)
                               ),
                               child: Card(
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(15),
                                 ),
                                 elevation: 5,
                                 color: Colors.white70,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     const SizedBox(height: 7,),
                                     Image.asset("assets/images/giftredeem.png"),
                                     const Text('Total Redeem',style: TextStyle(
                                       fontWeight: FontWeight.w300,
                                       fontSize: 18,
                                       fontFamily: "SpaceGrotesk",
                                       color: Colors.black,
                                     ),
                                     ),
                                     Text(NumberFormat.decimalPattern().format(totalRedeem),style: const TextStyle(
                                       fontWeight: FontWeight.w300,
                                       fontSize: 18,
                                       fontFamily: "SpaceGrotesk",
                                       color: Colors.black,
                                     ),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                             const SizedBox(width: 20,),
                             Container(
                               height: screenHeight * 23 / 100,
                               width: screenWidth * 45 / 100,
                               decoration: BoxDecoration(
                                   boxShadow:  [
                                     BoxShadow(color: Color(0xff7a7979,).withOpacity(0.1)),
                                   ],
                                   borderRadius: BorderRadius.circular(20)
                               ),
                               child: Card(
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(15),
                                 ),
                                 elevation: 5,
                                 color: Colors.white70,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     const SizedBox(height: 7,),
                                     Image.asset("assets/images/balancerebate.png"),
                                     const Text('Balance Rebate',style: TextStyle(
                                       fontWeight: FontWeight.w300,
                                       fontSize: 18,
                                       fontFamily: "SpaceGrotesk",
                                       color: Colors.black,
                                     ),
                                     ),
                                     Text(NumberFormat.decimalPattern().format(balanceRebate),style: const TextStyle(
                                       fontWeight: FontWeight.w300,
                                       fontSize: 18,
                                       fontFamily: "SpaceGrotesk",
                                       color: Colors.black,
                                     ),
                                     ),

                                   ],
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ],
                   );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),

    );
  }
}
