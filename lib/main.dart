import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Bot",
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
          duration: 1000,
          splash: Image.asset("assets/botpng.png"),
          splashTransition: SplashTransition.fadeTransition,

          nextScreen: myhomepage(),

          backgroundColor: Colors.lightBlue,
      ) ,
    );
  }
}

class myhomepage extends StatefulWidget {
  const myhomepage({Key key}) : super(key: key);

  @override
  _myhomepageState createState() => _myhomepageState();
}

class _myhomepageState extends State<myhomepage> {


  final messageController = TextEditingController();
  List<Map> messages = new List();


  void response(query) async {
    AuthGoogle authGoogle = await AuthGoogle( fileJson: 'assets/services.json' ).build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language:  Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messages.insert(0, {"data": 0, "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()});
    });
    print(aiResponse.getListMessage()[0]['text']['text'][0].toString());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.indigo,
        leading: Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/botimg.png"),
          ),
        ),
        title: Text("Chat Bot"),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children:<Widget>[
            Container(
              width: double.infinity,

              decoration: BoxDecoration(
                  color: Colors.indigo,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                )
              ),
              padding: EdgeInsets.only(top: 15,bottom: 10),
              child: Center(
                child: Text("Today, ${DateFormat("Hm").format(DateTime.now())}"
                ),
              ),
            ),

            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) => chat(
                    messages[index]["message"].toString(),
                    messages[index]["data"]),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Divider(
              height: 5,
              color: Colors.blueGrey,
            ),
            Container(
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: IconButton(
                    icon: Icon(Icons.forum ,color: Colors.indigo,size: 35,),
                  ),
                ),
                title: Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.indigo,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0.0,left: 10.0, ),
                      child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Enter a message",
                          hintStyle: TextStyle(
                            color: Colors.black87,
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        onChanged: (value){

                        },
                      ),
                    ),
                  ),
                ),
                trailing: IconButton(
                  onPressed: (){
                    if(messageController.text.isEmpty){
                      print("Empty Message");
                    }
                    else{
                      setState(() {
                        messages.insert(0, {"data": 1, "message" : messageController.text});
                      });

                      response(messageController.text);
                      messageController.clear();
                    }
                    FocusScopeNode currentfocus = FocusScope.of(context);
                    if(!currentfocus.hasPrimaryFocus){
                      currentfocus.unfocus();
                    }
                  },
                  icon: Icon(Icons.send,color: Colors.greenAccent,),
                  iconSize: 30,
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data)
  {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0 ? Container(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/botimg.png"),
            ),
          ) : Container(),



          Padding(padding: EdgeInsets.all(10.0),
            child: Bubble(
              radius: Radius.circular(15.0),
              color: data == 0 ? Color.fromRGBO(23, 157, 139, 1) : Colors.orangeAccent,
              elevation: 0.0,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children:<Widget> [
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data == 1 ? Container(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/user-male.png'),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}


