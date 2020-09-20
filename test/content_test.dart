import 'package:flutter_test/flutter_test.dart';
import 'package:flyt/domain/content.dart';

void main() {
  test('should fail if content is being accessed without having been loaded',
      () {
    expect(
      () => Content().content(),
      throwsA(
        isA<ContentNotLoadedException>(),
      ),
    );
  });
}
