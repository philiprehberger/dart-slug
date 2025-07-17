/// Generates URL-safe slugs from arbitrary strings.
///
/// Handles Unicode transliteration, special character removal,
/// whitespace normalization, and optional length limits.
///
/// ```dart
/// Slug.generate('Hello World!'); // => 'hello-world'
/// Slug.generate('Cafe resume');  // => 'cafe-resume'
/// ```
class Slug {
  Slug._();

  static const _transliterations = {
    '\u00C0': 'A', '\u00C1': 'A', '\u00C2': 'A', '\u00C3': 'A', '\u00C4': 'Ae', '\u00C5': 'A',
    '\u00C6': 'Ae', '\u00C7': 'C', '\u00C8': 'E', '\u00C9': 'E', '\u00CA': 'E', '\u00CB': 'E',
    '\u00CC': 'I', '\u00CD': 'I', '\u00CE': 'I', '\u00CF': 'I', '\u00D0': 'D', '\u00D1': 'N',
    '\u00D2': 'O', '\u00D3': 'O', '\u00D4': 'O', '\u00D5': 'O', '\u00D6': 'Oe', '\u00D8': 'O',
    '\u00D9': 'U', '\u00DA': 'U', '\u00DB': 'U', '\u00DC': 'Ue', '\u00DD': 'Y', '\u00DE': 'Th',
    '\u00DF': 'ss',
    '\u00E0': 'a', '\u00E1': 'a', '\u00E2': 'a', '\u00E3': 'a', '\u00E4': 'ae', '\u00E5': 'a',
    '\u00E6': 'ae', '\u00E7': 'c', '\u00E8': 'e', '\u00E9': 'e', '\u00EA': 'e', '\u00EB': 'e',
    '\u00EC': 'i', '\u00ED': 'i', '\u00EE': 'i', '\u00EF': 'i', '\u00F0': 'd', '\u00F1': 'n',
    '\u00F2': 'o', '\u00F3': 'o', '\u00F4': 'o', '\u00F5': 'o', '\u00F6': 'oe', '\u00F8': 'o',
    '\u00F9': 'u', '\u00FA': 'u', '\u00FB': 'u', '\u00FC': 'ue', '\u00FD': 'y', '\u00FE': 'th',
    '\u00FF': 'y',
    '\u0104': 'A', '\u0105': 'a', '\u0106': 'C', '\u0107': 'c', '\u0118': 'E', '\u0119': 'e',
    '\u0141': 'L', '\u0142': 'l', '\u0143': 'N', '\u0144': 'n', '\u015A': 'S', '\u015B': 's',
    '\u0179': 'Z', '\u017A': 'z', '\u017B': 'Z', '\u017C': 'z',
    '\u010C': 'C', '\u010D': 'c', '\u010E': 'D', '\u010F': 'd', '\u011A': 'E', '\u011B': 'e',
    '\u0147': 'N', '\u0148': 'n', '\u0158': 'R', '\u0159': 'r', '\u0160': 'S', '\u0161': 's',
    '\u0164': 'T', '\u0165': 't', '\u016E': 'U', '\u016F': 'u', '\u017D': 'Z', '\u017E': 'z',
    '\u0110': 'D', '\u0111': 'd',
  };

  /// Generate a URL-safe slug from [input].
  ///
  /// - [separator]: Character used between words (default: `-`)
  /// - [maxLength]: Maximum length of the output slug (truncates at word boundary)
  ///
  /// ```dart
  /// Slug.generate('Hello World!');        // => 'hello-world'
  /// Slug.generate('Unicode', separator: '_'); // => 'unicode'
  /// ```
  static String generate(
    String input, {
    String separator = '-',
    int? maxLength,
  }) {
    if (input.isEmpty) return '';

    // Transliterate known characters
    final buffer = StringBuffer();
    for (final char in input.split('')) {
      buffer.write(_transliterations[char] ?? char);
    }

    var result = buffer.toString().toLowerCase();

    // Replace non-alphanumeric with separator
    result = result.replaceAll(RegExp('[^a-z0-9]+'), separator);

    // Trim separators from start and end
    result = result.replaceAll(
        RegExp('^${RegExp.escape(separator)}+|${RegExp.escape(separator)}+\$'),
        '');

    // Apply max length at word boundary
    if (maxLength != null && result.length > maxLength) {
      result = result.substring(0, maxLength);
      final lastSep = result.lastIndexOf(separator);
      if (lastSep > 0) {
        result = result.substring(0, lastSep);
      }
    }

    return result;
  }

  /// Generates a unique slug by appending incrementing suffixes until
  /// [exists] returns false.
  ///
  /// The [exists] callback is called with each candidate slug to check
  /// for collisions (e.g., database lookup).
  static Future<String> unique(
    String input, {
    String separator = '-',
    int? maxLength,
    required Future<bool> Function(String slug) exists,
  }) async {
    final base = generate(input, separator: separator, maxLength: maxLength);
    if (!await exists(base)) return base;

    for (var i = 1; i <= 1000; i++) {
      final candidate = withSuffix(base, i, separator: separator);
      if (!await exists(candidate)) return candidate;
    }

    throw StateError('Could not generate unique slug after 1000 attempts');
  }

  /// Check whether [input] is already a valid slug.
  ///
  /// Returns `true` if the string is lowercase, contains only alphanumeric
  /// characters and the [separator], with no leading/trailing separator and
  /// no consecutive separators.
  ///
  /// ```dart
  /// Slug.isSlug('hello-world');    // => true
  /// Slug.isSlug('Hello World!');   // => false
  /// Slug.isSlug('hello_world', separator: '_'); // => true
  /// ```
  static bool isSlug(String input, {String separator = '-'}) {
    if (input.isEmpty) return false;
    final pattern =
        RegExp('^[a-z0-9]+(?:${RegExp.escape(separator)}[a-z0-9]+)*\$');
    return pattern.hasMatch(input);
  }

  /// Append a numeric [suffix] to a [slug] for collision avoidance.
  ///
  /// ```dart
  /// Slug.withSuffix('hello-world', 2); // => 'hello-world-2'
  /// ```
  static String withSuffix(
    String slug,
    int suffix, {
    String separator = '-',
  }) {
    return '$slug$separator$suffix';
  }
}
