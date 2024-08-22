
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Todo(),
  )
);

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List toDolist = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTodoList();
  }

  void addItem(String item) {
    setState(() {
      toDolist.add([item, false]);
    });
    saveTodoList();
    Navigator.of(context).pop();
  }

  void deleteItem(int index) {
    setState(() {
      toDolist.removeAt(index);
    });
    saveTodoList();
  }

  void toggleCheckbox(bool? value, int index) {
    setState(() {
      toDolist[index][1] = value;
    });
    saveTodoList();
  }

  Future<void> saveTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('toDolist', jsonEncode(toDolist));
  }

  Future<void> loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todoString = prefs.getString('toDolist');
    if (todoString != null) {
      setState(() {
        toDolist = jsonDecode(todoString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 44, 14, 134),
      ),
      backgroundColor: Color.fromARGB(255, 146, 101, 225),
      body: ListView.builder(
        itemCount: toDolist.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Dismissible(
              key: Key(toDolist[index][0]),
              onDismissed: (direction) {
                deleteItem(index);
              },
              background: Container(
                decoration: BoxDecoration(
                   color: Colors.red,
                   borderRadius: BorderRadius.circular(15)
                ),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 92, 44, 175),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        toDolist[index][0],
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Checkbox(
                      value: toDolist[index][1],
                      onChanged: (value) {
                        toggleCheckbox(value, index);
                      },
                      activeColor: Colors.white,
                      checkColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.clear();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Todo'),
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Enter todo item'),
                ),
                actions: <Widget>[


TextButton(
                    onPressed: () {
                      _controller.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        addItem(_controller.text);
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 44, 14, 134),
      ),
    );
  }
}
