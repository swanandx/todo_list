// import 'dart:async';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/add_task.dart';
import 'package:todo_list/listitem.dart';
import 'package:todo_list/task.dart';

// import 'package:flutter/rendering.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  // final savedThemeMode = await AdaptiveTheme.getThemeMode();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPaintSizeEnabled = true;
    return MaterialApp(
      title: 'TODO list',
      darkTheme: _myTheme,
      themeMode: ThemeMode.dark,
      home: const Todo(),
    );
  }
}

final ThemeData _myTheme = _buildTheme();

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      background: const Color(0xFF121212),
      onBackground: const Color(0xFFFFFFFF),
      surface: const Color(0xFF121212),
      onSurface: const Color(0xFFFFFFFF),
      primary: const Color(0xFFBB86FC),
      onPrimary: const Color(0xFF000000),
      secondary: const Color(0xFF03DAC6),
      onSecondary: const Color(0xFF000000),
      error: const Color(0xFFCF6679),
      onError: const Color(0xFF000000),
    ),
  );
}

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  final List<Task> _tasks = <Task>[];

  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedTasks = (prefs.getStringList('tasks') ?? []);
    for (String task in savedTasks.reversed) {
      setState(() {
        addTask(Task.fromJson(jsonDecode(task)));
      });
    }
  }

  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'tasks', _tasks.map((e) => jsonEncode(e)).toList());
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void removeTask(int index) {
    var _removedTask = _tasks.removeAt(index);
    listKey.currentState!.removeItem(
      index,
      (context, animation) => const SizedBox(),
    );
    _saveTasks();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Task Dismissed: ' + _removedTask.title),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => {addTask(_removedTask, index)},
        )));
  }

  void _reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tasks');
    for (var i = _tasks.length - 1; i >= 0; i--) {
      _tasks.removeAt(i);
      listKey.currentState!.removeItem(
        i,
        (context, animation) => const SizedBox(),
      );
    }
  }

  void addTask(Task task, [int index = 0]) {
    _tasks.insert(index, task);
    listKey.currentState!.insertItem(index);
    _saveTasks();
  }

  AnimatedList _buildTasks() {
    return AnimatedList(
      key: listKey,
      initialItemCount: _tasks.length,
      itemBuilder: (context, index, animation) => ListItemWidget(
        task: _tasks[index],
        index: index,
        animation: animation,
        onClicked: () {
          setState(() {
            _tasks[index].isDone = !_tasks[index].isDone;
            _saveTasks();
          });
        },
        onDeleted: (DismissDirection direction) => removeTask(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            // TODO add other function!
            // probably toggle notifications!
            IconButton(icon: const Icon(null), onPressed: () {}),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.delete_forever,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: const Text(
                      "This will delete all tasks! Do you wish to continue?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _reset();
                      },
                      child: const Text("Delete Them!"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Spacer(),
          // Image.asset(
          //   'images/cat.png',
          //   height: 200,
          // ),
          SvgPicture.asset(
            'images/tree.svg',
            height: 250,
            // color: Colors.white,
            theme: const SvgTheme(
                // currentColor: Theme.of(context).colorScheme.secondary,
                currentColor: Colors.white),
          ),
          // Spacer(),
          Container(
            margin: const EdgeInsets.all(50),
            // height: MediaQuery.of(context).size.height * 0.1,
            child: const Align(
              alignment: Alignment.center,
              child: Text(
                "My Tasks",
                style: TextStyle(fontSize: 35),
              ),
            ),
          ),
          // const Spacer(),
          Expanded(
            child: _buildTasks(),
            flex: 5,
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () async {
          String? name = await Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, _) {
              return const AddTask();
            },
            opaque: false,
          ));

          if (name?.isNotEmpty ?? false) {
            addTask(Task(title: name!));
          }
        },
      ),
    );
  }
}
