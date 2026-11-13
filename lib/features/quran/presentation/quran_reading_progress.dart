import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranReadingProgress {
  const QuranReadingProgress({
    required this.surahNumber,
    required this.verseNumber,
  });

  final int surahNumber;
  final int verseNumber;

  bool get isValid =>
      surahNumber >= 1 &&
      surahNumber <= 114 &&
      verseNumber >= 1 &&
      verseNumber <= 286;
}

class QuranReadingProgressRepository {
  const QuranReadingProgressRepository();

  static const _progressKey = 'quran.reading_progress';

  Future<QuranReadingProgress?> load() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(_progressKey);
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final surahNumber = int.tryParse(parts[0]);
    final verseNumber = int.tryParse(parts[1]);
    if (surahNumber == null || verseNumber == null) return null;

    final progress = QuranReadingProgress(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
    );
    return progress.isValid ? progress : null;
  }

  Future<void> save(QuranReadingProgress progress) async {
    if (!progress.isValid) {
      throw ArgumentError('The Quran reading position is invalid.');
    }

    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _progressKey,
      '${progress.surahNumber}:${progress.verseNumber}',
    );
    if (!saved) {
      throw StateError('The Quran reading position could not be saved.');
    }
  }
}

final quranReadingProgressRepositoryProvider =
    Provider<QuranReadingProgressRepository>(
      (ref) => const QuranReadingProgressRepository(),
    );

final quranReadingProgressProvider =
    AsyncNotifierProvider<
      QuranReadingProgressController,
      QuranReadingProgress?
    >(QuranReadingProgressController.new);

class QuranReadingProgressController
    extends AsyncNotifier<QuranReadingProgress?> {
  @override
  Future<QuranReadingProgress?> build() =>
      ref.watch(quranReadingProgressRepositoryProvider).load();

  Future<void> save(QuranReadingProgress progress) async {
    await ref.read(quranReadingProgressRepositoryProvider).save(progress);
    state = AsyncData(progress);
  }
}
