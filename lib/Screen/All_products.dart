import 'package:flutter/material.dart';
import 'package:fortline_app/Screen/products.dart';
import 'package:fortline_app/Screen/providers/products_provider.dart';
import 'package:provider/provider.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({Key? key}) : super(key: key);

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  var _productsProvider;
  List<Map<String, dynamic>> productsData = [];
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 0), (){
      print("inside");
      _productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      if(!(_productsProvider.fetchAndAddProducts())){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Could not fetch products",style: TextStyle(
          fontSize: 16,
          fontFamily: "SpaceGrotesk",
          color: Color(0xffce0505),
        ),
        )));
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _productsProvider = Provider.of<ProductsProvider>(context);
    productsData = _productsProvider.getProductCategories;
    return Scaffold(
      appBar: AppBar(
        title: Text("All Products"),
      ),
      body: productsData.length == 0 ? Center(child: Text("Loading"),) : ListView.builder(itemBuilder: (ctx, position){
        return Padding(padding: EdgeInsets.only(top: 10),
        child: Container(
            color: Colors.green,
            height: MediaQuery.of(context).size.height * 0.4
            ,child: Column(
          children: <Widget>[
            Padding(child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 2))
              ),
              child: Text(productsData[position]["category"], style: TextStyle(
                fontSize: 30
              ),),
            ),
              padding: EdgeInsets.all(10),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(child: ListView.builder(itemBuilder: (ctx, index){
              return InkWell(
                onTap: (){
                  print("product tap");
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                    return Products("Ali@gmail.com");
                  }));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.3,
                    height: MediaQuery.of(context).size.height * 0.4 * 0.99,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/ups.jpg"
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
                                  Text(productsData[position]["products"][index],style: TextStyle(
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
              );
            },
              scrollDirection: Axis.horizontal,
              itemCount: productsData[position]["products"].length,
            ),
            )
          ],
        )
        ),
        );
      },
      itemCount: productsData.length,
      ),
    );
  }
}
