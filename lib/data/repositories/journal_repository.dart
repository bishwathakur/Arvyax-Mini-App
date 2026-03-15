import 'package:hive_ce/hive.dart';
import '../models/reflection.dart';

class JournalRepository {
  static const String _boxName = 'reflectionsBox';

  Future<void> init() async {
    Hive.registerAdapter(ReflectionAdapter());
    await Hive.openBox<Reflection>(_boxName);
  }

  Box<Reflection> _getBox() => Hive.box<Reflection>(_boxName);

  List<Reflection> getReflections() {
    final box = _getBox();
    final list = box.values.toList();
    list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  Future<void> saveReflection(Reflection reflection) async {
    final box = _getBox();
    await box.put(reflection.id, reflection);
  }
}
