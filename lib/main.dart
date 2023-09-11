import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String initialUrl = 'https://app.bmneis.com/login.html'; // Replace with your desired URL

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'Web View App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Web View'),
        ),
        body: Center(
          child: FutureBuilder<bool>(
            future: checkInternetConnection(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Loading indicator while checking the internet connection
              } else {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  bool isConnected = snapshot.data ?? false;
                  if (isConnected) {
                    return SafeArea(
                      child: WebviewScaffold(
                        url: initialUrl,
                      ),
                    );
                  } else {
                    return Text('No internet connection');
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false; // No internet connection
  } else {
    return true; // Internet connection is available
  }
}