/// 🌐 Sublist3r Engine - Subdomain enumeration for Flutter
library sublist3r_engine;

import 'dart:convert';
import 'package:http/http.dart' as http;

class Sublist3rEngine {
  static final Sublist3rEngine _instance = Sublist3rEngine._internal();
  factory Sublist3rEngine() => _instance;
  Sublist3rEngine._internal();

  bool _initialized = false;

  /// 🚀 تهيئة المحرك
  Future<void> initialize() async {
    _initialized = true;
  }

  /// 🔍 تعداد النطاقات الفرعية
  Future<List<String>> enumerate(String domain) async {
    final subdomains = <String>{};

    // 1. crt.sh
    try {
      final response = await http.get(
        Uri.parse('https://crt.sh/?q=%.$domain&output=json'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (final entry in data) {
          final name = entry['name_value'] as String?;
          if (name != null && name.contains(domain)) {
            subdomains.add(name);
          }
        }
      }
    } catch (_) {}

    // 2. Hackertarget
    try {
      final response = await http.get(
        Uri.parse('https://api.hackertarget.com/hostsearch/?q=$domain'),
      );
      if (response.statusCode == 200) {
        final lines = response.body.split('\n');
        for (final line in lines) {
          final parts = line.split(',');
          if (parts.isNotEmpty && parts[0].contains(domain)) {
            subdomains.add(parts[0]);
          }
        }
      }
    } catch (_) {}

    return subdomains.toList();
  }

  bool get isInitialized => _initialized;
}
