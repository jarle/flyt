import 'package:uuid/uuid.dart';

class Identifier {
  final String _id;
  Identifier(String id) : _id = _validateId(id);

  String get id => _id;

  static Identifier generate() {
    return Identifier(
      Uuid().v4()
    );
  }

  static String _validateId(String id) {
    return id; //TODO: validate uuid format
  }

  @override
  String toString() {
    return '$_id';
  }
}