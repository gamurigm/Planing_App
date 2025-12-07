// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityTypeModelAdapter extends TypeAdapter<ActivityTypeModel> {
  @override
  final int typeId = 1;

  @override
  ActivityTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityTypeModel(
      name: fields[0] as String,
      events: (fields[1] as Map?)?.cast<int, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ActivityTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.events);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
