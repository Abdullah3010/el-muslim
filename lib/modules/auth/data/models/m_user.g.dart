// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MUserAdapter extends TypeAdapter<MUser> {
  @override
  final typeId = 0;

  @override
  MUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MUser(
      id: fields[0] as String?,
      firstName: fields[2] as String?,
      lastName: fields[3] as String?,
      email: fields[4] as String?,
      phone: fields[1] as String?,
      isActive: fields[5] as bool?,
      isVerified: fields[6] as bool?,
      accessToken: fields[7] as String?,
      refreshToken: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MUser obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.isVerified)
      ..writeByte(7)
      ..write(obj.accessToken)
      ..writeByte(8)
      ..write(obj.refreshToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
