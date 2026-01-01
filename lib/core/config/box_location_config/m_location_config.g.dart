// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_location_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MLocationConfigAdapter extends TypeAdapter<MLocationConfig> {
  @override
  final typeId = 2;

  @override
  MLocationConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MLocationConfig(
      latitude: (fields[0] as num).toDouble(),
      longitude: (fields[1] as num).toDouble(),
      city: fields[2] as String,
      country: fields[3] as String,
      updatedAt: fields[4] as DateTime,
      autoDetect: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MLocationConfig obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.country)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.autoDetect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MLocationConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
