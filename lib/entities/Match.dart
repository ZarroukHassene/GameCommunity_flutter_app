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
      teamA: Team.fromJson(json['teamA']),
      teamB: Team.fromJson(json['teamB']),
      date: DateTime.parse(json['date']),
    );
  }
}
