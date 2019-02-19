import 'package:flutter/material.dart';

class Codes extends StatefulWidget {
  @override
  _CodesState createState() => _CodesState();
}

class _CodesState extends State<Codes> {

  List<String> eventsCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    //itemCount: (events == null ? 0 : events.length),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      const Padding(padding: EdgeInsets.all(16.0));
                      return InkWell(
                          onTap: () => setState(() {}),
                          child: ListTile(
                            //title: Text(events[index]),
                          )
                      );
                    }
                ),
              ),
            ],
          ),
        )
    );
  }
}
