import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: sp * 0.04,
                bottom: sp * 0.02,
              ),
              child: GestureDetector(
                child: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: sp * 0.1,
                  ),
                  radius: sp * 0.09,
                ),
              ),
            ),
            ListTile(
              title: const Text('Name'),
              subtitle: TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).iconTheme.color as Color),
                  ),
                  hintText: 'My Name',
                  hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2!.color),
                ),
              ),
            ),
            ListTile(
              title: const Text('Phone'),
              subtitle: TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).iconTheme.color as Color),
                  ),
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2!.color),
                ),
              ),
            ),
            ListTile(
              title: const Text('Anecdote'),
              subtitle: TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).iconTheme.color as Color),
                  ),
                  hintText: 'Describe yourself',
                  hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2!.color),
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
