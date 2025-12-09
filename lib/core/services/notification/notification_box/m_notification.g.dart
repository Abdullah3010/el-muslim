// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MLocalNotificationAdapter extends TypeAdapter<MLocalNotification> {
  @override
  final typeId = 1;

  @override
  MLocalNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MLocalNotification(
      id: (fields[0] as num).toInt(),
      title: fields[1] as String,
      scheduledAt: fields[2] as DateTime,
      body: fields[5] as String?,
      repeatDaily: fields[3] == null ? false : fields[3] as bool,
      payload:
          fields[4] == null
              ? const {}
              : (fields[4] as Map).cast<String, dynamic>(),
      deepLink: fields[6] as String?,
      isEnabled: fields[7] == null ? true : fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MLocalNotification obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.scheduledAt)
      ..writeByte(3)
      ..write(obj.repeatDaily)
      ..writeByte(4)
      ..write(obj.payload)
      ..writeByte(5)
      ..write(obj.body)
      ..writeByte(6)
      ..write(obj.deepLink)
      ..writeByte(7)
      ..write(obj.isEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MLocalNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
