import 'package:flutter/material.dart';

class CustomerDetailsScreen extends StatefulWidget {
  Map<String,dynamic> record;

  CustomerDetailsScreen({required this.record});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: AppBar(
        title:  const Text('Invoice Details',style: TextStyle(
          fontFamily: "SpaceGrotesk",
        ),),
        backgroundColor: const Color(0xffce0505),
      ),
      body: Column(
        children: [
          Card(
            child: SizedBox(
              height: screenHeight * 40 / 100,
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
                          child: Text('${widget.record['Invoice_Date']}',style: const TextStyle(
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
                          child: Text('${widget.record['Invoice_No']}',style: const TextStyle(
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
                          child: Text('${widget.record['Invoice_Amount']}',style:const TextStyle(
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
                          child: Text('${widget.record['Rebate']}',style:const TextStyle(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(onPressed: (){},

                              child: const Text('By Cash',style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffce0505),
                                fontFamily: "SpaceGrotesk",

                              ),))
                        ),

                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(onPressed: (){},
                            child: const Text('By Adjustment',style: TextStyle(
                              fontSize: 16,
                              fontFamily: "SpaceGrotesk",
                              color: Color(0xffce0505),

                            ),))
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

        ],
      )
    );
  }
}
