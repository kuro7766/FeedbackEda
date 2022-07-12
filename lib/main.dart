import 'dart:convert';
import 'dart:io';

// import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_feedback/simple_http.dart';
import 'package:flutter_app_feedback/simple_http_builder.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FeedBack',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,

      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key,  this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


  // String text;

  var files = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ()async{
      final manifestJson = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
      files = json.decode(manifestJson).keys.where((String key) => key.startsWith('assets/')).toList();
      // print(files);

      // text = await loadAsset();
      setState(() {

      });
    }();
  }
  Future<String> loadAsset(file) async {
    return await rootBundle.loadString(file);
  }
  // void _incrementCounter() async{
  //
  //
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Container(
        color: Colors.black,
        child:
        ListView.separated(itemBuilder: (c,i){
          return SimpleFutureBuilder(
            loadingWidget: ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 500.0,
              ),
              child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator()))),
            ),
            future: ()async{
              return ResponseContent.success(await loadAsset(files[i]));
            }(),
            builder: (snap) {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text('${i} of ${files.length}',style: TextStyle(color: Colors.grey),),
                  ),

                  HtmlWidget(
                    snap??'error',
                    textStyle: TextStyle(color: Colors.grey),
                  ),

                ],
              );
            }
          );
        },itemCount: files.length,separatorBuilder: (c,i){
          return Container(color: Colors.grey,height: 2,);
        },)

      )// This trailing comma makes auto-formatting nicer for build methods.
      ,floatingActionButton: FloatingActionButton(
      child: Icon(Icons.shuffle),
      tooltip: 'shuffle data',
      onPressed: (){
        files.shuffle();
        setState(() {

        });
      },
    ),
    );
  }
}
