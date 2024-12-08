import 'Team.dart';

class Match {
  final String id;
  final Team teamA;
  final Team teamB;
  final DateTime date;

  Match({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.date,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['_id'] as String,
      teamA: Team.fromJson(json['teamA']), // Parse teamA as Team object
      teamB: Team.fromJson(json['teamB']), // Parse teamB as Team object
      date: DateTime.parse(json['date']),
    );
  }
}
