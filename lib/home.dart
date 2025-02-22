import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> tasks = [];
  bool showActiveTask = true;

  TextEditingController _taskController = TextEditingController();

  void showTaskDialouge({int? index}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Text("Add Tasks"),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            controller: _taskController,
            // keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Task",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")),
          // add button
          ElevatedButton(
            onPressed: () {
              _addTask(_taskController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: Text(
              "Add",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        tasks.add({"Task": task, "completed": false});
      });
      _taskController.clear(); // Clear the input field
    }
  }

  void _toggleTaskStatus(int index) {
    setState(() {
      tasks[index]["completed"] = !tasks[index]["completed"];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  int get activeCount => tasks.where((task) => !task['completed']).length;
  int get completedCOunt => tasks.where((task)=>task["completed"]).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text("Todo"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          //blurStyle: BlurStyle.outer,
                        )
                      ]),
                  child: Column(
                    children: [
                      Text(
                        "Active",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        activeCount.toString(),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          //blurStyle: BlurStyle.outer,
                        )
                      ]),
                  child: Column(
                    children: [
                      Text(
                        "Completed",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        completedCOunt.toString(),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(UniqueKey().toString()), // Ensure unique keys
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10),
                    color: Colors.greenAccent,
                    child: Icon(Icons.done, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      _toggleTaskStatus(index);
                    } else {
                      _deleteTask(index);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3,left: 5,bottom: 1,right: 5,),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          tasks[index]["Task"],
                          style: TextStyle(
                            fontSize: 16,
                            decoration: tasks[index]["completed"]
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        leading: Checkbox(
                          shape: CircleBorder(),
                            value: tasks[index]["completed"],
                            onChanged: (value) => _toggleTaskStatus(index)),
                        trailing: IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTaskDialouge(),
        child: Icon(Icons.add),
      ),
    );
  }
}
