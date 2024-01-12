import 'dart:io';
import 'package:flutter/material.dart';
import 'de_helper.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // theme: ThemeData.dark(),
    home: NoteApp(),
  ));
}

class NoteApp extends StatefulWidget {
  const NoteApp({super.key});

  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  TextEditingController tController = TextEditingController();
  TextEditingController dController = TextEditingController();

  List titles = [];

  void getNotes() async {
    final data = await DbHelper.getAll();
    setState(() {
      titles = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Note App",
          style: TextStyle(fontSize: 35),
        ),
        centerTitle: true,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color.fromARGB(255, 86, 86, 86),
                      content: Text(
                        "Have a nice day!",
                      ),
                    ),
                  );
                  exit(0);
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.redAccent,
                  size: 35,
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 15.0, bottom: 30.0, right: 30.0, left: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              autofocus: true,
              style: TextStyle(color: Color.fromARGB(255, 2, 174, 59)),
              controller: tController,
              decoration: InputDecoration(
                icon: Icon(Icons.title),
                // hintText: "Title...",
                border: InputBorder.none,
                filled: true,
                fillColor: Color.fromARGB(51, 97, 97, 97),
              ),
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              controller: dController,
              decoration: InputDecoration(
                hintStyle:
                    TextStyle(color: const Color.fromARGB(255, 136, 136, 136)),
                hintText: "Description...",
                filled: true,
                fillColor: Color.fromARGB(35, 117, 117, 117),
                border: InputBorder.none,
              ),
              maxLines: 6,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.only(left: 170, right: 170, top: 10, bottom: 10),
                ),
              ),
              onPressed: () async {
                int result = await DbHelper.addNote(
                    title: tController.text, description: dController.text);
                if (result >= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Note added seccessfully!")));
                  tController.clear();
                  dController.clear();
                  getNotes();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.save,
                    color: Colors.green,
                    size: 25,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 23, 22, 22),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1.5,
              height: 35,
              indent: 65,
              endIndent: 65,
              color: const Color.fromARGB(255, 82, 82, 82),
            ),
            Text(
              "Your Note",
              style: TextStyle(fontSize: 25),
            ),
            Divider(
              thickness: 1.5,
              height: 20,
              indent: 65,
              endIndent: 65,
              color: const Color.fromARGB(255, 82, 82, 82),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: titles.length,
                  itemBuilder: (_, i) {
                    return Card(
                      child: ListTile(
                        title: Text("${titles[i]["title"]}"),
                        subtitle: Text("${titles[i]["description"]}"),
                        trailing: Row(
                          children: [
                            Text("${titles[i]["date"]}"),
                            IconButton(
                                onPressed: () {
                                  showEditBox(titles[i]["id"], titles[i]["title"], titles[i]["description"]);
                                },
                                icon: Icon(Icons.edit))
                          ],
                        ),
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Icon(
                                    Icons.delete,
                                    size: 35,
                                  ),
                                  content: Text("Do you want to delete?"),
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () {
                                          DbHelper.deleteInfo(titles[i]["id"]);
                                          getNotes();
                                          Navigator.pop(context);
                                        },
                                        child: Text("YES")),
                                    OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("NO")),
                                  ],
                                );
                              });
                        },
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void showEditBox(int id , String title, String description) {
    setState(() {
      tController.text = title;
      dController.text = description;
    });
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Edit Note"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              TextField(
                autofocus: true,
                style: TextStyle(color: Color.fromARGB(255, 2, 174, 59)),
                controller: tController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  label: Text("Title"),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                autofocus: true,
                style: TextStyle(color: Color.fromARGB(255, 2, 174, 59)),
                controller: dController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  label: Text("Description"),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ]),
            actions: [
              OutlinedButton(onPressed: () async {
                await DbHelper.updateInfo(id: id, title: tController.text, description: dController.text);
                Navigator.pop(context);
                getNotes();
              }, child: Text("UPDATE")),
              OutlinedButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("CANCEL")),
            ],
          );
        });
  }
}
