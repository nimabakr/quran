import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran/features/quran/presentation/quran_reading_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('reading progress persists and restores the exact Ayah', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(await container.read(quranReadingProgressProvider.future), isNull);

    const progress = QuranReadingProgress(surahNumber: 2, verseNumber: 255);
    await container.read(quranReadingProgressProvider.notifier).save(progress);

    expect(container.read(quranReadingProgressProvider).value, progress);
    final restored = await container
        .read(quranReadingProgressRepositoryProvider)
        .load();
    expect(restored?.surahNumber, 2);
    expect(restored?.verseNumber, 255);
  });

  test('invalid saved reading positions are not restored', () async {
    SharedPreferences.setMockInitialValues({'quran.reading_progress': '115:1'});
    final repository = const QuranReadingProgressRepository();

    expect(await repository.load(), isNull);
    await expectLater(
      repository.save(
        const QuranReadingProgress(surahNumber: 2, verseNumber: 287),
      ),
      throwsArgumentError,
    );
  });
}
