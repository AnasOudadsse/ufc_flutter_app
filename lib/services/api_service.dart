import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/ranking.dart';
import '../models/champion.dart';
import '../models/fighter_summary.dart';
import '../models/fighter_detail.dart';

/// A service for talking to the Octagon API.
class ApiService {
  static const _baseUrl = 'https://api.octagon-api.com';

  /// Fetch all ranking categories (used to drive weight-class lists).
  Future<List<Ranking>> getRankings() async {
    final uri = Uri.parse('$_baseUrl/rankings');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Error fetching rankings (${response.statusCode})');
    }

    final List<dynamic> data = json.decode(response.body);
    return data
        .map((item) => Ranking.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetch a single division’s details (fighters list) by its [divisionId].
  Future<Ranking> getDivision(String divisionId) async {
    final uri = Uri.parse('$_baseUrl/division/$divisionId');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Error fetching division $divisionId');
    }

    final Map<String, dynamic> jsonMap = json.decode(response.body);
    // The `/division` endpoint returns the same shape as one element of /rankings
    return Ranking.fromJson(jsonMap);
  }

  /// Fetch detailed info for one fighter by [fighterId].
  Future<FighterDetail> getFighterDetail(String fighterId) async {
    final uri = Uri.parse('$_baseUrl/fighter/$fighterId');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Error fetching fighter $fighterId');
    }

    final Map<String, dynamic> jsonMap = json.decode(response.body);
    return FighterDetail.fromJson(jsonMap);
  }
}
