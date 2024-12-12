import '../models/Person.dart';
import '../repositories/Person.repository.dart';

final personRepository = PersonRepository();

Future<List<Person>> getAllOwnersHandler() async {
  return await personRepository.getAll();
}

Future<Person?> getOwnerHandler(String ownerId) async {
  return await personRepository.getById(ownerId);
}
