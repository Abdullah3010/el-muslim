import 'package:hive_ce/hive.dart';

part 'm_notification.g.dart';

@HiveType(typeId: 1)
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

  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime scheduledAt;
  @HiveField(3)
  final bool repeatDaily;
  @HiveField(4)
  final Map<String, dynamic> payload;
  @HiveField(5)
  final String? body;
  @HiveField(6)
  final String? deepLink;
  @HiveField(7)
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
