import 'package:intl/intl.dart';

String formatDate(DateTime d) => DateFormat('d MMM yyyy').format(d.toLocal());

String formatWeight(double w) =>
    w == w.roundToDouble() ? w.toInt().toString() : w.toString();