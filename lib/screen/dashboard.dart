import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../controller/device_controller.dart';
import '../model/eeg_signal.dart';
import '../util/color_set.dart';
import '../util/enum.dart';
import '../widget/arrow_button.dart';
import '../widget/eeg_line_chart.dart';
import '../widget/rounded_bar_chart.dart';
import '../widget/search_keyword.dart';
import '../widget/text_navigation_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final List<String> barTitles = [
    "M", "T", "W", "T", "F", "S", "S"
  ];

  final List<double> sleepHours = [
    6,7,6,5,8,10,6
  ];

  final List<Color> channelColors = [
    ColorSet.pink,
    ColorSet.blue,
    ColorSet.orange,
    ColorSet.green,
  ];

  final List<String> eegFiles = [
    "EEGCh1.csv",
    "EEGCh2.csv",
    "EEGCh3.csv",
    "EEGCh4.csv",
  ];

  final List<String> storagePaths = [
    "signal/EEGCh1_FDE0401B1592_01.21.46_250.csv",
    "signal/EEGCh2_FDE0401B1592_01.21.46_250.csv",
    "signal/EEGCh3_FDE0401B1592_01.21.46_250.csv",
    "signal/EEGCh4_FDE0401B1592_01.21.46_250.csv",
  ];

  Map<String,List<EegSignal>> eegData = {
    "EEGCh1": [],
    "EEGCh2": [],
    "EEGCh3": [],
    "EEGCh4": [],
  };
  Map<String,List<EegSignal>> graphEegData = {
    "EEGCh1": [],
    "EEGCh2": [],
    "EEGCh3": [],
    "EEGCh4": [],
  };


  bool isNext = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getEEGSignals();
    },);
  }

  Future<void> getEEGSignals()async{
    await Future.forEach(storagePaths, (filePath) async{
      int index = storagePaths.indexOf(filePath);
      eegData["EEGCh${index+1}"] = await makeEEGSignal(filePath, eegFiles[index]);
      },);
    isLoading = false;
    if(mounted){
      setState(() {});
    }
  }

  Future<List<EegSignal>> makeEEGSignal(String filePath,String fileName)async{
    final cacheDir = await getTemporaryDirectory();
    final localFile = File("${cacheDir.path}/$fileName");
    String content= "";
    if(!(await localFile.exists())){
      final storage = FirebaseStorage.instance.ref().child(filePath);
      await storage.writeToFile(localFile);
    }
    content = await localFile.readAsString();
    final List<List> result = const CsvToListConverter(eol: "\n").convert(content);
    return result.map((e) => EegSignal.fromList(List<double>.from(e))).toList();
  }

  void onPressedNext(){
    isNext = true;
    setState(() {});
  }

  void onPressedBefore(){
    isNext = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? const Center(child: CircularProgressIndicator(),) : isNext? eegDetailInfo() : profileInfo();
  }

  Widget eegDetailInfo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...List.generate(eegData.keys.length, (index) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("EEG Channel ${index+1}",
                  style: TextStyle(color: channelColors[index],fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              Expanded(
                child: EegLineChart(eegData: eegData.values.toList()[index],color: channelColors[index],)
              ),
            ],
          ),
        ),),
        const SizedBox(height: 10,),
        DeviceController.to.device.value == DeviceEnum.phone? TextNavigationButton(
          title: "BEFORE",
          onPressed: onPressedBefore,
        ) :
        ArrowButton(icon: Icons.arrow_back_ios_new_outlined, onPressed: onPressedBefore)
      ],
    );
  }

  Widget profileInfo(){
    if (DeviceController.to.device.value == DeviceEnum.phone) {
      return SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SearchKeyword(),
          const SizedBox(height: 15,),
          Row(
            children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle
                  ),
                  child: Image.asset(
                    "asset/brain.png",
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  )
              ),
              const Expanded(child: Center(
            child: Text.rich(
                    TextSpan(
                        text: "",
                        style: TextStyle(color: ColorSet.black,fontSize: 20),
                        children: [
                          TextSpan(
                            text:
                            "Patient "
                                "",
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          TextSpan(
                              text: "John Bob",
                              style: TextStyle(fontWeight: FontWeight.w400)
                          )
                        ]
                    )
                ),
              ))
            ],
          ),
          SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 5),
                child: Row(
                  children: [
                    Expanded(child: Column(
                      children: [
                        patientDetailInfo(title: "Sex", content: "Male"),
                        patientDetailInfo(title: "Age", content: "32"),
                        patientDetailInfo(title: "Blood", content: "B+"),

                      ],
                    )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            patientDetailInfo(title: "Birth", content: "25 Oct, 1990"),
                            patientDetailInfo(title: "Disease", content: "Stroke"),
                            patientDetailInfo(title: "Check in", content: "15 Dec, 2023"),
                          ],
                        )),
                  ],
                ),
              )),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ColorSet.blackOpacity300
                  ),
                  color: ColorSet.white,
                ),
                child: const Row(
                  children: [
                    Text("PULSE",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Text("110",style: TextStyle(fontSize: 18,)),
                    SizedBox(width: 10,),
                    Text("BPM",style: TextStyle(fontSize: 16,color: ColorSet.blackOpacity300)),
                  ],
                ),
              ),
              const SizedBox(width: 10,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: ColorSet.blackOpacity300
                  ),
                  color: ColorSet.white,
                ),
                child: const Row(
                  children: [
                    Text("WEIGHT",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Text("80",style: TextStyle(fontSize: 18,)),
                    SizedBox(width: 10,),
                    Text("Kg",style: TextStyle(fontSize: 16,color: ColorSet.blackOpacity300)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 30,),
          const Text("Weekly Sleeping Hours",style: TextStyle(fontWeight: FontWeight.bold,color: ColorSet.black,fontSize: 22),),
          const SizedBox(height: 30,),
          SizedBox(
            height: 220,
            child: RoundedBarChart(
              titles: barTitles,
              yData: sleepHours,
            ),
          ),
          TextNavigationButton(
            title: "NEXT",
            onPressed: onPressedNext,
          )
        ],
            ),
      );
    } else {
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
             const SearchKeyword(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: IconButton(
                icon: const Icon(Icons.notifications,size: 30,color: ColorSet.violet500,),
                onPressed: (){},
              ),
            ),
            Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Image.asset("asset/person.png"),
            ),
            const SizedBox(width: 10,),
            const Text("Dr. Justin Joe",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
            IconButton(onPressed: (){}, icon: const Icon(Icons.keyboard_arrow_down))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: SizedBox(
            height: 200,
            child: Row(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle
                          ),
                          child: Image.asset(
                            "asset/brain.png",
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          )
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text.rich(
                        TextSpan(
                            text: "",
                            style: TextStyle(color: ColorSet.black,fontSize: 20),
                            children: [
                              TextSpan(
                                text:
                                "Patient "
                                    "",
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                              TextSpan(
                                  text: "John Bob",
                                  style: TextStyle(fontWeight: FontWeight.w400)
                              )
                            ]
                        )
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 450,
                      child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        children: [
                          Expanded(child: Column(
                            children: [
                              patientDetailInfo(title: "Sex", content: "Male"),
                              patientDetailInfo(title: "Age", content: "32"),
                              patientDetailInfo(title: "Blood", content: "B+"),

                            ],
                          )),
                          Expanded(
                            flex: 2,
                            child: Column(
                            children: [
                              patientDetailInfo(title: "Birth", content: "25 Oct, 1990"),
                              patientDetailInfo(title: "Disease", content: "Stroke"),
                              patientDetailInfo(title: "Check in", content: "15 Dec, 2023"),
                            ],
                          )),
                        ],
                      ),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Expanded(
          child: Row(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                child: Column(
                  children: [
                    const Text("Weekly Sleeping Hours",style: TextStyle(fontWeight: FontWeight.bold,color: ColorSet.black,fontSize: 22),),
                    const SizedBox(height: 30,),
                    Expanded(
                      child: RoundedBarChart(
                        titles: barTitles,
                        yData: sleepHours,
                      ),
                    ),
                  ],
                ),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  bioDataInfo(
                      title: "Pulse",
                      icon: FontAwesomeIcons.heartPulse,
                      value: "110",
                      unit: "BPM"
                  ),
                  const SizedBox(height: 15,),
                  bioDataInfo(
                      title: "Weight",
                      icon: FontAwesomeIcons.weightScale,
                      value: "80",
                      unit: "KG"
                  ),
                  const Spacer(),
                  ArrowButton(
                    icon: Icons.arrow_forward_ios,
                    onPressed: onPressedNext
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    }
  }

  Widget patientDetailInfo({required String content,required String title}){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(title,style: const TextStyle(color: ColorSet.violet500,fontWeight: FontWeight.w600,fontSize: 20),),
            const SizedBox(width: 25,),
            Text(content,style: const TextStyle(color: ColorSet.black,fontWeight: FontWeight.w600,fontSize: 20),),
          ],
        ),
      ),
    );
  }

  Widget bioDataInfo({required String title,required IconData icon,required String value,required String unit}){
    return Container(
      width: 170,
      height: 120,
      decoration: BoxDecoration(
          color: ColorSet.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: ColorSet.blackOpacity300,
              width: 0.7
          )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 27),),
              Icon(icon,color: ColorSet.orange,size: 25,)
            ],
          )),
          Expanded(child: Text.rich(TextSpan(
              text: value,
              style: const TextStyle(fontSize: 29,fontWeight: FontWeight.w600,),
              children: [
                TextSpan(
                    text: " $unit",
                    style: const TextStyle(fontSize: 18,color: ColorSet.blackOpacity300,)
                )
              ]
          )))
        ],
      ),
    );
  }

}
