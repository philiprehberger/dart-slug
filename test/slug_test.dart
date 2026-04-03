import 'package:philiprehberger_slug/slug.dart';
import 'package:test/test.dart';

void main() {
  group('Slug.generate', () {
    test('converts simple string to slug', () {
      expect(Slug.generate('Hello World'), equals('hello-world'));
    });

    test('handles special characters', () {
      expect(Slug.generate('Hello, World! How are you?'),
          equals('hello-world-how-are-you'));
    });

    test('transliterates accented characters', () {
      expect(Slug.generate('Caf\u00E9 r\u00E9sum\u00E9'),
          equals('cafe-resume'));
    });

    test('transliterates German umlauts', () {
      expect(Slug.generate('\u00DCn\u00EFc\u00F6d\u00E9'), equals('uenicoede'));
    });

    test('transliterates German sharp s', () {
      expect(Slug.generate('Stra\u00DFe'), equals('strasse'));
    });

    test('uses custom separator', () {
      expect(Slug.generate('Hello World', separator: '_'),
          equals('hello_world'));
    });

    test('respects max length', () {
      final result = Slug.generate(
          'A very long title that should be truncated',
          maxLength: 20);
      expect(result.length, lessThanOrEqualTo(20));
      expect(result, isNot(endsWith('-')));
    });

    test('returns empty string for empty input', () {
      expect(Slug.generate(''), equals(''));
    });

    test('handles multiple spaces and special chars', () {
      expect(Slug.generate('  Hello   World  '), equals('hello-world'));
    });

    test('is idempotent', () {
      final slug = Slug.generate('Hello World');
      expect(Slug.generate(slug), equals(slug));
    });

    test('handles numeric strings', () {
      expect(Slug.generate('Article 123'), equals('article-123'));
    });

    test('strips leading and trailing separators', () {
      expect(Slug.generate('---hello---'), equals('hello'));
    });
  });

  group('Slug.withSuffix', () {
    test('appends suffix with default separator', () {
      expect(Slug.withSuffix('hello-world', 2), equals('hello-world-2'));
    });

    test('appends suffix with custom separator', () {
      expect(Slug.withSuffix('hello_world', 3, separator: '_'),
          equals('hello_world_3'));
    });
  });
}
