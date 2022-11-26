import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/entities/emotion.dart';
import 'package:domain/entities/viary.dart';
import 'package:domain/networking/api_client.dart';
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

  Future<Viary> refreshEmotions({required Viary viary});
}

class ViaryRepositoryImpl implements ViaryRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final ApiClient _apiClient;

  const ViaryRepositoryImpl(
    this._firestore,
    this._auth,
    this._apiClient,
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

  @override
  Future<Viary> refreshEmotions({required Viary viary}) async {
    final response = await _apiClient.get("text2emotion?text=${viary.message}");
    final jsonResponse = jsonDecode(response);
    final results = jsonResponse["results"] as List;
    if (results.isEmpty) {
      return viary;
    }
    final result = results[0][0];
    final emotion = Emotion.values.firstWhere(
      (element) => element.name == result["label"],
    );
    final score = ((result["score"] as double) * 100).toInt();
    viary = viary.copyWith(
      emotions: [
        ViaryEmotion(
          sentence: viary.message,
          score: score,
          emotion: emotion,
        ),
      ],
    );
    return viary;
  }
}

final Provider<ViaryRepository> viaryRepositoryProvider = Provider((ref) {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final apiClient = ref.read(apiClientProvider);
  return ViaryRepositoryImpl(
    firestore,
    auth,
    apiClient,
  );
});
