import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'database.g.dart';

@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError("SharedPrefenrecesProvider accessed before it was overwritten");
}
