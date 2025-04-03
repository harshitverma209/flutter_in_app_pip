import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PiPMaterialApp(
      title: 'In App PiP Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'In App PiP Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _startPip() {
    PictureInPicture.startPiP(
      pipWidget: SizedBox(
        width: MediaQuery.of(context).size.width * .7,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            'https://picsum.photos/200/300',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  void _stopPip() {
    PictureInPicture.stopPiP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Item $index'),
              ),
            ),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You clicked on $index'),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FilledButton(
            onPressed: _startPip,
            child: const Text('Start'),
          ),
          FilledButton(
            onPressed: _stopPip,
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
}
