import 'package:flutter/material.dart';
import 'package:gestordeventas/model/task.dart';
import 'package:gestordeventas/ui/provider/group_provider.dart';
import 'package:gestordeventas/ui/provider/task_provider.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController inputText = TextEditingController();
    final keyForm = GlobalKey<FormState>();
    final store = Provider.of<GroupProvider>(context, listen: false).store;

    final taskProvider = Provider.of<TaskProvider>(context);
    final groupProvider = Provider.of<GroupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            color: Colors.white,
            onPressed: () {
              groupProvider.loadGroups();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          taskProvider.group.description,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              groupProvider.onDelete(taskProvider.group);
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: keyForm,
                      child: TextFormField(
                        controller: inputText,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (inputText.text.isEmpty) {
                            return 'La tarea no puede ser vacia';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      color: Colors.amber,
                      onPressed: () {
                        if (keyForm.currentState!.validate()) {
                          final task = Task(
                            description: inputText.text,
                            state: false,
                          );
                          taskProvider.addGrourp(
                              task, taskProvider.group, store);

                          //taskProvider.loadGroups();
                          Provider.of<GroupProvider>(context, listen: false)
                              .loadGroups();
                        }
                      },
                      child: const Text('Agregar tarea'),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: taskProvider.taskItem.length,
                itemExtent: 50,
                itemBuilder: (context, index) {
                  final task = taskProvider.taskItem[index];
                  return ListTile(
                    title: Text(
                      task.description,
                      style: task.state
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough,
                            )
                          : null,
                    ),
                    leading: Checkbox(
                      value: task.state,
                      onChanged: (val) {
                        groupProvider.loadGroups();
                        taskProvider.onUpdate(index, val!);
                      },
                    ),
                    trailing: InkWell(
                      onTap: () {
                        groupProvider.loadGroups();
                        taskProvider.onDelete(task);
                      },
                      child: const Icon(Icons.close),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
