import 'package:flutter_test/flutter_test.dart';
import 'package:habi/config/routes/routes.dart';

void main() {
  test('shell titles follow the active route', () {
    expect(AppRoutePath.titleFor(AppRoutePath.dashboard), 'Home');
    expect(AppRoutePath.titleFor(AppRoutePath.airbnb), 'Airbnb');
    expect(AppRoutePath.titleFor(AppRoutePath.calendar), 'Calendar');
    expect(AppRoutePath.titleFor(AppRoutePath.chores), 'Chores');
    expect(AppRoutePath.titleFor('/unknown'), 'Habi');
  });
}
