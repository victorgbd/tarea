// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tarea/main.dart';

import 'package:flutter/services.dart';

void main() {
  testWidgets('Camera open', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
  int vari = 1;
  test('variable run', () => {expect(vari, 1)});
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/image_picker');

  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      return '';
    });

    log.clear();
  });
  group('#pickImage', () {
    test('passes the image source argument correctly', () async {
      await ImagePicker().pickImage(source: ImageSource.camera);
      await ImagePicker().pickImage(source: ImageSource.gallery);

      expect(
        log,
        <Matcher>[
          isMethodCall('pickImage', arguments: <String, dynamic>{
            'source': 0,
            'maxWidth': null,
            'maxHeight': null,
            'imageQuality': null,
            'cameraDevice': 0,
            'requestFullMetadata': true
          }),
          isMethodCall('pickImage', arguments: <String, dynamic>{
            'source': 1,
            'maxWidth': null,
            'maxHeight': null,
            'imageQuality': null,
            'cameraDevice': 0,
            'requestFullMetadata': true
          }),
        ],
      );
    });

    test('passes the width and height arguments correctly', () async {
      await ImagePicker().pickImage(source: ImageSource.camera);
      await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 10.0,
      );
      await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 10.0,
      );
      await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 10.0,
        maxHeight: 20.0,
      );

      expect(
        log,
        <Matcher>[
          isMethodCall('pickImage', arguments: <String, dynamic>{
            'source': 0,
            'maxWidth': null,
            'maxHeight': null,
            'imageQuality': null,
            'cameraDevice': 0,
            'requestFullMetadata': true
          }),
          isMethodCall('pickImage', arguments: <String, dynamic>{
            'source': 0,
            'maxWidth': 10.0,
            'maxHeight': null,
            'imageQuality': null,
            'cameraDevice': 0,
            'requestFullMetadata': true
          }),
          isMethodCall('pickImage', arguments: <String, dynamic>{
            'source': 0,
            'maxWidth': null,
            'maxHeight': 10.0,
            'imageQuality': null,
            'cameraDevice': 0,
            'requestFullMetadata': true
          }),
          isMethodCall('pickImage', arguments: <String, dynamic>{
            'source': 0,
            'maxWidth': 10.0,
            'maxHeight': 20.0,
            'imageQuality': null,
            'cameraDevice': 0,
            'requestFullMetadata': true
          }),
        ],
      );
    });

    test('does not accept a negative width or height argument', () {
      expect(
        ImagePicker().pickImage(source: ImageSource.camera, maxWidth: -1.0),
        throwsException,
      );

      expect(
        ImagePicker().pickImage(source: ImageSource.camera, maxHeight: -1.0),
        throwsException,
      );
    });

    test('handles a null image path response gracefully', () async {
      channel.setMockMethodCallHandler((MethodCall methodCall) => null);

      expect(
          await ImagePicker().pickImage(source: ImageSource.gallery), isNull);
      expect(await ImagePicker().pickImage(source: ImageSource.camera), isNull);
    });
  });
}
