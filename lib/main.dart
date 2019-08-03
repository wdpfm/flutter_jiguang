import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String debugLable='Unknown';
  final JPush jPush=new JPush();
  @override
  void initState() {
    super.initState();
  }
  Future<void> initPlatformState() async{
    String platformVersion;
    try{
      jPush.addEventHandler(
        onReceiveNotification: (Map<String,dynamic> message) async{
          print('flutter接收到推送:${message}');
          setState(() {
            debugLable='接收到推送:${message}';
          });
        }
      );
    }on PlatformException{
      platformVersion='平台版本获取失败';
    }
    if(!mounted)return;//没有错误就返回
    setState(() {
      debugLable=platformVersion;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('极光推送'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('结果${debugLable}'),
              RaisedButton(
                child: Text('发送推送信息'),
                onPressed: (){
                  var fireDate=DateTime.fromMillisecondsSinceEpoch(
                    DateTime.now().millisecondsSinceEpoch+1000
                  );
                  var localNotification=LocalNotification(
                    id: 234,
                    title: '推送标题',
                    buildId: 1,
                    content: '推送内容',
                    fireTime: fireDate,
                    subtitle: '推送子标题'
                  );
                  jPush.sendLocalNotification(localNotification).then((res){
                    setState(() {
                      debugLable=res;
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
