import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fortline_app/Screen/Invoice_Details_Screen.dart';
import 'package:fortline_app/Screen/Login_Screen.dart';
import 'package:fortline_app/Screen/homescreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'AdsAndMenuTwo.dart';

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
  static bool showAds = true;
  var totalRedeem = 0;
  var totalRebate = 0;
  var amount = 0;
  var invoiceNo = 0;
  var balanceRebate = 0;
  var data;
  Future<bool>? _getFutureData;
  Future<String> _getPath() async{
    print("get path");
    if(Platform.isAndroid) {
      Directory? directory = await getExternalStorageDirectory();

      if (directory != null) {
        print("path: ${directory.path}");
        String directoryPath = directory.path;
        String documentsPath = directoryPath.substring(0, directoryPath.indexOf("/Android"));
        documentsPath = documentsPath;
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
        if(status.isGranted){
          Directory dir = await Directory(documentsPath + "/invoices");
          print("dir PATH ${dir.path}");
          if(await dir.exists()){
            print("dir exists");
            return dir.path;
          }
          else{
            print("creating dir");
            dir = await dir.create(recursive: true);
            return dir.path;
          }
        }
      }
    }
    else if(Platform.isIOS){
      Directory directory = await getApplicationDocumentsDirectory();
      if (directory != null) {
        print("path: ${directory.path}");
        var status = await Permission.storage.status;
        if(!status.isGranted){
          await Permission.storage.request();
        }
        if(status.isGranted){
          return directory.path;
        }
      }
    }
    return "";
}
  Future<bool> _getData() async{
    try{
      var response = await http.get(Uri.http("194.163.154.21:1251","/ords/fortline/reg/invoice",{
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error fetching invoices")));
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("inside dashboard");
    /*if (showAds) {
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
                     height: MediaQuery.of(context).size.height * 90 / 100,
                     width: MediaQuery.of(context).size.width * 90 / 100,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15),

                     ),
                     child: Center(child: Image.memory(image)),
                   ),
                 ],
               ),
             );
           },
               backgroundColor: Colors.transparent,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
           );
          }
        }
        catch(e){
          print(e.toString());
        }
      });
    }*/
      _getFutureData = _getData();
      setState(() {

      });
    }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(child: Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        actions:  <Widget>[
          Padding(padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            icon: Icon(Icons.download,color: Color(0xFF0f388a)),
            onPressed: () async{
              if(data.length > 0) {
                try {
                  final PdfDocument document = PdfDocument();
// Add a new page to the document.
                  final PdfPage page = document.pages.add();
// Create a PDF grid class to add tables.
                  final PdfGrid grid = PdfGrid();
                  grid.columns.add(count: 6);
                  final PdfGridRow headerRow = grid.headers.add(1)[0];
                  headerRow.cells[0].value = 'Invoice ID';
                  headerRow.cells[1].value = 'Invoice Date';
                  headerRow.cells[2].value = 'Invoice Amount';
                  headerRow.cells[3].value = 'Rebate Amount';
                  headerRow.cells[4].value = 'Redeemed Amount';
                  headerRow.cells[5].value = 'Balance Rebate';
                  headerRow.style = PdfGridRowStyle(
                      backgroundBrush: PdfBrushes.dimGray,
                      textPen: PdfPens.lightGoldenrodYellow,
                      textBrush: PdfBrushes.darkOrange,
                      font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
                  PdfGridRow row;
                  grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
                  int reedeemedAmount = 0;
                  int totalBalanceRebate = 0;
                  for (int i = 0; i <= data.length; i++) {
                    row = grid.rows.add();
                    if (i == data.length) {
                      row.cells[0].style = PdfGridCellStyle(borders: PdfBorders(
                          left: PdfPen(PdfColor(255, 255, 255), width: 0),
                          right: PdfPen(PdfColor(255, 255, 255), width: 0),
                          top: PdfPen(PdfColor(255, 255, 255), width: 0),
                          bottom: PdfPen(PdfColor(255, 255, 255), width: 0)));
                      row.cells[1].style = PdfGridCellStyle(borders: PdfBorders(
                          left: PdfPen(PdfColor(255, 255, 255), width: 0),
                          right: PdfPen(PdfColor(255, 255, 255), width: 0),
                          top: PdfPen(PdfColor(255, 255, 255), width: 0),
                          bottom: PdfPen(PdfColor(255, 255, 255), width: 0)));
                      row.cells[2].style = PdfGridCellStyle(borders: PdfBorders(
                          left: PdfPen(PdfColor(255, 255, 255), width: 0),
                          right: PdfPen(PdfColor(255, 255, 255), width: 0),
                          top: PdfPen(PdfColor(255, 255, 255), width: 0),
                          bottom: PdfPen(PdfColor(255, 255, 255), width: 0)));
                      row.cells[3].style = PdfGridCellStyle(borders: PdfBorders(
                          left: PdfPen(PdfColor(255, 255, 255), width: 0),
                          right: PdfPen(PdfColor(255, 255, 255), width: 0),
                          top: PdfPen(PdfColor(255, 255, 255), width: 0),
                          bottom: PdfPen(PdfColor(255, 255, 255), width: 0)));
                      row.cells[4].style = PdfGridCellStyle(borders: PdfBorders(
                          left: PdfPen(PdfColor(255, 255, 255), width: 0),
                          right: PdfPen(PdfColor(255, 255, 255), width: 0),
                          top: PdfPen(PdfColor(255, 255, 255), width: 0),
                          bottom: PdfPen(PdfColor(255, 255, 255), width: 0)));
                      row.cells[5].style = PdfGridCellStyle(borders: PdfBorders(
                          left: PdfPen(PdfColor(255, 255, 255), width: 0),
                          right: PdfPen(PdfColor(255, 255, 255), width: 0),
                          top: PdfPen(PdfColor(255, 255, 255), width: 0),
                          bottom: PdfPen(PdfColor(255, 255, 255), width: 0)));
                      row.cells[2].value = amount.toString();
                      row.cells[3].value = totalRebate.toString();
                      row.cells[4].value = reedeemedAmount.toString();
                      row.cells[5].value = totalBalanceRebate.toString();
                      break;
                    }
                    else if (i % 2 == 0) {
                      row.style = PdfGridRowStyle(
                          backgroundBrush: PdfBrushes.lightGoldenrodYellow,
                          textPen: PdfPens.indianRed,
                          textBrush: PdfBrushes.lightYellow,
                          font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
                    }
                    else {
                      row.style = PdfGridRowStyle(
                          backgroundBrush: PdfBrushes.dimGray,
                          textPen: PdfPens.lightGoldenrodYellow,
                          textBrush: PdfBrushes.darkOrange,
                          font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
                    }
                    var record = data[i];
                    row.cells[0].value = record["invno_c"];
                    String date = record["invdt"];
                    date = date.substring(0, date.indexOf("T"));
                    row.cells[1].value = date;
                    row.cells[2].value = record["invamt"].toString();
                    row.cells[3].value = record["rewrdamt"].toString();
                    var redeemed = record["invstsid"];
                    if (redeemed != null) {
                      reedeemedAmount = record["rewrdamt"] + reedeemedAmount;
                      row.cells[4].value = record["rewrdamt"].toString();
                    }
                    else {
                      row.cells[4].value = "0";
                    }
                    var balanceRebate = record["rewrdamt"] - int.parse(row
                        .cells[4].value);
                    row.cells[5].value = balanceRebate.toString();
                    totalBalanceRebate = balanceRebate + totalBalanceRebate;
                  }
                  grid.draw(
                      page: page,
                      bounds: Rect.fromLTWH(
                          0, 0, page
                          .getClientSize()
                          .width, page
                          .getClientSize()
                          .height));
                  File pdfFile = File((await _getPath()) + "/${DateTime.now()
                      .toString()}_invoices.pdf");
                  await pdfFile.create();
                  pdfFile.writeAsBytes(await document.save());
// Dispose the document.
                  document.dispose();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ledger successfully downloaded",style: TextStyle(
                    fontSize: 16,
                    fontFamily: "SpaceGrotesk",
                    color: Color(0xffce0505),

                  ),
                  ),
                  ),
                  );
                }
                catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not download",style: TextStyle(
                    fontSize: 16,
                    fontFamily: "SpaceGrotesk",
                    color: Color(0xffce0505),

                  ),
                  ),
                  ),
                  );
                }
              }
            },
          ),
          ),

          /*Padding(
            padding: const EdgeInsets.only(right: 5),
            child: DropdownButton(underline: Container() ,icon:const Icon(
              Icons.more_vert,
              color: Colors.white,

            ),
              items: [
                DropdownMenuItem(value: 'Download Invoices',child: Container(child: Row(
                  children: const <Widget>[
                    Icon(Icons.download,color: Color(0xFF0f388a),),

                    SizedBox(width: 8,),

                    Text('Download Invoices',style: TextStyle(
                      fontFamily: "SpaceGrotesk",
                    ),
                    ),
                  ],
                ),),
                ),
                *//*DropdownMenuItem(value: 'logout',child: Container(
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
                ),*//*
              ],
              onChanged: (itemIdentifier) async{
                *//*if(itemIdentifier == 'logout'){
                  showAds = true;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView(),
                  ),
                  );
                }*//*
                if(itemIdentifier == 'Download Invoices'){
                  if(data.length > 0) {
                    final PdfDocument document = PdfDocument();
// Add a new page to the document.
                    final PdfPage page = document.pages.add();
// Create a PDF grid class to add tables.
                    final PdfGrid grid = PdfGrid();
                    grid.columns.add(count: 6);
                    final PdfGridRow headerRow = grid.headers.add(1)[0];
                    headerRow.cells[0].value = 'Invoice ID';
                    headerRow.cells[1].value = 'Invoice Date';
                    headerRow.cells[2].value = 'Invoice Amount';
                    headerRow.cells[3].value = 'Rebate Amount';
                    headerRow.cells[4].value = 'Redeemed Amount';
                    headerRow.cells[5].value = 'Balance Rebate';
                    headerRow.style = PdfGridRowStyle(
                        backgroundBrush: PdfBrushes.dimGray,
                        textPen: PdfPens.lightGoldenrodYellow,
                        textBrush: PdfBrushes.darkOrange,
                        font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
                    PdfGridRow row;
                    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
                    int reedeemedAmount = 0;
                    int totalBalanceRebate = 0;
                    for (int i = 0; i <= data.length; i++) {
                      row = grid.rows.add();
                      if(i == data.length){
                        row.cells[0].style = PdfGridCellStyle(borders: PdfBorders(left: PdfPen(PdfColor(255,255,255),width: 0), right: PdfPen(PdfColor(255,255,255),width: 0), top: PdfPen(PdfColor(255,255,255),width: 0), bottom: PdfPen(PdfColor(255,255,255),width: 0)));
                        row.cells[1].style = PdfGridCellStyle(borders: PdfBorders(left: PdfPen(PdfColor(255,255,255),width: 0), right: PdfPen(PdfColor(255,255,255),width: 0), top: PdfPen(PdfColor(255,255,255),width: 0), bottom: PdfPen(PdfColor(255,255,255),width: 0)));
                        row.cells[2].style = PdfGridCellStyle(borders: PdfBorders(left: PdfPen(PdfColor(255,255,255),width: 0), right: PdfPen(PdfColor(255,255,255),width: 0), top: PdfPen(PdfColor(255,255,255),width: 0), bottom: PdfPen(PdfColor(255,255,255),width: 0)));
                        row.cells[3].style = PdfGridCellStyle(borders: PdfBorders(left: PdfPen(PdfColor(255,255,255),width: 0), right: PdfPen(PdfColor(255,255,255),width: 0), top: PdfPen(PdfColor(255,255,255),width: 0), bottom: PdfPen(PdfColor(255,255,255),width: 0)));
                        row.cells[4].style = PdfGridCellStyle(borders: PdfBorders(left: PdfPen(PdfColor(255,255,255),width: 0), right: PdfPen(PdfColor(255,255,255),width: 0), top: PdfPen(PdfColor(255,255,255),width: 0), bottom: PdfPen(PdfColor(255,255,255),width: 0)));
                        row.cells[5].style = PdfGridCellStyle(borders: PdfBorders(left: PdfPen(PdfColor(255,255,255),width: 0), right: PdfPen(PdfColor(255,255,255),width: 0), top: PdfPen(PdfColor(255,255,255),width: 0), bottom: PdfPen(PdfColor(255,255,255),width: 0)));
                        row.cells[2].value = amount.toString();
                        row.cells[3].value = totalRebate.toString();
                        row.cells[4].value = reedeemedAmount.toString();
                        row.cells[5].value = totalBalanceRebate.toString();
                        break;
                      }
                      else if(i % 2 == 0){
                        row.style = PdfGridRowStyle(
                            backgroundBrush: PdfBrushes.lightGoldenrodYellow,
                            textPen: PdfPens.indianRed,
                            textBrush: PdfBrushes.lightYellow,
                            font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
                      }
                      else{
                        row.style = PdfGridRowStyle(
                            backgroundBrush: PdfBrushes.dimGray,
                            textPen: PdfPens.lightGoldenrodYellow,
                            textBrush: PdfBrushes.darkOrange,
                            font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
                      }
                      var record = data[i];
                      row.cells[0].value = record["invno_c"];
                      String date = record["invdt"];
                      date = date.substring(0, date.indexOf("T"));
                      row.cells[1].value = date;
                      row.cells[2].value = record["invamt"].toString();
                      row.cells[3].value = record["rewrdamt"].toString();
                      var redeemed = record["invstsid"];
                      if(redeemed != null){
                        reedeemedAmount = record["rewrdamt"] + reedeemedAmount;
                        row.cells[4].value = record["rewrdamt"].toString();
                      }
                      else{
                        row.cells[4].value = "0";
                      }
                      var balanceRebate = record["rewrdamt"] - int.parse(row.cells[4].value);
                      row.cells[5].value = balanceRebate.toString();
                      totalBalanceRebate = balanceRebate + totalBalanceRebate;
                    }
                    grid.draw(
                        page: page,
                        bounds: Rect.fromLTWH(
                            0, 0, page.getClientSize().width, page.getClientSize().height));
                    File pdfFile = File((await _getPath()) + "/${DateTime.now().toString()}_invoices.pdf");
                    await pdfFile.create();
                    pdfFile.writeAsBytes(await document.save());
// Dispose the document.
                    document.dispose();
                  }
                }
                else if(itemIdentifier == 'Call') {
                  UrlLauncher.launchUrl(_url);

                }
              },
            ),
          ),*/


        ],
        backgroundColor: const Color(0xffce0505),
        title: const Text('Invoices',style: TextStyle(
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
                      /*const Padding(
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

                      ),*/

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
                                  BoxShadow(color: const Color(0xff7a7979,).withOpacity(0.1)),
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
                                    BoxShadow(color: const Color(0xff7a7979,).withOpacity(0.1)),
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
                                    BoxShadow(color: const Color(0xff7a7979,).withOpacity(0.1)),
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
                                    BoxShadow(color: const Color(0xff7a7979,).withOpacity(0.1)),
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
                                    BoxShadow(color: const Color(0xff7a7979,).withOpacity(0.1)),
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),

    ), onWillPop: () async{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
        return HomeScreen(widget._email);
      }));
      return true;
    });
    }
  }