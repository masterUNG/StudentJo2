import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentjo/bodys/profile_body.dart';
import 'package:studentjo/bodys/test_body.dart';
import 'package:studentjo/bodys/video_body.dart';
import 'package:studentjo/utility/app_controller.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  var titles = <String>[
    'Video',
    'Test',
    'Profile',
  ];

  var iconDatas = <IconData>[
    Icons.videocam,
    Icons.text_snippet,
    Icons.person,
  ];

  var bodys = <Widget>[
    const VideoBody(),
    const TestBody(),
    const ProfileBody(),
  ];

  var items = <BottomNavigationBarItem>[];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < titles.length; i++) {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(iconDatas[i]),
          label: titles[i],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          return Scaffold(
            body: SafeArea(child: bodys[appController.indexBody.value]),
            bottomNavigationBar: BottomNavigationBar(backgroundColor: Colors.grey.shade300,
              items: items,
              currentIndex: appController.indexBody.value,
              onTap: (value) {
                appController.indexBody.value = value;
              },
            ),
          );
        });
  }
}
