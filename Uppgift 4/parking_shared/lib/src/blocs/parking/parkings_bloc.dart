import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_shared/parking_shared.dart';

part 'parkings_event.dart';
part 'parkings_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingsState> {
  final ParkingRepository repository;

  ParkingBloc({required this.repository}) : super(ParkingsInitial()) {
    on<ParkingEvent>((event, emit) async {
      try {
        switch (event) {
          case LoadParkings():
            await onLoadParkings(emit);

          case UpdateParking(parking: final finalParking):
            await onUpdateParking(finalParking, emit);

          case CreateParking(parking: final finalParking):
            await onCreateParking(finalParking, emit);

          case DeleteParking(parking: final finalParking):
            await onDeleteParking(finalParking, emit);
          case ReloadParkings():
            await onReloadParkings(emit);
        }
      } catch (e) {
        emit(ParkingsError(message: e.toString()));
      }
    });
  }

  Future<void> onReloadParkings(Emitter<ParkingsState> emit) async {
    final parkingsFromRepository = await repository.getAll();
    emit(ParkingsLoaded(parkings: parkingsFromRepository));
  }

  Future<void> onDeleteParking(
      Parking parking, Emitter<ParkingsState> emit) async {
    final currentParkings = switch (state) {
      ParkingsLoaded(parkings: final finalParkings) => [...finalParkings],
      _ => <Parking>[],
    };
    emit(ParkingsLoaded(parkings: currentParkings, pending: parking));

    await repository.delete(parking);
    final parkingsFromRepository = await repository.getAll();
    emit(ParkingsLoaded(parkings: parkingsFromRepository));
  }

  Future<void> onCreateParking(
      Parking parking, Emitter<ParkingsState> emit) async {
    final currentParkings = switch (state) {
      ParkingsLoaded(parkings: final finalParkings) => [...finalParkings],
      _ => <Parking>[],
    };
    currentParkings.add(parking);
    emit(ParkingsLoaded(parkings: currentParkings, pending: parking));

    await repository.add(parking);
    final parkingsFromRepository = await repository.getAll();
    emit(ParkingsLoaded(parkings: parkingsFromRepository));
  }

  Future<void> onUpdateParking(
      Parking parking, Emitter<ParkingsState> emit) async {
    final currentParkings = switch (state) {
      ParkingsLoaded(parkings: final finalParkings) => [...finalParkings],
      _ => <Parking>[],
    };
    var index = currentParkings.indexWhere((e) => parking.id == e.id);
    currentParkings.removeAt(index);
    currentParkings.insert(index, parking);
    emit(ParkingsLoaded(parkings: currentParkings, pending: parking));
    await repository.update(parking);
    final parkingsFromRepository = await repository.getAll();
    emit(ParkingsLoaded(parkings: parkingsFromRepository));
  }

  Future<void> onLoadParkings(Emitter<ParkingsState> emit) async {
    emit(ParkingsLoading());
    final parkingsFromRepository = await repository.getAll();
    emit(ParkingsLoaded(parkings: parkingsFromRepository));
  }
}
