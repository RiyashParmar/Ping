// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    Key? key,
    required this.index,
    required this.user,
    required this.tab1,
    required this.tab2,
    required this.tab3,
  }) : super(key: key);
  final int index;
  final String user;
  final TabController tab1;
  final TabController tab2;
  final TabController tab3;
  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<CustomAppBar> with TickerProviderStateMixin {
  bool search = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: search != true
          ? Text(widget.user)
          : const TextField(
              autofocus: true,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              search == true ? search = false : search = true;
            });
          },
          icon: const Icon(Icons.search_sharp),
        ),
      ],
      bottom: widget.index == 1
          ? TabBar(
              labelColor: Theme.of(context).iconTheme.color,
              indicatorColor: Theme.of(context).iconTheme.color,
              controller: widget.tab1,
              tabs: const [
                Tab(
                  icon: Icon(Icons.image),
                  text: 'Image',
                ),
                Tab(
                  icon: Icon(Icons.video_collection),
                  text: 'Video',
                ),
                Tab(
                  icon: Icon(Icons.speaker_rounded),
                  text: 'Audio',
                ),
              ],
            )
          : widget.index == 0
              ? TabBar(
                  labelColor: Theme.of(context).iconTheme.color,
                  indicatorColor: Theme.of(context).iconTheme.color,
                  controller: widget.tab2,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.picture_as_pdf),
                      text: 'Pdf',
                    ),
                    Tab(
                      icon: Icon(Icons.apps),
                      text: 'Apk',
                    ),
                    Tab(
                      icon: Icon(Icons.margin_sharp),
                      text: 'Others',
                    ),
                  ],
                )
              : TabBar(
                  labelColor: Theme.of(context).iconTheme.color,
                  indicatorColor: Theme.of(context).iconTheme.color,
                  controller: widget.tab3,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.link),
                      text: 'WebAddresses',
                    ),
                  ],
                ),
    );
  }
}
