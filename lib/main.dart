import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

void isolateFunc(int finalNum) {
  int _localCount = 0;

  for (int i = 0; i < finalNum; i++) {
    _localCount++;
    if ((_localCount % 100) == 0) {
      print('isolate: $_localCount');
    }
  }
}

int computeFunc(int finalNum) {
  int _localCount = 0;

  for (int i = 0; i < finalNum; i++) {
    _localCount++;
    if ((_localCount % 100) == 0) {
      print('compute: $_localCount');
    }
  }
  return _localCount;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolates Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Isolates Demo',
      ),
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
  int counter = 0;

  @override
  void initState() {
    // Isolate 만들기
    // 실행하고 싶은 함수와 주고 싶은 인자 2가지가 필요하다.
    // 그런데 함수는 클래스 밖에서 생성해야한다. 왜냐하면 main isolate가 앱 전체를 돌릴 것이고 연관되면 안되기 때문에 클래스 밖에서 함수를 생성할 것이다.
    Isolate.spawn(isolateFunc, 1000);
    super.initState();
  }

  Future<void> runCompute() async {
    counter = await compute(computeFunc, 2000);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () async {
                counter++;
                setState(() {});
              },
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('Add in Isolate'),
            ),
          ],
        ),
      ),
    );
  }
}
