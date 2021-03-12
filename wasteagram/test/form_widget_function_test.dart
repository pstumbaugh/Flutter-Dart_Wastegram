import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/imports.dart';
import 'package:wasteagram/widgets/form_widget.dart';

void main() {
  test('Correct Value Entered in Form test', () {
    var result = _FormWidgetState.isNumAndPos('3');
    expect(result, 'Enter Email!');
  });
}
