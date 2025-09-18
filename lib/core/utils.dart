import 'package:intl/intl.dart';

/// A mixin providing utility functions.
mixin Utils {
  /// Formats a [DateTime] object into a string with the pattern 'd 'de' MMMM 'de' yyyy'.
  ///
  /// For example, a date like 2023-12-25 would be formatted as '25 de diciembre de 2023'.
  ///
  /// Requires a [date] parameter, which is the [DateTime] to be formatted.
  /// Returns the formatted date string.
  String formatDateCommon({required DateTime date}) {
    final formattedDate = DateFormat(
      'd \'de\' MMMM \'de\' yyyy',
      'es',
    ).format(date);
    return formattedDate;
  }
}
