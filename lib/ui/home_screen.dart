import 'package:flutter/material.dart';
import 'package:gestordeventas/model/group.dart';
import 'package:gestordeventas/ui/provider/group_provider.dart';
import 'package:gestordeventas/ui/provider/task_provider.dart';
import 'package:gestordeventas/ui/task_screen.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<GroupProvider>(context).loadStore();
    final groupProvider = Provider.of<GroupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'TODO List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: groupProvider.group.isNotEmpty
          ? GridView.builder(
              itemCount: groupProvider.group.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final group = groupProvider.group[index];
                return InkWell(
                  onTap: () {
                    // Provider.of<TaskProvider>(context, listen: false)
                    //     .loadGroups(group);
                    context
                        .read<TaskProvider>()
                        .getGroup(group, groupProvider.store);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TaskScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Color(group.color),
                      elevation: 20,
                      borderOnForeground: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            group.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            group.taskDesription(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('Sin ningun grupo'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialogWidget();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AlertDialogWidget extends StatefulWidget {
  const AlertDialogWidget({
    super.key,
  });

  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  TextEditingController addGrupo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    return AlertDialog(
      elevation: 2,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: groupProvider.selectColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.group,
                      size: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: addGrupo,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Ingresa un grupo',
                        ),
                        validator: (value) {
                          if (addGrupo.text.isEmpty) {
                            return 'Ingrese un grupo para registrar';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<GroupProvider>().addGrourp(
                                Group(
                                  description: addGrupo.text,
                                  color: groupProvider.selectColor.value,
                                ),
                              );
                        }
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Colors.primaries.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: ((context, index) {
                  final color = Colors.primaries[index];
                  return InkWell(
                    onTap: () {
                      groupProvider.setColor(color);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: color,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
