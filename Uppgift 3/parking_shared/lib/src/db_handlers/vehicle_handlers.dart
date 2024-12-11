import '../models/Vehicle.dart';
import '../repositories/Vehicle.repository.dart';

final vehicleRepository = VehicleRepository();

Future<List<Vehicle>> getAllVehiclesHandler() async {
  return await vehicleRepository.getAll();
}
