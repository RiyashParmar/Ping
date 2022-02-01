import 'package:flutter/material.dart';

class Broadcast extends StatefulWidget {
  const Broadcast({Key? key, required this.user}) : super(key: key);
  final List user;
  @override
  State<Broadcast> createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('New Broadcast'),
            Text(
              'Enter details',
              style: TextStyle(
                fontSize: sp * 0.017,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: media.size.width,
              height: sp * 0.16,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(sp * 0.02),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: sp * 0.035,
                            child: Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                        SizedBox(width: sp * 0.03),
                        SizedBox(
                          width: sp * 0.75,
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).iconTheme.color
                                        as Color),
                              ),
                              label: const Text('Broadcast Name'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: sp * 0.03,
                      top: sp * 0.01,
                    ),
                    child: Row(
                      children: const [
                        Text('Give a broadcast name and a broadcast image'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: sp * 0.002),
            Text(
              'Selected:- ${widget.user.length} (Tap to remove)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: media.size.width,
              height: (sp * 0.6) - MediaQuery.of(context).viewInsets.bottom,
              child: Padding(
                padding: EdgeInsets.all(sp * 0.008),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemCount: widget.user.length,
                  itemBuilder: (ctx, i) {
                    return GridTile(
                      child: SizedBox(
                        width: sp * 0.2,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.user.removeAt(i);
                                });
                              },
                              child: CircleAvatar(
                                child: const Icon(Icons.person),
                                radius: sp * 0.03,
                              ),
                            ),
                            SizedBox(height: sp * 0.01),
                            Text(
                              widget.user[i].name,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.user.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.check),
            )
          : null,
    );
  }
}
