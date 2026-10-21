import 'package:intl/intl.dart';

extension TimestampX on DateTime {
  String toHumanString() =>
      '${DateFormat.yMMMd().format(this)}, ${DateFormat.Hm().format(this)}';

  String toTechString() => DateFormat('yyyyMMdd_HHmmss').format(this);

  String toMMMMYYYY() => DateFormat('MMMM yyyy').format(this);

  String dateSpan(DateTime? other) {
    if (other == null) {
      return '${DateFormat.yMMMd().format(this)} -';
    }
    final earlier = isBefore(other) ? this : other;
    final later = isBefore(other) ? other : this;
    if (earlier.year == later.year) {
      return '${DateFormat.MMMd().format(earlier)} - ${DateFormat.yMMMd().format(later)}';
    } else {
      return '${DateFormat.yMMMd().format(earlier)} - ${DateFormat.yMMMd().format(later)}';
    }
  }
}
