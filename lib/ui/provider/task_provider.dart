import 'package:flutter/material.dart';
import 'package:gestordeventas/model/group.dart';
import 'package:gestordeventas/model/task.dart';
import 'package:gestordeventas/objectbox.g.dart';

class TaskProvider extends ChangeNotifier {
  // late GroupProvider groupProvider;
  final List<Task> _task = [];

  List<Task> get taskItem => _task;

  late Group group;
  late Store _store;

  void getGroup(Group grou, Store store) {
    group = grou;
    _store = store;
    loadGroups();
    notifyListeners();
  }

  void addGrourp(Task taskItem, Group groups, Store store) {
    if (!_task.contains(taskItem)) {
      taskItem.group.target = groups;
      store.box<Task>().put(taskItem);
      loadGroups();

      notifyListeners();
    }
  }

  void loadGroups() async {
    _task.clear();
    //_task.addAll(List.from(group.tasks));
    // groupProvider.store;

    QueryBuilder<Task> builder = _store.box<Task>().query();
    builder.link(Task_.group, Group_.id.equals(group.id));
    Query<Task> query = builder.build();
    List<Task> taskResult = query.find();
    _task.addAll(taskResult);

    notifyListeners();
    query.close();
  }

  void onDelete(Task task) {
    _store.box<Task>().remove(task.id);
    loadGroups();
  }

  void onUpdate(int index, bool state) {
    final task = _task[index];
    task.state = state;
    _store.box<Task>().put(task);
    loadGroups();
  }
}
