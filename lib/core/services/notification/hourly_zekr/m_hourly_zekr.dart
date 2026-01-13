class MHourlyZekr {
  const MHourlyZekr({required this.id, required this.textAr, required this.textEn});

  final int id;
  final String textAr;
  final String textEn;

  factory MHourlyZekr.fromJson(Map<String, dynamic> json) {
    return MHourlyZekr(id: json['id'] as int, textAr: json['text_ar'] as String, textEn: json['text_en'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text_ar': textAr, 'text_en': textEn};
  }

  @override
  String toString() => 'MHourlyZekr(id: $id, textAr: $textAr, textEn: $textEn)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MHourlyZekr && other.id == id && other.textAr == textAr && other.textEn == textEn;
  }

  @override
  int get hashCode => id.hashCode ^ textAr.hashCode ^ textEn.hashCode;
}
