import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fortline_app/Screen/Login_Screen.dart';
import 'package:http/http.dart' as http;
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formState = GlobalKey<FormState>();
  final _hidePassword = ValueNotifier<bool>(true);
  bool _isLoading = false;
  String _name = "";
  int? mobileNo ;
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {


    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child:Container(
          decoration: const BoxDecoration(
            gradient:  LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                0.1,
                0.6,
                0.9,
              ],
              colors: [
                Color(0xffc9c7c7),
                Color(0xfff2f2f2),
                Color(0xffc9c7c7),

              ],
            ),
          ),

            child: Column(

              children: <Widget>[

                Flexible(flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Flexible(flex: 1,child: Image(
                          image: AssetImage("assets/images/FortLine.png"),
                        ),),
                      ],
                    )),

                SingleChildScrollView(
                  child: SizedBox(
                    width: screenWidth * 100 / 100,
                    height: screenHeight * 55 / 100,

                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),elevation: 10,
                      child: Form(key: _formState,
                        child: Column(

                          children: <Widget>[
                            const SizedBox(height: 10,),
                            const Text('Sign Up',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,

                              ),
                              textAlign: TextAlign.start,),
                            const SizedBox(height: 10,),
                            Flexible(flex: 1,child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15,),
                              child: TextFormField(
                                validator: (val){
                                  if(val!.isEmpty ){
                                    return "Please Enter Name";
                                  }
                                  return null;
                                },
                                onSaved: (val){
                                  _name = val!;
                                },
                                decoration: InputDecoration(
                                    hintText: "Name",
                                    fillColor: const Color(0xfff6f7fa),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xfff6f7fa)),
                                        borderRadius: BorderRadius.circular(15)
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xfff6f7fa)
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    )
                                ),
                              ),
                            ),
                            ),
                            const SizedBox(height: 10,),
                            Flexible(flex: 1,child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15,),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (val){
                                  if(val!.isEmpty){
                                    return "Please Enter Mobile No";
                                  }
                                },
                                onSaved: (val){
                                  mobileNo = int.parse(val!);
                                },
                                decoration: InputDecoration(
                                    hintText: "MobileNo",
                                    fillColor: const Color(0xfff6f7fa),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xfff6f7fa)),
                                        borderRadius: BorderRadius.circular(15)
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xfff6f7fa)
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    )
                                ),
                              ),),
                            ),
                            const SizedBox(height: 10,),
                            Flexible(flex: 1,child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15,),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                validator: (val){
                                  if(val!.isEmpty || !val.contains("@")){
                                    return "Please provide valid email";
                                  }
                                },
                                onSaved: (val){
                                  _email = val!;
                                },
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    fillColor: const Color(0xfff6f7fa),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xfff6f7fa)),
                                        borderRadius: BorderRadius.circular(15)
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xfff6f7fa)
                                        ),
                                        borderRadius: BorderRadius.circular(15)
                                    )
                                ),
                              ),),
                            ),
                            const SizedBox(height: 10,),
                            Flexible(flex: 1,child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: _hidePassword,
                                  builder: (ctx, value, child){
                                    return TextFormField(
                                      onSaved: (val){
                                        _password = val!;
                                      },
                                      validator: (val){
                                        if(val!.length < 3){
                                          return "Please provide a password of atleast 3 character";
                                        }
                                      },
                                      obscureText: _hidePassword.value,
                                      obscuringCharacter: "*",
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        suffixIcon: IconButton(icon: _hidePassword.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility), onPressed: (){
                                          _hidePassword.value = !_hidePassword.value;
                                        },),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xfff6f7fa)),
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xfff6f7fa)),
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xfff6f7fa),
                                      ),
                                    );
                                  },
                                ),
                            ),
                            ),
                            const SizedBox(height: 20,),
                            Flexible(flex: 1,
                              child: InkWell(
                                onTap: () async{
                              _validateAdmin();

                            },
                                child: Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(color: const Color(0xfff75a27),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(blurRadius: 1.0, offset: Offset(1, 5), color: Colors.black12)
                                  ]
                              ),
                              child: _isLoading ? const Center(child: CircularProgressIndicator( color: Colors.white,)) : const Center(child: Text("SignUp", style: TextStyle(
                                  color: Colors.white
                              ),
                              ),
                              ),
                            ),
                            ),
                            ),
                            const SizedBox(height: 5,),
                            TextButton(onPressed: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView(),
                              ),
                              );
                            },
                                child: const Text('Already Have an Account? LogIn', style: TextStyle(color: Color(0xfff75a27)),))

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),


    );
  }
  void _validateAdmin() async{
    bool isValid = _formState.currentState!.validate();
    if(isValid){
      _formState.currentState!.save();
      _isLoading = true;
      setState(() {

      });
      try{
        print("inside try");
        String? Token;
        var response = await http.post(Uri.http("194.163.154.21:1251","/ords/fortline/reg/post")
            ,headers: <String,String>{
              'Content-Type': 'application/json; charset=UTF-8',
            }
           , body:jsonEncode(<String,String?>{
              "usrname" : _name.toUpperCase(),
              "insby" : _email,
              "password" : _password,
              "mobile" : mobileNo.toString(),
              "token" : Token
            })
        );

        print(response.statusCode);
        var responseData = jsonDecode(response.body.toString());
        if(responseData.containsKey("successMsg")){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: const Color(0xfff75a27),content: Text(responseData["successMsg"], style:  const TextStyle(
            color: Colors.white,
          ),
          ),
          ),
          );
        }
        else if(responseData.containsKey("msg")) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: const Color(0xfff75a27),content: Text(
            responseData["msg"],
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          ),
          );
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Color(0xfff75a27),content: Text(
            "You are already registered",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          ),
          );
        }


        _isLoading = false;
        setState(() {

        });
        print("signup");
        //print(responseData);
      }
      catch(e){
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),style: const TextStyle(
          color: Color(0xffce0505),
        ),)));
        _isLoading = false;
        setState(() {

        });
      }
    }
  }
}
