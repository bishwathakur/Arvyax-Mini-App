import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ambience.dart';

class AmbienceRepository {
  List<Ambience>? _ambiencesCache;

  Future<List<Ambience>> getAmbiences() async {
    if (_ambiencesCache != null) return _ambiencesCache!;

    final String jsonString = await rootBundle.loadString('assets/data/ambiences.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);

    _ambiencesCache = jsonList.map((json) => Ambience.fromJson(json)).toList();
    return _ambiencesCache!;
  }
}
