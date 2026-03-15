import 'package:hive_ce/hive.dart';

class Reflection {
  final String id;
  final DateTime dateTime;
  final String ambienceTitle;
  final String mood;
  final String text;

  const Reflection({
    required this.id,
    required this.dateTime,
    required this.ambienceTitle,
    required this.mood,
    required this.text,
  });
}

class ReflectionAdapter extends TypeAdapter<Reflection> {
  @override
  final int typeId = 0;

  @override
  Reflection read(BinaryReader reader) {
    return Reflection(
      id: reader.readString(),
      dateTime: DateTime.parse(reader.readString()),
      ambienceTitle: reader.readString(),
      mood: reader.readString(),
      text: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Reflection obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.dateTime.toIso8601String());
    writer.writeString(obj.ambienceTitle);
    writer.writeString(obj.mood);
    writer.writeString(obj.text);
  }
}
