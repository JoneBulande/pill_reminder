import 'package:flutter/material.dart';
import 'package:pill_reminder/core/app_colors.dart';
import 'package:pill_reminder/core/app_text_style.dart';
import 'package:pill_reminder/widgets/medication_card.dart';

class MedicationList extends StatefulWidget {
  const MedicationList({super.key});

  @override
  State<MedicationList> createState() => _MedicationListState();
}

class _MedicationListState extends State<MedicationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 87,
        backgroundColor: AppColors.gray600,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: AppColors.gray600,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: AppColors.gray600,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Minhas receitas',
                          style: AppTextStyles.headingBlue,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                            'Acompanhe sue medicamentos cadastrados e gerencie lembretes'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: AppColors.gray800,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(17),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.fromLTRB(18.0, 32, 18.0, 5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MedicationCard(
                            medicationName: 'Nome do remédio',
                            time: '14:00',
                            repeat: '12 horas',
                          ),
                          MedicationCard(
                            medicationName: 'Nome do remédio',
                            time: '07:00',
                            repeat: '7 dias',
                          ),
                          MedicationCard(
                            medicationName: 'Nome do remédio',
                            time: '07:00',
                            repeat: '1 dia',
                          ),
                          MedicationCard(
                            medicationName: 'Nome do remédio',
                            time: '07:00',
                            repeat: '1 dia',
                          ),
                          MedicationCard(
                            medicationName: 'Nome do remédio',
                            time: '07:00',
                            repeat: '1 dia',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
