import 'package:philiprehberger_slug/slug.dart';

void main() {
  // Basic slug generation
  print(Slug.generate('Hello World!')); // hello-world

  // Unicode transliteration
  print(Slug.generate('Caf\u00E9 r\u00E9sum\u00E9')); // cafe-resume

  // Custom separator
  print(Slug.generate('Hello World', separator: '_')); // hello_world

  // Max length
  print(Slug.generate('A very long title here', maxLength: 15)); // a-very-long

  // Collision handling
  print(Slug.withSuffix('hello-world', 2)); // hello-world-2
}
