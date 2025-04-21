import 'package:flutter/material.dart';
import 'package:sheetable/sheetable_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(title: Text('data')),
        bottomSheet: SheetableWidget(
          contentBuilder: (scrollController) {
            return ListView.builder(
              controller: scrollController,
              itemCount: 20,
              itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
            );
          },
          onSheetHidden: () => print('Sheet hidden'),
        ),
      ),
    );
  }
}
