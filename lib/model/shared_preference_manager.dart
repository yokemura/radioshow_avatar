import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  static Future<void> storeAudioLevels({
    required double lower,
    required double upper,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lower', lower);
    prefs.setDouble('upper', upper);
  }

  Future<(double lower, double upper)?> getAudioLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final lower = prefs.getDouble('lower');
    final upper = prefs.getDouble('upper');

    if (lower == null || upper == null) {
      return null;
    }

    return (lower, upper);
  }
}
