import 'package:firebase_auth/firebase_auth.dart';

import '../models/Person.dart';
import '../repositories/Person.repository.dart';

final personRepository = PersonRepository();
final _auth = FirebaseAuth.instance;

Future<List<Person>> getAllOwnersHandler() async {
  return await personRepository.getAll();
}

Future<Person?> getOwnerHandler(String userEmail, String userPassword) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
        email: userEmail, password: userPassword);
    final user = credential.user;
    if (user != null) {
      return await personRepository.getById(user.uid);
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Stream<Person?> get userStream {
  return _auth.authStateChanges().asyncMap((changedUser) async {
    if (changedUser == null) {
      return null;
    } else {
      return await personRepository.getById(changedUser.uid);
    }
  });
}

Future signOutHandler() async {
  try {
    await _auth.signOut();
  } catch (e) {
    print(e);
  }
}
