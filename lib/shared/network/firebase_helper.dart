import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // CREATE (Add new document)
  Future<QuerySnapshot?> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
      return await _firestore.collection(collection).get();
      print("Document added successfully.");
    } catch (e) {
      print("Error adding document: $e");
      return null;
    }
  }

  // CREATE (Add new document)
  Future<QuerySnapshot?> addDocumentWithSpacificDocID(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc('$docId').set(data);
      return await _firestore.collection(collection).get();
      print("Document added successfully.");
    } catch (e) {
      print("Error adding document: $e");
      return null;
    }
  }

  // READ (Get all documents in a collection)
  Future<List<QueryDocumentSnapshot>> getAllDocuments(String collection) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collection).get();
      return querySnapshot.docs;
    } catch (e) {
      print("Error getting documents: $e");
      return [];
    }
  }

  // READ (Get a single document by ID)
  Future<DocumentSnapshot?> getDocumentById(String collection, String docId) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection(collection).doc(docId).get();
      return docSnapshot;
    } catch (e) {
      print("Error getting document: $e");
      return null;
    }
  }

  // UPDATE (Update a document by ID)
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
      print("Document updated successfully.");
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  // DELETE (Delete a document by ID)
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
      print("Document deleted successfully.");
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  // SEARCH (Query documents based on a specific field value)
  Future<List<QueryDocumentSnapshot>> searchDocuments(
      String collection, String field, dynamic value) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where(field, isEqualTo: value)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print("Error searching documents: $e");
      return [];
    }
  }

  // FILTER (Query documents with range conditions)
  Future<List<QueryDocumentSnapshot>> filterDocuments(
      String collection, String field, dynamic startValue, dynamic endValue) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where(field, isGreaterThan: startValue)
          .where(field, isLessThanOrEqualTo: endValue)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print("Error filtering documents: $e");
      return [];
    }
  }

  // PAGINATION (Query documents with pagination)
  Future<List<QueryDocumentSnapshot>> getDocumentsWithPagination(
      String collection, int limit, DocumentSnapshot? lastDocument) async {
    try {
      Query query = _firestore.collection(collection).limit(limit);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      QuerySnapshot querySnapshot = await query.get();
      return querySnapshot.docs;
    } catch (e) {
      print("Error paginating documents: $e");
      return [];
    }
  }

  Future<String> uploadImage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = _storage.ref().child('user_images/$fileName');
    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> updateImage(File image, String oldPath) async {
    // If the old image exists, delete it
    if (oldPath.isNotEmpty) {
      await _storage.refFromURL(oldPath).delete();
    }
    String downloadUrl = await uploadImage(image);
    return downloadUrl;
  }
}
