import 'package:al_muslim/modules/werd/data/models/m_werd_detail_segment.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

@immutable
class MWerdDay {
  const MWerdDay({
    required this.dayNumber,
    required this.startAyahNumber,
    required this.endAyahNumber,
    required this.startAyahText,
    required this.endAyahText,
    required this.startSurahEn,
    required this.startSurahAr,
    required this.endSurahEn,
    required this.endSurahAr,
    required this.startPageNumber,
    required this.endPageNumber,
    this.isFinished = false,
  });

  final int dayNumber;
  final int startAyahNumber;
  final int endAyahNumber;
  final String startAyahText;
  final String endAyahText;
  final String startSurahEn;
  final String startSurahAr;
  final String endSurahEn;
  final String endSurahAr;
  final int startPageNumber;
  final int endPageNumber;
  final bool isFinished;

  MWerdDay copyWith({bool? isFinished, int? startPageNumber, int? endPageNumber}) {
    return MWerdDay(
      dayNumber: dayNumber,
      startAyahNumber: startAyahNumber,
      endAyahNumber: endAyahNumber,
      startAyahText: startAyahText,
      endAyahText: endAyahText,
      startSurahEn: startSurahEn,
      startSurahAr: startSurahAr,
      endSurahEn: endSurahEn,
      endSurahAr: endSurahAr,
      startPageNumber: startPageNumber ?? this.startPageNumber,
      endPageNumber: endPageNumber ?? this.endPageNumber,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  factory MWerdDay.fromJson(int dayNumber, Map<String, dynamic> json, {bool isFinished = false}) {
    return MWerdDay(
      dayNumber: dayNumber,
      startAyahNumber: (json['start_ayah_number'] as num?)?.toInt() ?? 0,
      endAyahNumber: (json['end_ayah_number'] as num?)?.toInt() ?? 0,
      startAyahText: json['start_ayah_text']?.toString() ?? '',
      endAyahText: json['end_ayah_text']?.toString() ?? '',
      startSurahEn: json['start_surah_en']?.toString() ?? '',
      startSurahAr: json['start_surah_ar']?.toString() ?? '',
      endSurahEn: json['end_surah_en']?.toString() ?? '',
      endSurahAr: json['end_surah_ar']?.toString() ?? '',
      startPageNumber: (json['start_page_number'] as num?)?.toInt() ?? 0,
      endPageNumber: (json['end_page_number'] as num?)?.toInt() ?? 0,
      isFinished: isFinished,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'day_number': dayNumber,
      'start_ayah_number': startAyahNumber,
      'end_ayah_number': endAyahNumber,
      'start_ayah_text': startAyahText,
      'end_ayah_text': endAyahText,
      'start_surah_en': startSurahEn,
      'start_surah_ar': startSurahAr,
      'end_surah_en': endSurahEn,
      'end_surah_ar': endSurahAr,
      'start_page_number': startPageNumber,
      'end_page_number': endPageNumber,
      'is_finished': isFinished,
    };
  }

  List<MWerdDetailSegment> toSegments() {
    return [
      MWerdDetailSegment(
        titleAr: 'من $startSurahAr: $startAyahNumber',
        titleEn: 'From $startSurahEn: $startAyahNumber',
        subtitleAr: startAyahText,
        subtitleEn: startAyahText,
        startPageNumber: startPageNumber,
        endPageNumber: 0,
      ),
      MWerdDetailSegment(
        titleAr: 'إلى $endSurahAr: $endAyahNumber',
        titleEn: 'To $endSurahEn: $endAyahNumber',
        subtitleAr: endAyahText,
        subtitleEn: endAyahText,
        startPageNumber: 0,
        endPageNumber: endPageNumber,
      ),
    ];
  }
}

class MWerdDayAdapter extends TypeAdapter<MWerdDay> {
  @override
  int get typeId => 3;

  @override
  MWerdDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }

    return MWerdDay(
      dayNumber: fields[0] as int? ?? 0,
      startAyahNumber: fields[1] as int? ?? 0,
      endAyahNumber: fields[2] as int? ?? 0,
      startAyahText: fields[3] as String? ?? '',
      endAyahText: fields[4] as String? ?? '',
      startSurahEn: fields[5] as String? ?? '',
      startSurahAr: fields[6] as String? ?? '',
      endSurahEn: fields[7] as String? ?? '',
      endSurahAr: fields[8] as String? ?? '',
      startPageNumber: fields[10] as int? ?? 0,
      endPageNumber: fields[11] as int? ?? 0,
      isFinished: fields[9] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, MWerdDay obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.dayNumber)
      ..writeByte(1)
      ..write(obj.startAyahNumber)
      ..writeByte(2)
      ..write(obj.endAyahNumber)
      ..writeByte(3)
      ..write(obj.startAyahText)
      ..writeByte(4)
      ..write(obj.endAyahText)
      ..writeByte(5)
      ..write(obj.startSurahEn)
      ..writeByte(6)
      ..write(obj.startSurahAr)
      ..writeByte(7)
      ..write(obj.endSurahEn)
      ..writeByte(8)
      ..write(obj.endSurahAr)
      ..writeByte(9)
      ..write(obj.isFinished)
      ..writeByte(10)
      ..write(obj.startPageNumber)
      ..writeByte(11)
      ..write(obj.endPageNumber);
  }
}
