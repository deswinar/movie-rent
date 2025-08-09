import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_rent/core/helpers/filter_constraint.dart';
import 'package:movie_rent/data/models/movie_rent.dart';

class RentRepository {
  final FirebaseFirestore _firestore;

  RentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _rentsRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('rents');
  }

  // Public getter for reference
  CollectionReference<Map<String, dynamic>> rentsRef(String userId) => _rentsRef(userId);

  // Create new rent
  Future<void> createRent(String userId, MovieRent rent) async {
    final docRef = await _rentsRef(userId).add(rent.toJson());
    await docRef.update({'rentId': docRef.id});
  }

  // Get a specific rent
  Future<MovieRent?> getRent(String userId, String rentId) async {
    final doc = await _rentsRef(userId).doc(rentId).get();
    if (!doc.exists) return null;
    return MovieRent.fromJson(doc.data()!, doc.id);
  }

  // Stream all rents ordered by rentDate desc
  Stream<List<MovieRent>> rentStream(String userId) {
    return _rentsRef(userId)
        .orderBy('rentDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MovieRent.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Get all active rents (not expired)
  Future<List<MovieRent>> getActiveRents(String userId) async {
    final snapshot = await _rentsRef(userId)
        .where('expireAt', isGreaterThan: Timestamp.now())
        .orderBy('expireAt', descending: false)
        .get();

    final rents = snapshot.docs
        .map((doc) => MovieRent.fromJson(doc.data(), doc.id))
        .toList();

    // Filter in memory for status 'active'
    return rents.where((rent) => rent.status == 'active').toList();
  }

  // Update rent status
  Future<void> updateRentStatus(String userId, String rentId, String status) async {
    await _rentsRef(userId).doc(rentId).update({'status': status});
  }

  // Generic method for paginated, filtered, and sorted fetch
  Future<List<MovieRent>> getRentedMovies({
    required String userId,
    int? limit,
    DocumentSnapshot? lastDoc,
    Map<String, FilterConstraint>? filters,
    String orderBy = 'rentDate',
    bool descending = true,
  }) async {
    return _queryRents(
      userId: userId,
      limit: limit,
      lastDoc: lastDoc,
      filters: filters,
      orderBy: orderBy,
      descending: descending,
    );
  }

  // PRIVATE QUERY METHOD
  Future<List<MovieRent>> _queryRents({
    required String userId,
    int? limit,
    DocumentSnapshot? lastDoc,
    Map<String, FilterConstraint>? filters,
    String? orderBy,
    bool descending = true,
  }) async {
    Query query = _rentsRef(userId);

    // Apply filters except 'status'
    filters?.forEach((field, constraint) {
      if (field == 'status') return; // skip, handled in memory

      if (constraint.isEqualTo != null) {
        query = query.where(field, isEqualTo: constraint.isEqualTo);
      }
      if (constraint.isGreaterThan != null) {
        query = query.where(field, isGreaterThan: constraint.isGreaterThan);
      }
      if (constraint.isLessThan != null) {
        query = query.where(field, isLessThan: constraint.isLessThan);
      }
    });

    // Sorting
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    // Pagination
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    // Limit
    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    var rents = snapshot.docs
        .map((doc) => MovieRent.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    // In-memory status filtering if requested
    if (filters?['status']?.isEqualTo != null) {
      final statusValue = filters!['status']!.isEqualTo as String;
      rents = rents.where((rent) => rent.status == statusValue).toList();
    }

    return rents;
  }
}
