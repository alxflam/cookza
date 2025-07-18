// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Taken from https://github.com/FirebaseExtended/flutterfire/blob/master/packages/cloud_firestore/cloud_firestore/test/mock.dart
// and added storage bucket handling from https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_storage/firebase_storage/test/mock.dart
// ignore: depend_on_referenced_packages
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback = void Function(MethodCall call);
const String kBucket = 'gs://fake-storage-bucket-url.com';

void setupMockFirebaseApp([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  TestFirebaseCoreHostApi.setUp(MockFirebaseApp());
}
