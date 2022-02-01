// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'customappbarwidget.dart';

class SharedDataScreen extends StatefulWidget {
  static const routeName = '/SharedData';
  SharedDataScreen({Key? key}) : super(key: key);
  late TabController _tab1;
  late TabController _tab2;
  late TabController _tab3;
  @override
  State<SharedDataScreen> createState() => _SharedDataScreenState();
}

class _SharedDataScreenState extends State<SharedDataScreen>
    with TickerProviderStateMixin {
  int index = 1;

  @override
  void initState() {
    super.initState();
    widget._tab1 = TabController(length: 3, vsync: this);
    widget._tab2 = TabController(length: 3, vsync: this);
    widget._tab3 = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    widget._tab1.dispose();
    widget._tab2.dispose();
    widget._tab3.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        child: CustomAppBar(
          index: index,
          user: user,
          tab1: widget._tab1,
          tab2: widget._tab2,
          tab3: widget._tab3,
        ),
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
              ? MediaQuery.of(context).size.height * 0.153
              : MediaQuery.of(context).size.width * 0.153,
        ),
      ),
      body: index == 1
          ? TabBarView(
              children: const [
                Center(
                  child: Text('Image'),
                ),
                Center(
                  child: Text('Video'),
                ),
                Center(
                  child: Text('Audio'),
                ),
              ],
              controller: widget._tab1,
            )
          : index == 0
              ? TabBarView(
                  children: const [
                    Center(
                      child: Text('Pdf'),
                    ),
                    Center(
                      child: Text('Apk'),
                    ),
                    Center(
                      child: Text('Others'),
                    ),
                  ],
                  controller: widget._tab2,
                )
              : TabBarView(
                  children: const [
                    Center(
                      child: Text('WebAddresses'),
                    ),
                  ],
                  controller: widget._tab3,
                ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).backgroundColor,
          unselectedItemColor: Theme.of(context).iconTheme.color,
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_outlined),
              label: 'Documents',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Media',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.open_in_new_rounded),
              label: 'Others',
            ),
          ],
          onTap: (a) {
            setState(() {
              index = a;
            });
          },
        ),
      ),
    );
  }
}
