import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fortline_customer_app/Screen/Dashboard_Screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'SignUp_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  static String email = "";
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  static const int maxFailedLoadAttempts = 3;
  final _formState = GlobalKey<FormState>();
  final _hidePassword = ValueNotifier<bool>(true);
  bool _isLoading = false;
  String _email = "";
  String _password = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
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
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
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
               const SizedBox(
                  height: 20,
                ),
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
                            height: screenHeight * .50,

                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),elevation: 10,
                            child: Form(key: _formState,
                              child: Column(

                                children: <Widget>[
                                 const SizedBox(height: 10,),
                                  const Text('Login',
                                 style: TextStyle(
                                   fontSize: 25,
                                   fontWeight: FontWeight.bold,

                                 ),
                                 textAlign: TextAlign.start,),
                                  const SizedBox(height: 10,),
                                  Flexible(flex: 1,child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15,),
                                    child: TextFormField(
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Please provide valid username";
                                        }
                                        return null;
                                      },
                                      onSaved: (val){
                                        _email = val!;
                                        LoginView.email = _email;
                                      },
                                      keyboardType: TextInputType.text,
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
                                  )
                                  ,
                                  const SizedBox(height: 20,),
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
                                                return "Please provide a password of least 3 character";
                                              }
                                              return null;
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
                                      )))
                                  ,
                                  const SizedBox(height: 30,),
                                  Flexible(flex: 1,child: InkWell(
                                    onTap: (){
                                    _validateAdmin();
                                  /*try{
                                    if(_formState.currentState!.validate()){
                                      _isLoading = true;
                                      setState(() {

                                      });
                                      final userCredential = await _auth.signInWithEmailAndPassword(
                                          email: _email,
                                          password: _password
                                      );
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen(),
                                      ),
                                      );
                                      print("sigin successful");
                                      setState(() {
                                        _isLoading = false;
                                      });

                                    }

                                  }
                                      catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please Enter Correct User Credential Or SignUp', style: TextStyle(
                                    color: Colors.red,
                                    ),
                                    ),
                                    ),
                                    );
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    print(e.toString());
                                      }*/


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
                                    child: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white,)) : const Center(child: Text("Login", style: TextStyle(
                                        color: Colors.white
                                    ),),),
                                  ),
                                  ),
                                  ),
                                  const SizedBox(height: 10,),

                                  Flexible(
                                    flex: 1,
                                    child: InkWell(onTap: (){
                                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),),);
                                  },
                                    child: Container(
                                    width: 150,
                                    height: 35,
                                    decoration: BoxDecoration(color: const Color(0xfff75a27),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(blurRadius: 1.0, offset: Offset(1, 5), color: Colors.black12)
                                        ]
                                    ),
                                    child: const Center(child: Text("SignUp", style: TextStyle(
                                        color: Colors.white
                                    ),),),
                                  ),
                                  ),
                                  )

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
      try {
        var response = await http.get(
            Uri.http("142.132.194.26:1251", "/ords/fortline/reg/cstreg", {
              "insby": _email,
              "password": _password
            }));
        print("email: ${_email}");
        print("response");
        print(jsonDecode(response.body.toString()));
        var record = jsonDecode(response.body.toString());
        if (record["items"].length == 0) {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: const Color(0xfff75a27),
              content: Text("Please enter correct credientials", style: TextStyle(
                color: Colors.white,
              ),)));
          setState(() {

          });
        }
        else {
          var usrName = record["items"][0]["insby"];
          var userPassword = record["items"][0]["password"];
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashboardScreen(_email),
            ),
          );
          /*if(usrName == _userName && _password == userPassword){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(_userName),
          ),
          );
        }*/
        }
      }
      catch(e){
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: const Color(0xfff75a27),
            content: Text("Could not login",style: TextStyle(
          color: Colors.white,
        ),)));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}