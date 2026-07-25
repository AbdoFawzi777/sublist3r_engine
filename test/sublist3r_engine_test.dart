import 'package:flutter_test/flutter_test.dart';
import 'package:sublist3r_engine/sublist3r_engine.dart';

void main() {
  test('Sublist3rEngine initialization test', () async {
    final engine = Sublist3rEngine();
    await engine.initialize();
    expect(engine.isInitialized, true);
  });
}
