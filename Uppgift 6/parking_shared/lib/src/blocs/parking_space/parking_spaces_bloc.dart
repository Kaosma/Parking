import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/ParkingSpace.dart';
import '../../repositories/ParkingSpace.repository.dart';

part 'parking_spaces_event.dart';
part 'parking_spaces_state.dart';

class ParkingSpacesBloc extends Bloc<ParkingSpacesEvent, ParkingSpacesState> {
  final ParkingSpaceRepository repository;
  late StreamSubscription<List<ParkingSpace>> _parkingSpacesSubscription;

  ParkingSpacesBloc({required this.repository})
      : super(ParkingSpacesInitial()) {
    on<ParkingSpacesEvent>((event, emit) async {
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

          case ParkingSpacesUpdated():
            on<ParkingSpacesUpdated>((event, emit) {
              emit(ParkingSpacesLoaded(parkingSpaces: event.parkingSpaces));
            });
        }
      } catch (e) {
        emit(ParkingSpacesError(message: e.toString()));
      }
    });
    _parkingSpacesSubscription =
        repository.getParkingSpacesStream().listen((parkingSpaces) {
      add(ParkingSpacesUpdated(parkingSpaces: parkingSpaces));
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

  @override
  Future<void> close() {
    _parkingSpacesSubscription.cancel();
    return super.close();
  }
}
