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

  group('Slug.unique', () {
    test('returns base slug when no collision', () async {
      final result = await Slug.unique(
        'Hello World',
        exists: (slug) async => false,
      );
      expect(result, 'hello-world');
    });

    test('appends suffix on collision', () async {
      final existing = {'hello-world'};
      final result = await Slug.unique(
        'Hello World',
        exists: (slug) async => existing.contains(slug),
      );
      expect(result, 'hello-world-1');
    });

    test('increments suffix until unique', () async {
      final existing = {'hello-world', 'hello-world-1', 'hello-world-2'};
      final result = await Slug.unique(
        'Hello World',
        exists: (slug) async => existing.contains(slug),
      );
      expect(result, 'hello-world-3');
    });

    test('respects custom separator', () async {
      final existing = {'hello_world'};
      final result = await Slug.unique(
        'Hello World',
        separator: '_',
        exists: (slug) async => existing.contains(slug),
      );
      expect(result, 'hello_world_1');
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

  group('Slug.isSlug', () {
    test('returns true for valid slug', () {
      expect(Slug.isSlug('hello-world'), isTrue);
    });

    test('returns true for single word', () {
      expect(Slug.isSlug('hello'), isTrue);
    });

    test('returns false for empty string', () {
      expect(Slug.isSlug(''), isFalse);
    });

    test('returns false for uppercase', () {
      expect(Slug.isSlug('Hello-World'), isFalse);
    });

    test('returns false for spaces', () {
      expect(Slug.isSlug('hello world'), isFalse);
    });

    test('returns false for leading separator', () {
      expect(Slug.isSlug('-hello'), isFalse);
    });

    test('returns false for trailing separator', () {
      expect(Slug.isSlug('hello-'), isFalse);
    });

    test('returns false for consecutive separators', () {
      expect(Slug.isSlug('hello--world'), isFalse);
    });

    test('validates with custom separator', () {
      expect(Slug.isSlug('hello_world', separator: '_'), isTrue);
      expect(Slug.isSlug('hello-world', separator: '_'), isFalse);
    });

    test('allows numeric segments', () {
      expect(Slug.isSlug('article-123'), isTrue);
    });
  });

  group('Slug.toTitle', () {
    test('converts slug to title case', () {
      expect(Slug.toTitle('hello-world'), equals('Hello World'));
    });

    test('handles single word', () {
      expect(Slug.toTitle('hello'), equals('Hello'));
    });

    test('handles empty string', () {
      expect(Slug.toTitle(''), equals(''));
    });

    test('uses custom separator', () {
      expect(Slug.toTitle('hello_world', separator: '_'), equals('Hello World'));
    });

    test('handles numeric segments', () {
      expect(Slug.toTitle('article-123'), equals('Article 123'));
    });

    test('handles multiple words', () {
      expect(Slug.toTitle('the-quick-brown-fox'), equals('The Quick Brown Fox'));
    });
  });
}
