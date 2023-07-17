import 'package:flutter_todos/todos_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'objectbox.g.dart';

class TodosObjectBox {
  late final Store store;
  late final Box<TodosModel> noteBox;

  TodosObjectBox._create(this.store) {
    noteBox = Box<TodosModel>(store);
    if (noteBox.isEmpty()) {
      _putDemoData();
    }
  }

  static Future<TodosObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));
    return TodosObjectBox._create(store);
  }

  void _putDemoData() {
    final demoNote = TodosModel(
        title: 'Note 1', comment: 'Note 1 comment', date: DateTime.now());
    noteBox.put(demoNote);
  }

  Stream<List<TodosModel>> getNotes() {
    final builder =
        noteBox.query().order(TodosModel_.date, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((event) => event.find());
  }

  void removeNote(int id) {
    noteBox.remove(id);
  }

  Future<void> addNotes(TodosModel data) async {
    noteBox.put(data);
  }
}
