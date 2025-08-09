import 'package:cloud_firestore/cloud_firestore.dart';

class MovieRent {
  final String? rentId;
  final int movieId;
  final String title;
  final String posterUrl;
  final Timestamp rentDate;   // stored as Timestamp for Firestore
  final Timestamp expireAt;   // stored as Timestamp for Firestore
  final int duration;
  final int pricePerDay;
  final int totalPrice;
  final Timestamp? returnDate; // optional, stored as Timestamp if returned

  MovieRent({
    this.rentId,
    required this.movieId,
    required this.title,
    required this.posterUrl,
    required this.rentDate,
    required this.expireAt,
    required this.duration,
    required this.pricePerDay,
    required this.totalPrice,
    this.returnDate,
  });

  /// Computed status (never stored)
  /// - 'returned' if returnDate exists
  /// - 'expired' if now > expireAt
  /// - 'active' otherwise
  String get status {
    final now = DateTime.now();
    if (returnDate != null) return 'returned';
    if (now.isAfter(expireAt.toDate())) return 'expired';
    return 'active';
  }

  Map<String, dynamic> toJson() {
    return {
      if (rentId != null) 'rentId': rentId,
      'movieId': movieId,
      'title': title,
      'posterUrl': posterUrl,
      'rentDate': rentDate,
      'expireAt': expireAt,
      'duration': duration,
      'pricePerDay': pricePerDay,
      'totalPrice': totalPrice,
      if (returnDate != null) 'returnDate': returnDate,
    };
  }

  factory MovieRent.fromJson(Map<String, dynamic> json, String docId) {
    // Safe extraction with fallback / defensive parsing
    final dynamic rentDateRaw = json['rentDate'];
    final dynamic expireAtRaw = json['expireAt'];
    final dynamic returnDateRaw = json['returnDate'];

    Timestamp parseTs(dynamic v) {
      if (v == null) return Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(0));
      if (v is Timestamp) return v;
      // if stored as ISO string in some edge case
      if (v is String) return Timestamp.fromDate(DateTime.parse(v));
      throw ArgumentError('Unsupported timestamp format: ${v.runtimeType}');
    }

    return MovieRent(
      rentId: docId,
      movieId: (json['movieId'] ?? 0) as int,
      title: (json['title'] ?? '') as String,
      posterUrl: (json['posterUrl'] ?? '') as String,
      rentDate: parseTs(rentDateRaw),
      expireAt: parseTs(expireAtRaw),
      duration: (json['duration'] ?? 0) as int,
      pricePerDay: (json['pricePerDay'] ?? 0) as int,
      totalPrice: (json['totalPrice'] ?? 0) as int,
      returnDate: returnDateRaw == null ? null : (returnDateRaw is Timestamp ? returnDateRaw : Timestamp.fromDate(DateTime.parse(returnDateRaw.toString()))),
    );
  }
}
