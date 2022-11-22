import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class UserRepository {
  Future<void> createMe();

  Future<User?> fetchMe();

  Stream<User?> snapshotMe();

  Future<void> deleteMe();
}

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  const UserRepositoryImpl(this._firestore,
      this._auth,);

  CollectionReference<User> get collectionReference =>
      _firestore.collection(User.collectionName).withConverter<User>(
        fromFirestore: (snapshot, _) =>
            User.fromJson(snapshot.data() ?? {}),
        toFirestore: (user, _) => user.toJson(),
      );

  DocumentReference<User> get myReference =>
      _firestore
          .collection(User.collectionName)
          .doc(_auth.currentUser?.uid ?? "")
          .withConverter<User>(
        fromFirestore: (snapshot, _) => User.fromJson(snapshot.data() ?? {}),
        toFirestore: (user, _) => user.toJson(),
      );

  String? get uid => _auth.currentUser?.uid;

  @override
  Future<void> createMe() async {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) {
      final result = await _auth.signInAnonymously();
      uid = result.user!.uid;
    }
    final me = User(id: uid);
    await myReference.set(me);
  }

  @override
  Future<void> deleteMe() async {
    await myReference.delete();
    await _auth.currentUser?.delete();
  }

  @override
  Future<User?> fetchMe() async {
    try {
      final snapshot = await myReference.get();
      final user = snapshot.data();
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<User?> snapshotMe() {
    final stream = myReference.snapshots();
    return stream.map((snapshot) => snapshot.data());
  }
}

final Provider<UserRepository> userRepositoryProvider = Provider((ref) {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  return UserRepositoryImpl(firestore, auth);
});

final StreamProvider<User?> meProvider = StreamProvider((ref) {
  final UserRepository userRepository = ref.watch(userRepositoryProvider);
  final me = userRepository.snapshotMe();
  return me;
});
