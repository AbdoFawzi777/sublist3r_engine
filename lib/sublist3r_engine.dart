import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

/// 🌐 Sublist3r Engine v6.0 - Absolute Perfection
class Sublist3rEngine {
  static final Sublist3rEngine _instance = Sublist3rEngine._internal();
  factory Sublist3rEngine() => _instance;
  Sublist3rEngine._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    _initialized = true;
  }

  /// 🚀 Absolute Enumeration Logic: Multi-Source Aggregation
  Future<List<String>> enumerate(String domain) async {
    final Set<String> results = {};
    
    final sources = [
      _fetchCrtSh(domain),
      _fetchHackerTarget(domain),
      _fetchBufferOver(domain),
    ];

    final all = await Future.wait(sources);
    for (final s in all) { results.addAll(s); }

    return results.toList()..sort();
  }

  Future<List<String>> _fetchCrtSh(String domain) async {
    try {
      final resp = await http.get(Uri.parse('https://crt.sh/?q=%.$domain&output=json')).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List;
        return data.map((e) => e['name_value'].toString().toLowerCase()).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<String>> _fetchHackerTarget(String domain) async {
    try {
      final resp = await http.get(Uri.parse('https://api.hackertarget.com/hostsearch/?q=$domain')).timeout(const Duration(seconds: 8));
      if (resp.statusCode == 200) {
        return resp.body.split('\n').map((line) => line.split(',')[0].toLowerCase()).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<String>> _fetchBufferOver(String domain) async {
    try {
      final resp = await http.get(Uri.parse('https://dns.bufferover.run/dns?q=.$domain')).timeout(const Duration(seconds: 8));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final results = data['FDNS_A'] as List? ?? [];
        return results.map((e) => e.toString().split(',')[1].toLowerCase()).toList();
      }
    } catch (_) {}
    return [];
  }
}
