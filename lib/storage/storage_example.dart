import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StorageExample extends StatefulWidget {
  const StorageExample({Key? key}) : super(key: key);

  @override
  State<StorageExample> createState() => _StorageExampleState();
}

class _StorageExampleState extends State<StorageExample> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<String> paths = [
    "asset/EEGCh1_FDE0401B1592_01.21.46_250.csv",
    // "asset/EEGCh2_FDE0401B1592_01.21.46_250.csv",
    // "asset/EEGCh3_FDE0401B1592_01.21.46_250.csv",
    // "asset/EEGCh4_FDE0401B1592_01.21.46_250.csv",
  ];

  List<String> channels = [
    "Ch1",
    // "EEGCh2",
    // "EEGCh3",
    // "EEGCh4",
  ];

  @override
  void initState() {
    super.initState();
  }

  void saveChannels()async{
    await Future.forEach(paths, (path) async{
      int index = paths.indexOf(path);
      List<List<dynamic>> csvFile = await readCsvFile(path);
      await uploadCsvDataWithBatch(csvFile, channels[index]);
      print("실행 완료: $index");
    },);
  }


  Future<List<List>> readCsvFile(String filePath) async {
    final input = await rootBundle.loadString(filePath);
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(eol: "\n").convert(input);
    return rowsAsListOfValues;
  }

  Future<void> uploadCsvDataWithBatch(List<List<dynamic>> csvData, String collectionName) async {
    final firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    for (int i = 0; i < csvData.length; i++) {
      final row = csvData[i];
      final docRef = firestore.collection(collectionName).doc();
      batch.set(docRef, {
        'time': row[0],
        'value': row[1],
      });

      // Firestore의 배치 제한: 한 번에 500개까지
      if (i % 500 == 0) {
        await batch.commit();
        batch = firestore.batch(); // 새로운 배치 생성
      }
    }

    // 남은 데이터 커밋
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: saveChannels,
          child: Text("onPress"),
        ),
      ),
    );
  }
}