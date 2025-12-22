import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_day.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

@immutable
class MWerdPlanOption {
  const MWerdPlanOption({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.days,
    required this.assetPath,
    required this.partsPerDay,
    required this.partsPerDayLabelEn,
    required this.partsPerDayLabelAr,
    required this.quartersPerDay,
    required this.quartersPerDayLabelEn,
    required this.quartersPerDayLabelAr,
    required this.isSuggested,
    this.planDays = const [],
    this.notifications = const [],
  });

  final int id;
  final String nameAr;
  final String nameEn;
  final int days;
  final String assetPath;
  final double partsPerDay;
  final String partsPerDayLabelEn;
  final String partsPerDayLabelAr;
  final double quartersPerDay;
  final String quartersPerDayLabelEn;
  final String quartersPerDayLabelAr;
  final bool isSuggested;
  final List<MWerdDay> planDays;
  final List<MLocalNotification> notifications;

  String get titleAr => nameAr;
  String get titleEn => nameEn;

  String get subtitleAr => 'الورد اليومي ${_formatPortion(partsPerDay)} $partsPerDayLabelAr'.trim();
  String get subtitleEn => 'Daily portion ${_formatPortion(partsPerDay)} $partsPerDayLabelEn'.trim();

  factory MWerdPlanOption.fromJson(Map<String, dynamic> json) {
    final rawPath = json['path']?.toString() ?? '';
    final partsPerDay = (json['parts_per_day'] as num?)?.toDouble() ?? 0;

    return MWerdPlanOption(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nameAr: json['name_ar']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      days: (json['days'] as num?)?.toInt() ?? 0,
      assetPath: _normalizeAssetPath(rawPath),
      partsPerDay: partsPerDay,
      partsPerDayLabelEn: json['parts_per_day_en']?.toString() ?? '',
      partsPerDayLabelAr: json['parts_per_day_ar']?.toString() ?? '',
      quartersPerDay: (json['quarters_per_day'] as num?)?.toDouble() ?? 0,
      quartersPerDayLabelEn: json['quarters_per_day_en']?.toString() ?? '',
      quartersPerDayLabelAr: json['quarters_per_day_ar']?.toString() ?? '',
      isSuggested: json['is_suggested'] == true,
      planDays: const [],
      notifications: const [],
    );
  }

  MWerdPlanOption copyWith({List<MWerdDay>? planDays, List<MLocalNotification>? notifications}) {
    return MWerdPlanOption(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      days: days,
      assetPath: assetPath,
      partsPerDay: partsPerDay,
      partsPerDayLabelEn: partsPerDayLabelEn,
      partsPerDayLabelAr: partsPerDayLabelAr,
      quartersPerDay: quartersPerDay,
      quartersPerDayLabelEn: quartersPerDayLabelEn,
      quartersPerDayLabelAr: quartersPerDayLabelAr,
      isSuggested: isSuggested,
      planDays: planDays ?? this.planDays,
      notifications: notifications ?? this.notifications,
    );
  }

  static String _normalizeAssetPath(String rawPath) {
    final cleaned = rawPath.replaceFirst(RegExp(r'^source/'), '');
    if (cleaned.startsWith('assets/')) {
      return cleaned;
    }
    return 'assets/json/khatma/$cleaned';
  }

  static String _formatPortion(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    final formatted = value.toStringAsFixed(value < 1 ? 2 : 1);
    return formatted.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}

class MWerdPlanOptionAdapter extends TypeAdapter<MWerdPlanOption> {
  @override
  int get typeId => 4;

  @override
  MWerdPlanOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }

    return MWerdPlanOption(
      id: fields[0] as int? ?? 0,
      nameAr: fields[1] as String? ?? '',
      nameEn: fields[2] as String? ?? '',
      days: fields[3] as int? ?? 0,
      assetPath: fields[4] as String? ?? '',
      partsPerDay: (fields[5] as num?)?.toDouble() ?? 0,
      partsPerDayLabelEn: fields[6] as String? ?? '',
      partsPerDayLabelAr: fields[7] as String? ?? '',
      quartersPerDay: (fields[8] as num?)?.toDouble() ?? 0,
      quartersPerDayLabelEn: fields[9] as String? ?? '',
      quartersPerDayLabelAr: fields[10] as String? ?? '',
      isSuggested: fields[11] as bool? ?? false,
      planDays: (fields[12] as List?)?.whereType<MWerdDay>().toList() ?? const [],
      notifications: (fields[13] as List?)?.whereType<MLocalNotification>().toList() ?? const [],
    );
  }

  @override
  void write(BinaryWriter writer, MWerdPlanOption obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameAr)
      ..writeByte(2)
      ..write(obj.nameEn)
      ..writeByte(3)
      ..write(obj.days)
      ..writeByte(4)
      ..write(obj.assetPath)
      ..writeByte(5)
      ..write(obj.partsPerDay)
      ..writeByte(6)
      ..write(obj.partsPerDayLabelEn)
      ..writeByte(7)
      ..write(obj.partsPerDayLabelAr)
      ..writeByte(8)
      ..write(obj.quartersPerDay)
      ..writeByte(9)
      ..write(obj.quartersPerDayLabelEn)
      ..writeByte(10)
      ..write(obj.quartersPerDayLabelAr)
      ..writeByte(11)
      ..write(obj.isSuggested)
      ..writeByte(12)
      ..write(obj.planDays.toList())
      ..writeByte(13)
      ..write(obj.notifications.toList());
  }
}
