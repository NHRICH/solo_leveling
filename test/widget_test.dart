import 'package:flutter_test/flutter_test.dart';

import 'package:solo_leveling/core/services/notification_service.dart';

void main() {
  final NotificationService service = NotificationService();

  group('Focus Dungeon notifications', () {
    test('scheduleFocusCompletion skips scheduling for null time', () async {
      // No platform instance is available in a pure unit test, but this path
      // must return early without touching the plugin.
      await service.scheduleFocusCompletion(when: null);
    });

    test('scheduleFocusCompletion skips scheduling for past time', () async {
      final past = DateTime.now().subtract(const Duration(seconds: 5));
      await service.scheduleFocusCompletion(when: past);
    });

    test('cancelFocusCountdownNotification is a safe no-op before init',
        () async {
      // The platform plugin isn't registered in unit tests; the cancel methods
      // are hardened in dispose() so they must not throw.
      await service.cancelFocusCountdownNotification();
    });

    test('cancelFocusCompletion is a safe no-op before init', () async {
      await service.cancelFocusCompletion();
    });
  });
}
