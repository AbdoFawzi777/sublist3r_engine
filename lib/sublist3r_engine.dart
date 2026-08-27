import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'identity_shield.dart';

/// 🌐 Sublist3r Engine v9.0 - Multi-Source OSINT Subdomain Enumerator
class Sublist3rEngine {
  static final Sublist3rEngine _instance = Sublist3rEngine._internal();
  factory Sublist3rEngine() => _instance;
  Sublist3rEngine._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    _initialized = true;
  }

  /// 🚀 Multi-Source OSINT Aggregation & Wildcard Filtering
  Future<List<String>> enumerate(String rawDomain, {bool resolveIps = false}) async {
    if (!IdentityShield.check()) throw Exception("Security Violation: Core Integrity Check Failed");

    final cleanDomain = rawDomain.trim().replaceAll(RegExp(r'https?://'), '').split('/')[0].toLowerCase();
    final Set<String> results = {};
    
    final sources = [
      _fetchCrtSh(cleanDomain),
      _fetchHackerTarget(cleanDomain),
      _fetchAlienVault(cleanDomain),
    ];

    final all = await Future.wait(sources);
    for (final s in all) {
      for (final sub in s) {
        final sanitized = sub.replaceAll('*.', '').trim().toLowerCase();
        if (sanitized.isNotEmpty && (sanitized == cleanDomain || sanitized.endsWith('.$cleanDomain'))) {
          results.add(sanitized);
        }
      }
    }

    final sortedList = results.toList()..sort();
    return sortedList;
  }

  Future<List<String>> _fetchCrtSh(String domain) async {
    try {
      final resp = await http.get(
        Uri.parse('https://crt.sh/?q=%25.$domain&output=json'),
        headers: {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'},
      ).timeout(const Duration(seconds: 8));

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List;
        final list = <String>[];
        for (final item in data) {
          final name = item['name_value'] ?? item['common_name'];
          if (name != null) {
            for (final sub in name.toString().split('\n')) {
              list.add(sub.trim());
            }
          }
        }
        return list;
      }
    } catch (_) {}
    return [];
  }

  Future<List<String>> _fetchHackerTarget(String domain) async {
    try {
      final resp = await http.get(
        Uri.parse('https://api.hackertarget.com/hostsearch/?q=$domain'),
        headers: {'User-Agent': 'RedOps-Hub/9.0'},
      ).timeout(const Duration(seconds: 6));

      if (resp.statusCode == 200 && !resp.body.contains('error')) {
        return resp.body
            .split('\n')
            .where((l) => l.contains(','))
            .map((l) => l.split(',')[0].trim().toLowerCase())
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<String>> _fetchAlienVault(String domain) async {
    try {
      final resp = await http.get(
        Uri.parse('https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns'),
      ).timeout(const Duration(seconds: 8));

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final list = data['passive_dns'] as List? ?? [];
        return list.map((e) => e['hostname'].toString().trim().toLowerCase()).toList();
      }
    } catch (_) {}
    return [];
  }
}
