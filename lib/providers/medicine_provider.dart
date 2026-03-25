import 'package:flutter/material.dart';
import 'package:pill_reminder/core/model/medicine.dart';
import 'package:pill_reminder/providers/auth_provider.dart';
import '../services/db_service.dart';
import '../services/notification_service.dart';

class MedicineProvider with ChangeNotifier {
  final DBService _dbService = DBService();
  final NotificationService _notificationService = NotificationService();
  final AuthProvider authProvider;

  MedicineProvider(this.authProvider);

  List<Medicine> _medicines = [];
  List<Medicine> get medicines => _medicines;

  Future<void> loadMedicines() async {
    final userName = authProvider.userName;
    if (userName != null) {
      _medicines = await _dbService.getMedicinesByUser(userName: userName);
    } else {
      _medicines = [];
    }
    notifyListeners();
  }

  Future<void> addMedicine(Medicine medicine) async {
    final id = await _dbService.insertMedicine(medicine);

    // Agendar a notificação
    final now = DateTime.now();
    final timeParts = medicine.time.split(':');
    final scheduleTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    await _notificationService.scheduleNotification(
      id: id,
      title: 'Lembrete de Remédio',
      body: 'Hora de tomar ${medicine.name}',
      scheduledTime: scheduleTime,
      intervalHours: medicine.intervalHours,
    );

    await loadMedicines();
  }

  Future<void> removeMedicine(int id) async {
    await _dbService.deleteMedicine(id);

    // Cancelar a notificação associada
    await _notificationService.cancelNotification(id);

    await loadMedicines();
  }
}
