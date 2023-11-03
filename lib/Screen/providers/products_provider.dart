import 'package:flutter/material.dart';

class ProductsProvider extends ChangeNotifier{
  List<Map<String, dynamic>> _productCategories = [];
  bool fetchAndAddProducts(){
    print("fetching products");
    try{
      _productCategories.add({
        "category" : "Laptop",
        "products" : ["hp", "dell", "lenovo"]
      });
      _productCategories.add({
        "category" : "Generator",
        "products" : ["honda", "jasco", "yamaha"]
      });
     notifyListeners();
     return true;
    }
    catch(e){
      print(e.toString());
    }
    return false;
  }
  List<Map<String, dynamic>> get getProductCategories{
    return [..._productCategories];
  }
}