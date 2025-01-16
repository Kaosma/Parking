import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_shared/parking_shared.dart';

part 'parking_spaces_event.dart';
part 'parking_spaces_state.dart';

class ParkingSpaceBloc extends Bloc<ParkingSpaceEvent, ParkingSpacesState> {
  final ParkingSpaceRepository repository;

  ParkingSpaceBloc({required this.repository}) : super(ParkingSpacesInitial()) {
    on<ParkingSpaceEvent>((event, emit) async {
      try {
        switch (event) {
          case LoadParkingSpaces():
            await onLoadParkingSpaces(emit);

          case UpdateParkingSpace(parkingSpace: final finalParkingSpace):
            await onUpdateParkingSpace(finalParkingSpace, emit);

          case CreateParkingSpace(parkingSpace: final finalParkingSpace):
            await onCreateParkingSpace(finalParkingSpace, emit);

          case DeleteParkingSpace(parkingSpace: final finalParkingSpace):
            await onDeleteParkingSpace(finalParkingSpace, emit);
          case ReloadParkingSpaces():
            await onReloadParkingSpaces(emit);
        }
      } catch (e) {
        emit(ParkingSpacesError(message: e.toString()));
      }
    });
  }

  Future<void> onReloadParkingSpaces(Emitter<ParkingSpacesState> emit) async {
    final parkingSpacesFromRepository = await repository.getAll();
    emit(ParkingSpacesLoaded(parkingSpaces: parkingSpacesFromRepository));
  }

  Future<void> onDeleteParkingSpace(
      ParkingSpace parkingSpace, Emitter<ParkingSpacesState> emit) async {
    final currentParkingSpaces = switch (state) {
      ParkingSpacesLoaded(parkingSpaces: final finalParkingSpaces) => [
          ...finalParkingSpaces
        ],
      _ => <ParkingSpace>[],
    };
    emit(ParkingSpacesLoaded(
        parkingSpaces: currentParkingSpaces, pending: parkingSpace));

    await repository.delete(parkingSpace);
    final parkingSpacesFromRepository = await repository.getAll();
    emit(ParkingSpacesLoaded(parkingSpaces: parkingSpacesFromRepository));
  }

  Future<void> onCreateParkingSpace(
      ParkingSpace parkingSpace, Emitter<ParkingSpacesState> emit) async {
    final currentParkingSpaces = switch (state) {
      ParkingSpacesLoaded(parkingSpaces: final finalParkingSpaces) => [
          ...finalParkingSpaces
        ],
      _ => <ParkingSpace>[],
    };
    currentParkingSpaces.add(parkingSpace);
    emit(ParkingSpacesLoaded(
        parkingSpaces: currentParkingSpaces, pending: parkingSpace));

    await repository.add(parkingSpace);
    final parkingSpacesFromRepository = await repository.getAll();
    emit(ParkingSpacesLoaded(parkingSpaces: parkingSpacesFromRepository));
  }

  Future<void> onUpdateParkingSpace(
      ParkingSpace parkingSpace, Emitter<ParkingSpacesState> emit) async {
    final currentParkingSpaces = switch (state) {
      ParkingSpacesLoaded(parkingSpaces: final finalParkingSpaces) => [
          ...finalParkingSpaces
        ],
      _ => <ParkingSpace>[],
    };
    var index = currentParkingSpaces.indexWhere((e) => parkingSpace.id == e.id);
    currentParkingSpaces.removeAt(index);
    currentParkingSpaces.insert(index, parkingSpace);
    emit(ParkingSpacesLoaded(
        parkingSpaces: currentParkingSpaces, pending: parkingSpace));
    await repository.update(parkingSpace);
    final parkingSpacesFromRepository = await repository.getAll();
    emit(ParkingSpacesLoaded(parkingSpaces: parkingSpacesFromRepository));
  }

  Future<void> onLoadParkingSpaces(Emitter<ParkingSpacesState> emit) async {
    emit(ParkingSpacesLoading());
    final parkingSpacesFromRepository = await repository.getAll();
    emit(ParkingSpacesLoaded(parkingSpaces: parkingSpacesFromRepository));
  }
}
