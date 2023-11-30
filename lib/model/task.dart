import 'package:gestordeventas/model/group.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Task {
  @Id()
  int id;

  String description;
  bool state = false;

  late final group = ToOne<Group>();

  Task({
    this.id = 0,
    required this.description,
    required this.state,
  });
}
