# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0] - 2026-04-17

### Added
- `Slug.toTitle()` for converting slugs back to title case
- Tests for `Slug.isSlug()` validator

## [0.4.0] - 2026-04-06

### Changed
- Bump minimum Dart SDK from 3.6 to 3.8
- Widen `lints` dependency to `>=5.0.0 <7.0.0`

## [0.3.0] - 2026-04-05

### Added
- `Slug.isSlug()` static validator to check if a string is already a valid slug

## [0.2.0] - 2026-04-04

### Added
- `Slug.unique()` async method for collision-free slug generation with callback

## [0.1.1] - 2026-04-03

### Fixed
- Primary barrel file now matches package name for pub.dev validation

## [0.1.0] - 2026-04-03

### Added
- `Slug.generate()` for creating URL-safe slugs from any string
- Unicode transliteration (accented characters → ASCII equivalents)
- Configurable separator and max length
- `Slug.withSuffix()` for collision-aware slug generation
- Idempotent: same input always produces same output
- Zero external dependencies
