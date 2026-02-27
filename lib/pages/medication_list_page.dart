import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/widgets/dialog_box.dart';
import 'package:pill_reminder/pages/add_medication.dart';
import 'package:pill_reminder/widgets/my_container.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';
import 'package:pill_reminder/widgets/medication_card.dart';
import 'package:pill_reminder/providers/medicine_provider.dart';


class MedicationListPage extends StatefulWidget {
  const MedicationListPage({super.key});

  @override
  State<MedicationListPage> createState() => _MedicationListPageState();
}

class _MedicationListPageState extends State<MedicationListPage> {
  late Future<void> _medicationLoader;

  @override
  void initState() {
    super.initState();
    _medicationLoader = Provider.of<MedicineProvider>(context, listen: false).loadMedicines();
  }

  @override
  Widget build(BuildContext context) {
    // 
    final medicineProvider = Provider.of<MedicineProvider>(context);

    void _deleteMedicine(int medicineId) {
      showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          dialogTitle: 'Deseja realmente Eliminar o lembrete de medicamento?',
          onConfirm: () {
            medicineProvider.removeMedicine(medicineId);
            Navigator.of(context).pop();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 77,
        backgroundColor: AppColors.gray600,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 17, 18, 8),
            child: IconButton(
              iconSize: 27,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddMedication(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppColors.blueBase,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          child: MyContainer(
            headerColor: AppColors.gray600,
            headerPadding: const EdgeInsets.all(18),
            headerContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Minhas receitas',
                  style: AppTextStyles.headingBlue,
                ),
                const SizedBox(height: 7),
                const Text('Acompanhe seus medicamentos cadastrados e gerencie lembretes'),
                const SizedBox(height: 7),
              ],
            ),
            bodyColor: AppColors.gray800,
            flex: 4,
            bodyPadding: const EdgeInsets.fromLTRB(18.0, 32, 18.0, 107),
            bodyContent: FutureBuilder<void>(
              future: _medicationLoader,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                if (medicineProvider.medicines.isEmpty) {
                  return const Center(child: Text('Nenhum remédio cadastrado.'));
                }

                return SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true, // Importante para ListView dentro de SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: medicineProvider.medicines.length,
                    itemBuilder: (context, index) {
                      final medicine = medicineProvider.medicines[index];
                      return MedicationCard(
                        medicationName: medicine.name,
                        time: medicine.time,
                        repeat: '${medicine.intervalHours} horas',
                        onTap: () => _deleteMedicine(medicine.id!),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
