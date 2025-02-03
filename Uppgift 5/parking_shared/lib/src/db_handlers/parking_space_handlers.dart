import '../models/ParkingSpace.dart';
import '../repositories/ParkingSpace.repository.dart';
import '../utils/constants.dart';

final parkingSpaceRepository = ParkingSpaceRepository();

Future<List<ParkingSpace>> getAllParkingSpacesHandler() async {
  return await parkingSpaceRepository.getAll();
}

Future<ParkingSpace?> getParkingSpaceHandler() async {
  return await parkingSpaceRepository.getById(AppStrings.userId);
}
