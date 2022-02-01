import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);
  static const routeName = '/Search';
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<bool> isselected = [false, false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: const TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size(media.size.width, sp * 0.15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InputChip(
                    backgroundColor: Theme.of(context).backgroundColor,
                    shadowColor: Theme.of(context).iconTheme.color,
                    selectedShadowColor: Theme.of(context).iconTheme.color,
                    avatar: const Icon(Icons.image),
                    selected: isselected[0],
                    showCheckmark: true,
                    selectedColor: Theme.of(context).primaryColor,
                    label: const Text(
                      'Image',
                    ),
                    elevation: 5,
                    onPressed: () => setState(() {
                      isselected[0] = !isselected[0];
                    }),
                  ),
                  InputChip(
                    backgroundColor: Theme.of(context).backgroundColor,
                    shadowColor: Theme.of(context).iconTheme.color,
                    selectedShadowColor: Theme.of(context).iconTheme.color,
                    avatar: const Icon(Icons.videocam),
                    selected: isselected[1],
                    showCheckmark: true,
                    selectedColor: Theme.of(context).primaryColor,
                    label: const Text(
                      'Video',
                    ),
                    elevation: 5,
                    onPressed: () => setState(() {
                      isselected[1] = !isselected[1];
                    }),
                  ),
                  InputChip(
                    backgroundColor: Theme.of(context).backgroundColor,
                    shadowColor: Theme.of(context).iconTheme.color,
                    selectedShadowColor: Theme.of(context).iconTheme.color,
                    avatar: const Icon(Icons.audiotrack),
                    selected: isselected[2],
                    showCheckmark: true,
                    selectedColor: Theme.of(context).primaryColor,
                    label: const Text(
                      'Audio',
                    ),
                    elevation: 5,
                    onPressed: () => setState(() {
                      isselected[2] = !isselected[2];
                    }),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InputChip(
                    backgroundColor: Theme.of(context).backgroundColor,
                    shadowColor: Theme.of(context).iconTheme.color,
                    selectedShadowColor: Theme.of(context).iconTheme.color,
                    avatar: const Icon(Icons.link),
                    selected: isselected[3],
                    showCheckmark: true,
                    selectedColor: Theme.of(context).primaryColor,
                    label: const Text(
                      'Link',
                    ),
                    elevation: 5,
                    onPressed: () => setState(() {
                      isselected[3] = !isselected[3];
                    }),
                  ),
                  InputChip(
                    backgroundColor: Theme.of(context).backgroundColor,
                    shadowColor: Theme.of(context).iconTheme.color,
                    selectedShadowColor: Theme.of(context).iconTheme.color,
                    avatar: const Icon(Icons.file_copy),
                    selected: isselected[4],
                    showCheckmark: true,
                    selectedColor: Theme.of(context).primaryColor,
                    label: const Text(
                      'Documents',
                    ),
                    elevation: 5,
                    onPressed: () => setState(() {
                      isselected[4] = !isselected[4];
                    }),
                  ),
                  InputChip(
                    backgroundColor: Theme.of(context).backgroundColor,
                    shadowColor: Theme.of(context).iconTheme.color,
                    selectedShadowColor: Theme.of(context).iconTheme.color,
                    avatar: const Icon(Icons.message),
                    selected: isselected[5],
                    showCheckmark: true,
                    selectedColor: Theme.of(context).primaryColor,
                    label: const Text(
                      'Text',
                    ),
                    elevation: 5,
                    onPressed: () => setState(() {
                      isselected[5] = !isselected[5];
                    }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
