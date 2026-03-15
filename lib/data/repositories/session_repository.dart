import 'package:hive_ce/hive.dart';
import '../models/session_state.dart';

class SessionRepository {
  static const String _boxName = 'sessionBox';
  static const String _key = 'lastSession';

  Future<void> init() async {
    Hive.registerAdapter(SessionStateAdapter());
    await Hive.openBox<SessionState>(_boxName);
  }

  Box<SessionState> _getBox() => Hive.box<SessionState>(_boxName);

  SessionState? getLastSession() {
    final box = _getBox();
    return box.get(_key);
  }

  Future<void> saveSession(SessionState state) async {
    final box = _getBox();
    await box.put(_key, state);
  }

  Future<void> clearSession() async {
    final box = _getBox();
    await box.delete(_key);
  }
}
