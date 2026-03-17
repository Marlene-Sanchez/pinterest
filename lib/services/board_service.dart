import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinterest/models/board_model.dart';

class BoardService {

  Future<void> createBoard(Board board) async {

  await FirebaseFirestore.instance
      .collection('boards')
      .add(board.toMap());
}
  Future<void> savePin(String pinId, String boardId) async {

  final user = FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance.collection("board_pins").add({

    "pinId": pinId,
    "boardId": boardId,
    "userId": user!.uid,
    "savedAt": Timestamp.now()

  });

}

  Stream<List<Board>>? getBoards(String userId) {
    return FirebaseFirestore.instance
        .collection('boards')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Board.fromMap(doc.id, doc.data())).toList());
  }
}