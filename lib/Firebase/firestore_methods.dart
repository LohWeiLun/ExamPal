import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exampal/Firebase/storage_method.dart';
import 'package:uuid/uuid.dart';

import '../Models/post.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Upload Post
  Future<String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String profImage,
      ) async {
    String res = "some error occured";
    try{
      String photoUrl = await StorageMethods().uploadImageToStorage('post', file, true);

      String postId = const Uuid().v1();
      Post post =   Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson(),);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}