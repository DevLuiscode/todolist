import 'package:flutter/material.dart';
import 'package:gestordeventas/model/group.dart';
import 'package:gestordeventas/objectbox.g.dart';

class GroupProvider extends ChangeNotifier {
  final List<Group> group = [];
  Store? _store;
  late final Box<Group> _groupsBox;

  late Color selectColor = Colors.primaries.first;

  Store get store => _store!;

  void setColor(Color colorItem) {
    selectColor = colorItem;
    notifyListeners();
  }

  void addGrourp(Group groupItem) {
    if (!group.contains(groupItem)) {
      // group.add(groupItem);
      _groupsBox.put(groupItem);
      loadGroups();
    }
    notifyListeners();
  }

  void loadGroups() async {
    group.clear();
    group.addAll(_groupsBox.getAll());

    notifyListeners();
  }

  void loadStore() async {
    if (_store == null) {
      _store = await openStore();
      _groupsBox = _store!.box<Group>();
      loadGroups();
      notifyListeners();
    }
  }

  void onDelete(Group group) {
    _store!.box<Group>().remove(group.id);
    loadGroups();
    notifyListeners();
  }
}
