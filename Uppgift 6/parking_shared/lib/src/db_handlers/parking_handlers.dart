import '../models/Parking.dart';
import '../repositories/Parking.repository.dart';

final parkingRepository = ParkingRepository();

Future<List<Parking>> getAllParkingsHandler() async {
  return await parkingRepository.getAll();
}
