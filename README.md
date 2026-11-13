# Quran | قورئان

A Flutter Quran application for Android and iOS, built with Riverpod,
go_router, and Flutter's generated localization system.

## Requirements

- Flutter 3.47.2 or newer in the 3.x stable series
- Dart 3.13.2 or newer

The app starts in Sorani Kurdish and supports Sorani Kurdish (`ckb`), Arabic
(`ar`), and English (`en`). It has exactly three state-preserving destinations:
Quran, Channels, and Settings. Language, theme mode, and Quran text size
preferences are stored locally.

The Quran tab includes all 114 Surahs, offline Arabic Quran text, and the HQKSTD
Sorani verse-meaning dataset (6,236 aligned Ayahs). The RTL reader supports
Surah search, Ayah navigation and highlighting, font-size controls, and
Continue Reading. Source attribution and validation notes are in
[`assets/data/README.md`](assets/data/README.md).

Audio playback includes 11 reciters from Al Quran Cloud, per-Ayah streaming,
local Surah downloads, background playback, system media controls, automatic
Surah transitions, and playback-aware Ayah highlighting. All 11 Al Quran Cloud
edition catalogs returned 114 Surahs and 6,236 source URLs at the configured
bitrate; first and last CDN file checks returned HTTP 200. Intermediate CDN
availability, device behavior, and recording redistribution rights still
require separate verification.

The Channels tab contains exactly Makkah Live and Madinah Live cards. Because
an authorized in-app stream has not been verified, the cards open the
broadcaster's official pages externally and do not claim in-app playback.

iOS includes a native SwiftUI + WidgetKit Continue Reading extension with Small
and Medium families, App Group data sharing, exact Surah/Ayah deep links, app
icon assets, and Now Playing artwork. Source integration is present; device
behavior and platform builds have not been verified in this environment.

Flutter does not currently ship Sorani translations for its framework-owned
Material and Cupertino controls. Those controls use Arabic framework strings
in Sorani mode. A localized notice in Settings discloses this fallback; the
app's own interface is Sorani and the layout remains right-to-left. Arabic and
English continue to use their normal Flutter framework localizations.

## Development

```shell
flutter pub get
flutter gen-l10n
dart format .
flutter analyze
flutter test
```

Generated localization code is written to `lib/l10n/app_localizations.dart`;
edit the ARB source files rather than the generated file.

## Unsigned iOS IPA

The **Unsigned iOS Release IPA** workflow at
`.github/workflows/ios-unsigned-ipa.yml` is manual-only (`workflow_dispatch`).
When run, it builds on macOS without Apple signing credentials, checks for the
embedded WidgetKit extension, and uploads `Quran-unsigned.ipa` as the
`quran-unsigned-release-ipa` artifact. The unsigned IPA is not equivalent to a
normally signed App Store binary. Validate App Group access, deep linking, and
WidgetKit behavior on the target device before claiming compatibility.

## Tests and device checks

The focused Dart tests cover Quran data alignment, reader behavior, audio
queues/playback/downloads, channels, settings, and widget payload/deep links.
Device-specific acceptance steps and remaining verification items are in
[`docs/quran-audio-device-checklist.md`](docs/quran-audio-device-checklist.md)
and [`docs/live-channel-device-checklist.md`](docs/live-channel-device-checklist.md).
