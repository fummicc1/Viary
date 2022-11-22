import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/entities/viary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ViaryRepository {
  CollectionReference<Viary> get collectionReference;

  Viary generateNewViary();

  Future<void> create(Viary viary);

  Future<void> update({
    required String id,
    required Viary viary,
  });

  Future<Viary> fetch({required String id});

  Future<List<Viary>> fetchAll({bool withCache = true});

  Future<List<Viary>> fetchQuery({required Query<Viary> query});

  Stream<List<Viary>> snapshots({Query<Viary>? query});

  Future<void> delete({required String id});
}

class ViaryRepositoryImpl implements ViaryRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  const ViaryRepositoryImpl(
    this._firestore,
    this._auth,
  );

  CollectionReference<Viary> get collectionReference =>
      _firestore.collection(Viary.collectionName).withConverter<Viary>(
            fromFirestore: (snapshot, _) =>
                Viary.fromJson(snapshot.data() ?? {}),
            toFirestore: (viary, _) => viary.toJson(),
          );

  @override
  Viary generateNewViary() {
    return Viary(
      title: "",
      message: "",
      date: DateTime.now(),
    );
  }

  @override
  Future<void> create(Viary viary) async {
    final doc = collectionReference.doc();
    final sender = _auth.currentUser!.uid;
    viary = viary.copyWith(
      id: doc.id,
      sender: sender,
    );
    await doc.set(viary);
  }

  @override
  Future<void> delete({required String id}) async {
    await collectionReference.doc(id).delete();
  }

  @override
  Future<Viary> fetch({required String id}) async {
    final snapshot = await collectionReference.doc(id).get();
    final viary = snapshot.data();
    if (viary != null) {
      return viary;
    }
    throw UnimplementedError();
  }

  @override
  Future<List<Viary>> fetchAll({bool withCache = true}) async {
    final GetOptions options = GetOptions(
      source: withCache ? Source.cache : Source.serverAndCache,
    );
    final response = await collectionReference.get(options);
    return response.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<List<Viary>> fetchQuery({required Query<Viary> query}) async {
    final snapshots = await query.get();
    return snapshots.docs.map((doc) => doc.data()).toList();
  }

  @override
  Stream<List<Viary>> snapshots({Query<Viary>? query}) {
    final snapshots = query?.snapshots() ?? collectionReference.snapshots();
    return snapshots.map(
      (snapshots) => snapshots.docs.map((doc) => doc.data()).toList(),
    );
  }

  @override
  Future<void> update({required String id, required Viary viary}) async {
    await collectionReference.doc(id).set(
          viary,
          SetOptions(merge: true),
        );
  }
}

final Provider<ViaryRepository> viaryRepositoryProvider = Provider((ref) {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  return ViaryRepositoryImpl(
    firestore,
    auth,
  );
});
