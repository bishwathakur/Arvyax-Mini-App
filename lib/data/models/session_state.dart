import 'package:hive_ce/hive.dart';

class SessionState {
  final String ambienceId;
  final String ambienceTitle;
  final String thumbnailAsset;
  final int elapsedSeconds;
  final int totalSeconds;
  final bool isPlaying;

  const SessionState({
    required this.ambienceId,
    required this.ambienceTitle,
    required this.thumbnailAsset,
    required this.elapsedSeconds,
    required this.totalSeconds,
    required this.isPlaying,
  });

  SessionState copyWith({
    String? ambienceId,
    String? ambienceTitle,
    String? thumbnailAsset,
    int? elapsedSeconds,
    int? totalSeconds,
    bool? isPlaying,
  }) {
    return SessionState(
      ambienceId: ambienceId ?? this.ambienceId,
      ambienceTitle: ambienceTitle ?? this.ambienceTitle,
      thumbnailAsset: thumbnailAsset ?? this.thumbnailAsset,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

class SessionStateAdapter extends TypeAdapter<SessionState> {
  @override
  final int typeId = 1;

  @override
  SessionState read(BinaryReader reader) {
    return SessionState(
      ambienceId: reader.readString(),
      ambienceTitle: reader.readString(),
      thumbnailAsset: reader.readString(),
      elapsedSeconds: reader.readInt(),
      totalSeconds: reader.readInt(),
      isPlaying: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, SessionState obj) {
    writer.writeString(obj.ambienceId);
    writer.writeString(obj.ambienceTitle);
    writer.writeString(obj.thumbnailAsset);
    writer.writeInt(obj.elapsedSeconds);
    writer.writeInt(obj.totalSeconds);
    writer.writeBool(obj.isPlaying);
  }
}
