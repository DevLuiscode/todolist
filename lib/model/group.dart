import 'package:gestordeventas/model/task.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Group {
  @Id()
  int id = 0;
  String description;
  int color;
  @Backlink()
  final tasks = ToMany<Task>();
  Group({
    this.id = 0,
    required this.description,
    required this.color,
  });

  String taskDesription() {
    final taskComplete = tasks.where((task) => task.state).length;

    if (tasks.isEmpty) {
      return '';
    }
    return '$taskComplete of ${tasks.length}';
  }
}
