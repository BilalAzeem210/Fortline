import 'package:flutter/material.dart';
import 'package:fortline_customer_app/Screen/Login_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                            const Text('SignUp',
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
                                        if(val!.length < 6){
                                          return "Please provide a password of atleast 6 character";
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
                             try {
                               if (_formState.currentState!.validate()) {
                                  _isLoading = true;
                                  setState(() {

                                  });
                                 final userCred = await _auth.createUserWithEmailAndPassword(
                                   email: _email,
                                   password: _password,
                                 );
                                 FirebaseFirestore.instance.collection('Customers').add({
                                   'Customer_Id' : DateTime.now().toString(),
                                   'Customer_Name' : _name,
                                   'Customer_Status' : true,
                                   'Email' : _email,
                                   'Mobile_No' : mobileNo,
                                   'Pass' : _password,
                                   'Registration_Time' : DateTime.now(),

                                 });
                                 print("signup successful");
                                setState(() {
                                  _isLoading = false;
                                });
                               }

                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Register Successfully Login First',style: TextStyle(
                                 color: Colors.red,
                               ),),
                               ),
                               );
                             }
                             catch(e){
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Failed',style: TextStyle(
                                 color: Colors.red,
                               ),),
                               ),
                               );
                               setState(() {
                                 _isLoading = false;
                               });
                               print(e.toString());
                             }
                            },child: Container(
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
  void _validateAdmin(){
    bool isValid = _formState.currentState!.validate();
    if(isValid){
      _formState.currentState!.save();
    }
  }
}
