import 'package:flutter/material.dart';
import 'package:todo_list/task.dart';

class ListItemWidget extends StatelessWidget {
  final Task task;
  final int index;
  final Animation<double> animation;
  final VoidCallback? onClicked;
  final void Function(DismissDirection) onDeleted;

  const ListItemWidget({
    required this.task,
    required this.index,
    required this.animation,
    required this.onClicked,
    required this.onDeleted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizeTransition(
        key: UniqueKey(),
        sizeFactor: animation,
        child: buildtask(context),
      );

  Widget buildtask(BuildContext context) => Dismissible(
        key: UniqueKey(),
        onDismissed: onDeleted,
        // confirmDismiss: (_) {
        //   Completer<bool> completer = Completer();
        //   // final scaffold = Scaffold.of(context);
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text(task.title),
        //     behavior: SnackBarBehavior.floating,
        //     duration: Duration(milliseconds: 1000),
        //     onVisible: () =>
        //         Future.delayed(const Duration(milliseconds: 1000), () {
        //       if (completer.isCompleted) return;
        //       completer.complete(true);
        //     }),
        //     action: SnackBarAction(
        //         label: 'UNDO',
        //         onPressed: () =>
        //             completer.isCompleted ? null : completer.complete(false)),
        //   ));

        //   return completer.future;
        // },
        background: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(
                Icons.delete,
                // color: Colors.white,
              ),
              Text(
                'This task was deleted',
                // style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        resizeDuration: const Duration(milliseconds: 500),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black,
            //     blurRadius: 2.0,
            //     spreadRadius: 0.0,
            //     offset: Offset(2.0, 2.0), // shadow direction: bottom right
            //   )
            // ],
          ),
          child: ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 18,
                // color: Colors.white,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: task.isDone
                ? Icon(
                    Icons.check_circle_outline,
                    size: 30,
                    // color: Color(0xFF183588),
                    color: Theme.of(context).colorScheme.secondary,
                  )
                : Icon(
                    Icons.circle_outlined,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            // contentPadding: EdgeInsets.symmetric(vertical: 5),
            onTap: onClicked,
          ),
        ),
      );
}
