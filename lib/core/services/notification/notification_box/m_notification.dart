import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

@immutable
class MLocalNotification {
  const MLocalNotification({
    required this.id,
    required this.title,
    required this.scheduledAt,
    this.body,
    this.repeatDaily = false,
    this.payload = const {},
    this.deepLink,
    this.isEnabled = true,
  });

  final int id;
  final String title;
  final DateTime scheduledAt;
  final bool repeatDaily;
  final Map<String, dynamic> payload;
  final String? body;
  final String? deepLink;
  final bool isEnabled;

  MLocalNotification copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? scheduledAt,
    bool? repeatDaily,
    Map<String, dynamic>? payload,
    String? deepLink,
    bool? isEnabled,
  }) {
    return MLocalNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      repeatDaily: repeatDaily ?? this.repeatDaily,
      payload: payload ?? this.payload,
      deepLink: deepLink ?? this.deepLink,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'title': title,
    'body': body,
    'scheduledAt': scheduledAt.toIso8601String(),
    'repeatDaily': repeatDaily,
    'payload': payload,
    'deepLink': deepLink,
    'isEnabled': isEnabled,
  };

  factory MLocalNotification.fromMap(Map<String, dynamic> map) {
    return MLocalNotification(
      id: map['id'] as int? ?? 0,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      scheduledAt: DateTime.tryParse(map['scheduledAt'] as String? ?? '') ?? DateTime.now(),
      repeatDaily: map['repeatDaily'] as bool? ?? false,
      payload: (map['payload'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      deepLink: map['deepLink'] as String?,
      isEnabled: map['isEnabled'] as bool? ?? true,
    );
  }
}

class MLocalNotificationAdapter extends TypeAdapter<MLocalNotification> {
  @override
  final int typeId = 30;

  @override
  MLocalNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read()};

    return MLocalNotification(
      id: fields[0] as int,
      title: fields[1] as String,
      body: fields[2] as String,
      scheduledAt: fields[3] as DateTime,
      repeatDaily: fields[4] as bool,
      payload: (fields[5] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      deepLink: fields[6] as String?,
      isEnabled: fields[7] as bool? ?? true,
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
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.scheduledAt)
      ..writeByte(4)
      ..write(obj.repeatDaily)
      ..writeByte(5)
      ..write(obj.payload)
      ..writeByte(6)
      ..write(obj.deepLink)
      ..writeByte(7)
      ..write(obj.isEnabled);
  }
}
