# philiprehberger_slug

[![Tests](https://github.com/philiprehberger/dart-slug/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/dart-slug/actions/workflows/ci.yml)
[![pub package](https://img.shields.io/pub/v/philiprehberger_slug.svg)](https://pub.dev/packages/philiprehberger_slug)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/dart-slug)](https://github.com/philiprehberger/dart-slug/commits/main)

Unicode-aware URL slug generator with transliteration and collision handling

## Requirements

- Dart >= 3.8

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  philiprehberger_slug: ^0.5.0
```

Then run:

```bash
dart pub get
```

## Usage

```dart
import 'package:philiprehberger_slug/slug.dart';

final slug = Slug.generate('Hello World!');
// => 'hello-world'
```

### Unicode Transliteration

```dart
Slug.generate('Ünïcödé Tëxt');
// => 'unicode-text'

Slug.generate('Café résumé');
// => 'cafe-resume'
```

### Custom Separator

```dart
Slug.generate('Hello World', separator: '_');
// => 'hello_world'
```

### Max Length

```dart
Slug.generate('A very long title that should be truncated', maxLength: 20);
// => 'a-very-long-title'
```

### Unique Slugs

```dart
import 'package:philiprehberger_slug/philiprehberger_slug.dart';

final slug = await Slug.unique(
  'Hello World',
  exists: (candidate) => database.slugExists(candidate),
);
// Returns "hello-world", "hello-world-1", "hello-world-2", etc.
```

### Slug Validation

```dart
Slug.isSlug('hello-world');    // => true
Slug.isSlug('Hello World!');   // => false
Slug.isSlug('hello_world', separator: '_'); // => true
Slug.isSlug('');               // => false
Slug.isSlug('-leading');       // => false
Slug.isSlug('double--dash');   // => false
```

### Collision Handling

```dart
Slug.withSuffix('hello-world', 2);
// => 'hello-world-2'
```

### Title Case Conversion

```dart
Slug.toTitle('hello-world');
// => 'Hello World'

Slug.toTitle('hello_world', separator: '_');
// => 'Hello World'
```

## API

| Method | Description |
|--------|-------------|
| `Slug.generate(input, {separator, maxLength})` | Generate a URL-safe slug from any string |
| `Slug.unique(input, {separator, maxLength, exists})` | Generate a collision-free slug with async callback |
| `Slug.isSlug(input, {separator})` | Check if a string is already a valid slug |
| `Slug.toTitle(slug, {separator})` | Convert a slug back to title case |
| `Slug.withSuffix(slug, suffix, {separator})` | Append a numeric suffix for collision avoidance |

## Development

```bash
dart pub get
dart analyze --fatal-infos
dart test
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/dart-slug)

🐛 [Report issues](https://github.com/philiprehberger/dart-slug/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/dart-slug/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
