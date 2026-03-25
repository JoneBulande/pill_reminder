import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/widgets/dialog_box.dart';
import 'package:pill_reminder/pages/add_medication.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';
import 'package:pill_reminder/widgets/medication_card.dart';
import 'package:pill_reminder/providers/medicine_provider.dart';
import 'package:pill_reminder/pages/medication_detail_page.dart';

class MedicationListPage extends StatefulWidget {
  const MedicationListPage({super.key});

  @override
  State<MedicationListPage> createState() => _MedicationListPageState();
}

class _MedicationListPageState extends State<MedicationListPage> {
  late Future<void> _medicationLoader;
  bool _isPagedView = false;

  @override
  void initState() {
    super.initState();
    _medicationLoader = Provider.of<MedicineProvider>(context, listen: false).loadMedicines();
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);

    void _deleteMedicine(int medicineId) {
      showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            dialogTitle: 'Deseja realmente eliminar este lembrete?',
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Minhas Receitas', style: AppTextStyles.subHeading),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => setState(() => _isPagedView = !_isPagedView),
            icon: Icon(
              _isPagedView ? Icons.list_alt_rounded : Icons.view_carousel_rounded,
              color: AppColors.gray100,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<void>(
        future: _medicationLoader,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (medicineProvider.medicines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/Paper.png', height: 120, opacity: const AlwaysStoppedAnimation(0.5)),
                  const SizedBox(height: 24),
                  Text('Nenhuma receita cadastrada', style: AppTextStyles.body),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMedication())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Adicionar Agora', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            );
          }

          if (_isPagedView) {
            return Center(
              child: SizedBox(
                height: 400,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.85),
                  itemCount: medicineProvider.medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = medicineProvider.medicines[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Container(
                        transform: Matrix4.identity()..scale(1.05), // Subtle scale for paging
                        child: MedicationCard(
                          medicationName: medicine.name,
                          time: medicine.time,
                          repeat: '${medicine.intervalHours} horas',
                          onTap: () => _deleteMedicine(medicine.id!),
                          onDetailTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MedicationDetailPage(medicine: medicine))),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: medicineProvider.medicines.length,
            itemBuilder: (context, index) {
              final medicine = medicineProvider.medicines[index];
              return MedicationCard(
                medicationName: medicine.name,
                time: medicine.time,
                repeat: '${medicine.intervalHours} horas',
                onTap: () => _deleteMedicine(medicine.id!),
                onDetailTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MedicationDetailPage(medicine: medicine))),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMedication())),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Nova Receita', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
