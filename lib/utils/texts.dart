import 'package:html_unescape/html_unescape.dart';

class TextUtils {
  static final _unescape = HtmlUnescape();

  static String normalizeToSingleLine(String text) {
    if (text == null) {
      return null;
    }

    text = _normalize(text);
    text = removeMultipleSpaces(text);

    return text;
  }

  static String normalizeToMultiLine(String text) {
    if (text == null) {
      return null;
    }

    text = _normalize(text);
    text = replaceMultipleSpacesWithNewLine(text);

    return text;
  }

  static String _normalize(String text) {
    if (text == null) {
      return null;
    }

    text = _unescapeHtmlSymbols(text);
    text = removeParagraphs(text);

    return text;
  }

  static String removeParagraphs(String text) => text.replaceAll('\\n', ' ');

  static String removeMultipleSpaces(String text) =>
      text.trim().replaceAll(RegExp(r'\s{2,}'), ' ');

  static String replaceMultipleSpacesWithNewLine(String text) =>
      text.trim().replaceAll(RegExp(r'\s{2,}'), '\n');

  static String _unescapeHtmlSymbols(String text) =>
      _unescape.convert(text.replaceAll('\\\'', '\'').replaceAll('\\&', '&'));
}
