import 'dart:io';

import 'package:cookza/services/local_storage.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/shopping_list/shopping_list_items_generator.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  NavigatorObserver,
  ShoppingListItemsGenerator,
  StorageProvider,
  ImageManager
])
class Dummy {
  // just a dummy class to generate mocks
}
