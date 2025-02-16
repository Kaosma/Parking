import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_shared/parking_shared.dart';
import 'package:parking_user/blocs/notification/notifications_bloc.dart';

class ActiveParkingsPage extends StatefulWidget {
  const ActiveParkingsPage({super.key});

  @override
  State<ActiveParkingsPage> createState() => _ActiveParkingsPageState();
}

class _ActiveParkingsPageState extends State<ActiveParkingsPage> {
  @override
  void initState() {
    super.initState();
    _loadParkings();
  }

  void _loadParkings() {
    context.read<ParkingsBloc>().add(LoadParkings());
  }

  void _noticeUserOnParkingEnded(
      NotificationState state, Parking parkingToNotice) {
    DateTime deliveryTime =
        DateTime.fromMillisecondsSinceEpoch(parkingToNotice.endTime * 1000);

    if (deliveryTime.isBefore(DateTime.now())) {
      return; // Prevents scheduling past notifications
    }

    String parkingId =
        '${parkingToNotice.id}${parkingToNotice.startTime}${parkingToNotice.endTime}';
    bool isScheduled = state.isIdScheduled(parkingId);

    if (isScheduled) {
      context.read<NotificationBloc>().add(CancelNotification(id: parkingId));
    } else {
      context.read<NotificationBloc>().add(ScheduleNotification(
          id: parkingId,
          title: 'Parkering avslutad',
          content:
              'Parkering på ${parkingToNotice.parkingSpace.address} för ${parkingToNotice.vehicle.registrationNumber} avslutad.',
          deliveryTime: deliveryTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    NotificationState notificationState =
        context.watch<NotificationBloc>().state;
    final owner = context.read<Person>();
    final formKey = GlobalKey<FormState>();

    Future<void> addParkingDialog(int timeNow) async {
      Vehicle? selectedVehicle;
      ParkingSpace? selectedParkingSpace;
      int? startTime;
      int? endTime;
      startTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final TextEditingController startTimeController = TextEditingController(
        text: formatDateTime(
            DateTime.fromMillisecondsSinceEpoch(startTime * 1000)),
      );
      final TextEditingController endTimeController = TextEditingController();

      final List<Vehicle> vehicles = await getAllVehiclesHandler();
      final List<ParkingSpace> parkingSpaces =
          await getAllParkingSpacesHandler();
      final List<Parking> parkings = await getAllParkingsHandler();

      final activeParkings = parkings.where((parking) {
        return parking.startTime <= timeNow && parking.endTime >= timeNow;
      }).toList();

      final Set<String> activeParkingSpaceIds =
          activeParkings.map((parking) => parking.parkingSpace.id).toSet();

      final List<ParkingSpace> inactiveParkingSpaces =
          parkingSpaces.where((space) {
        return !activeParkingSpaceIds.contains(space.id);
      }).toList();

      Future<void> _pickDateTime(bool isStart) async {
        DateTime now = DateTime.now();

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate == null) return;

        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(now),
        );

        if (pickedTime == null) return;

        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        int pickedUnixTime = pickedDateTime.millisecondsSinceEpoch ~/ 1000;

        setState(() {
          if (isStart) {
            startTime = pickedUnixTime;
            startTimeController.text = formatDateTime(pickedDateTime);
          } else {
            if (startTime != null && pickedUnixTime < startTime!) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Sluttid måste vara efter starttid!")),
              );
              return;
            }
            endTime = pickedUnixTime;
            endTimeController.text = formatDateTime(pickedDateTime);
          }
        });
      }

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Starta ny parkering'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<Vehicle>(
                    value: selectedVehicle,
                    items: vehicles
                        .where((vehicle) => vehicle.owner.id == owner.id)
                        .map((vehicle) {
                      return DropdownMenuItem(
                        value: vehicle,
                        child: Text(
                            '${vehicle.type}, ${vehicle.registrationNumber}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedVehicle = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Fordon',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Välj ett fordon';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ParkingSpace>(
                    value: selectedParkingSpace,
                    items: inactiveParkingSpaces.map((space) {
                      return DropdownMenuItem(
                        value: space,
                        child: Text(space.address),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedParkingSpace = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Parkeringsplats',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Välj en parkeringsplats';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    controller: startTimeController,
                    decoration: InputDecoration(
                      labelText: 'Starttid',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDateTime(true),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    controller: endTimeController,
                    decoration: InputDecoration(
                      labelText: 'Sluttid',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDateTime(false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Avbryt'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (startTime != null && endTime != null) {
                      if (selectedVehicle != null &&
                          selectedParkingSpace != null) {
                        final newParking = Parking(
                          vehicle: selectedVehicle!,
                          parkingSpace: selectedParkingSpace!,
                          startTime: startTime!,
                          endTime: endTime!,
                        );
                        context
                            .read<ParkingsBloc>()
                            .add(CreateParking(parking: newParking));
                        if (endTime! >
                            DateTime.now().millisecondsSinceEpoch ~/ 1000) {
                          _noticeUserOnParkingEnded(
                              notificationState, newParking);
                        }
                        Navigator.of(dialogContext).pop();
                      }
                    }
                  }
                },
                child: const Text('Starta'),
              ),
            ],
          );
        },
      );
    }

    Future<void> editParkingDialog(Parking parking, int timeNow) async {
      Vehicle? selectedVehicle = parking.vehicle;
      ParkingSpace? selectedParkingSpace = parking.parkingSpace;
      int? startTime = parking.startTime;
      int? endTime = parking.endTime;
      final TextEditingController startTimeController = TextEditingController(
        text: startTime != null
            ? formatDateTime(
                DateTime.fromMillisecondsSinceEpoch(startTime * 1000))
            : '',
      );
      final TextEditingController endTimeController = TextEditingController(
        text: endTime != null
            ? formatDateTime(
                DateTime.fromMillisecondsSinceEpoch(endTime * 1000))
            : '',
      );

      final List<Vehicle> vehicles = await getAllVehiclesHandler();
      final List<ParkingSpace> parkingSpaces =
          await getAllParkingSpacesHandler();
      final List<Parking> parkings = await getAllParkingsHandler();

      final activeParkings = parkings.where((parking) {
        return parking.startTime <= timeNow && parking.endTime >= timeNow;
      }).toList();

      final Set<String> activeParkingSpaceIds =
          activeParkings.map((parking) => parking.parkingSpace.id).toSet();

      final List<ParkingSpace> inactiveParkingSpaces =
          parkingSpaces.where((space) {
        return !activeParkingSpaceIds.contains(space.id);
      }).toList();

      Future<void> _pickDateTime(bool isStart) async {
        DateTime now = DateTime.now();

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate == null) return;

        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(now),
        );

        if (pickedTime == null) return;

        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        int pickedUnixTime = pickedDateTime.millisecondsSinceEpoch ~/ 1000;

        setState(() {
          if (isStart) {
            startTime = pickedUnixTime;
            startTimeController.text = formatDateTime(pickedDateTime);
          } else {
            if (startTime != null && pickedUnixTime < startTime!) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Sluttid måste vara efter starttid!")),
              );
              return;
            }
            endTime = pickedUnixTime;
            endTimeController.text = formatDateTime(pickedDateTime);
          }
        });
      }

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Redigera parkering'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedVehicle?.id,
                    items: vehicles
                        .where((vehicle) => vehicle.owner.id == owner.id)
                        .map((vehicle) {
                      return DropdownMenuItem<String>(
                        value: vehicle.id,
                        child: Text(
                            '${vehicle.type}, ${vehicle.registrationNumber}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVehicle = vehicles
                            .firstWhere((vehicle) => vehicle.id == value);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Fordon',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Välj ett fordon';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedParkingSpace?.id,
                    items: inactiveParkingSpaces.map((space) {
                      return DropdownMenuItem<String>(
                        value: space.id,
                        child: Text(space.address),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedParkingSpace = parkingSpaces
                            .firstWhere((space) => space.id == value);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Parkeringsplats',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Välj en parkeringsplats';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    controller: startTimeController,
                    decoration: InputDecoration(
                      labelText: 'Starttid',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDateTime(true),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    controller: endTimeController,
                    decoration: InputDecoration(
                      labelText: 'Sluttid',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDateTime(false),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Avbryt'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (startTime != null &&
                        endTime != null &&
                        selectedVehicle != null &&
                        selectedParkingSpace != null) {
                      final updatedParking = Parking(
                        vehicle: selectedVehicle!,
                        parkingSpace: selectedParkingSpace!,
                        startTime: startTime!,
                        endTime: endTime!,
                        id: parking.id,
                      );
                      context
                          .read<ParkingsBloc>()
                          .add(UpdateParking(parking: updatedParking));
                      if (endTime! >
                          DateTime.now().millisecondsSinceEpoch ~/ 1000) {
                        _noticeUserOnParkingEnded(
                            notificationState, updatedParking);
                      }
                      Navigator.of(dialogContext).pop();
                    }
                  }
                },
                child: const Text('Spara'),
              ),
            ],
          );
        },
      );
    }

    void deleteParkingDialog(Parking parking) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Ta bort parkering'),
            content: Text(
                'Är du säker på att du vill ta bort parkeringen ${parking.id}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Avbryt'),
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<ParkingsBloc>()
                      .add(DeleteParking(parking: parking));
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Radera'),
              ),
            ],
          );
        },
      );
    }

    final int currentTime = getCurrentTime();

    return Scaffold(
      body: BlocBuilder<ParkingsBloc, ParkingsState>(
        builder: (context, state) {
          if (state is ParkingsError) {
            return Center(
              child: Text('Error fetching parkings: ${state.message}'),
            );
          } else if (state is ParkingsLoaded) {
            final parkings = state.parkings.where(
              (parking) => parking.vehicle.owner.id == owner.id,
            );

            final activeParkings = parkings.where((parking) {
              return parking.startTime <= getCurrentTime() &&
                  parking.endTime >= currentTime;
            }).toList();

            final inactiveParkings = parkings.where((parking) {
              return parking.startTime > currentTime ||
                  parking.endTime < currentTime;
            }).toList();

            if (activeParkings.isEmpty && inactiveParkings.isEmpty) {
              return const Center(
                child: Text('Inga parkeringar hittade.'),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                if (activeParkings.isNotEmpty) ...[
                  ...activeParkings.map((parking) {
                    return ListCard(
                      icon: Icons.car_repair,
                      title:
                          '${parking.vehicle.registrationNumber}, ${parking.parkingSpace.address}',
                      text:
                          '${convertUnixToDateTime(parking.startTime)} - ${convertUnixToDateTime(parking.endTime)}',
                      onEdit: () {
                        editParkingDialog(parking, currentTime);
                      },
                      onDelete: () {
                        deleteParkingDialog(parking);
                      },
                      isActive: true,
                    );
                  }).toList(),
                ],
                if (activeParkings.isNotEmpty && inactiveParkings.isNotEmpty)
                  const Divider(),
                if (inactiveParkings.isNotEmpty) ...[
                  ...inactiveParkings.map((parking) {
                    return ListCard(
                      icon: Icons.car_repair,
                      title:
                          '${parking.vehicle.registrationNumber}, ${parking.parkingSpace.address}',
                      text:
                          '${convertUnixToDateTime(parking.startTime)} - ${convertUnixToDateTime(parking.endTime)}',
                      onEdit: () {
                        editParkingDialog(parking, currentTime);
                      },
                      onDelete: () {
                        deleteParkingDialog(parking);
                      },
                    );
                  }).toList(),
                ],
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addParkingDialog(currentTime),
        label: const Text('Starta ny parkering'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
