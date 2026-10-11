import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection References
  CollectionReference get _usersRef => _firestore.collection('users');

  // ==================== USER PROFILE ====================

  /// Save or Update User Profile in Firestore
  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    await _usersRef.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Get User Profile Document
  Future<DocumentSnapshot> getUserProfile(String uid) async {
    return await _usersRef.doc(uid).get();
  }

  /// Stream User Profile
  Stream<DocumentSnapshot> streamUserProfile(String uid) {
    return _usersRef.doc(uid).snapshots();
  }

  // ==================== TRANSACTIONS / EXPENSES ====================

  /// Add a New Expense or Income Transaction
  Future<DocumentReference> addTransaction({
    required String uid,
    required String title,
    required double amount,
    required String category,
    required bool isExpense,
    String? receiptUrl,
    DateTime? date,
  }) async {
    return await _usersRef.doc(uid).collection('transactions').add({
      'title': title,
      'amount': amount,
      'category': category,
      'isExpense': isExpense,
      'receiptUrl': receiptUrl,
      'date': Timestamp.fromDate(date ?? DateTime.now()),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Stream All Transactions for a User (Sorted by Date Descending)
  Stream<QuerySnapshot> streamTransactions(String uid) {
    return _usersRef
        .doc(uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots();
  }

  /// Delete a Transaction
  Future<void> deleteTransaction({
    required String uid,
    required String transactionId,
  }) async {
    await _usersRef
        .doc(uid)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }

  /// Update an Existing Transaction
  Future<void> updateTransaction({
    required String uid,
    required String transactionId,
    required Map<String, dynamic> data,
  }) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _usersRef
        .doc(uid)
        .collection('transactions')
        .doc(transactionId)
        .update(data);
  }

  // ==================== BUDGETS ====================

  /// Set or Update a Monthly Category Budget
  Future<void> setBudget({
    required String uid,
    required String category,
    required double limitAmount,
  }) async {
    await _usersRef.doc(uid).collection('budgets').doc(category).set({
      'category': category,
      'limitAmount': limitAmount,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Stream All Category Budgets
  Stream<QuerySnapshot> streamBudgets(String uid) {
    return _usersRef.doc(uid).collection('budgets').snapshots();
  }

  /// Delete a Budget
  Future<void> deleteBudget({
    required String uid,
    required String category,
  }) async {
    await _usersRef.doc(uid).collection('budgets').doc(category).delete();
  }

  // ==================== SAVING GOALS ====================

  /// Add a New Saving Goal
  Future<DocumentReference> addSavingGoal({
    required String uid,
    required String title,
    required double targetAmount,
    double currentAmount = 0.0,
    DateTime? targetDate,
  }) async {
    return await _usersRef.doc(uid).collection('saving_goals').add({
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate != null ? Timestamp.fromDate(targetDate) : null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Stream All Saving Goals
  Stream<QuerySnapshot> streamSavingGoals(String uid) {
    return _usersRef.doc(uid).collection('saving_goals').snapshots();
  }

  /// Update Goal Contribution Amount
  Future<void> updateGoalContribution({
    required String uid,
    required String goalId,
    required double newAmount,
  }) async {
    await _usersRef.doc(uid).collection('saving_goals').doc(goalId).update({
      'currentAmount': newAmount,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
