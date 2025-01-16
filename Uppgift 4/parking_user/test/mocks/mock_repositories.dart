import 'package:mocktail/mocktail.dart';
import 'package:parking_shared/parking_shared.dart';

class MockPersonRepository extends Mock implements PersonRepository {}

class PersonMock extends Fake implements Person {}

class MockVehicleRepository extends Mock implements VehicleRepository {}

class VehicleMock extends Fake implements Vehicle {}

class MockParkingSpaceRepository extends Mock
    implements ParkingSpaceRepository {}

class ParkingSpaceMock extends Fake implements ParkingSpace {}

class MockParkingRepository extends Mock implements ParkingRepository {}

class ParkingMock extends Fake implements Parking {}
