import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Parking.dart';
import '../../repositories/Parking.repository.dart';

part 'parkings_event.dart';
part 'parkings_state.dart';

class ParkingsBloc extends Bloc<ParkingsEvent, ParkingsState> {
  final ParkingRepository repository;
  late StreamSubscription<List<Parking>> _parkingsSubscription;

  ParkingsBloc({required this.repository}) : super(ParkingsInitial()) {
    on<ParkingsEvent>((event, emit) async {
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

          case ParkingsUpdated():
            on<ParkingsUpdated>((event, emit) {
              emit(ParkingsLoaded(parkings: event.parkings));
            });
        }
      } catch (e) {
        emit(ParkingsError(message: e.toString()));
      }
    });
    _parkingsSubscription = repository.getParkingsStream().listen((parkings) {
      add(ParkingsUpdated(parkings: parkings));
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

  @override
  Future<void> close() {
    _parkingsSubscription.cancel();
    return super.close();
  }
}
