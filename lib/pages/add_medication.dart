import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/core/model/medicine.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';
import 'package:pill_reminder/providers/auth_provider.dart';
import 'package:pill_reminder/providers/medicine_provider.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({super.key});

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController medicationNameController = TextEditingController();
  TimeOfDay? _selectedTime;
  int _intervalHours = 8;
  String? _cachedUserName;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _cachedUserName = authProvider.userName;
  }

  void _saveMedicine() {
    if (_formKey.currentState?.validate() ?? false) {
      if (medicationNameController.text.isEmpty || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, preencha todos os campos.')),
        );
        return;
      }
      
      final hh = _selectedTime!.hour.toString().padLeft(2, '0');
      final mm = _selectedTime!.minute.toString().padLeft(2, '0');
      final timeString = '$hh:$mm';

      final medicine = Medicine(
        userName: _cachedUserName ?? 'Usuário',
        name: medicationNameController.text.trim(),
        time: timeString,
        intervalHours: _intervalHours,
      );
      Provider.of<MedicineProvider>(context, listen: false).addMedicine(medicine);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Nova Receita', style: AppTextStyles.subHeading),
        iconTheme: const IconThemeData(color: AppColors.gray100),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Configure seu lembrete', style: AppTextStyles.headingBlue.copyWith(fontSize: 28)),
              const SizedBox(height: 12),
              Text(
                'Cadastre o medicamento e o horário para nunca esquecer uma dose.',
                style: AppTextStyles.body.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 48),
              
              Text('NOME DO MEDICAMENTO', style: AppTextStyles.label),
              const SizedBox(height: 12),
              TextFormField(
                controller: medicationNameController,
                decoration: InputDecoration(
                  hintText: 'Ex: Paracetamol',
                  filled: true,
                  fillColor: AppColors.gray800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ),
                style: AppTextStyles.input,
              ),
              
              const SizedBox(height: 32),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('HORÁRIO', style: AppTextStyles.label),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) setState(() => _selectedTime = time);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.gray800,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time_filled_rounded, color: AppColors.primary, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  _selectedTime?.format(context) ?? '00:00',
                                  style: AppTextStyles.input,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('INTERVALO', style: AppTextStyles.label),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.gray800,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _intervalHours,
                              isExpanded: true,
                              onChanged: (value) => setState(() => _intervalHours = value!),
                              items: [4, 6, 8, 12, 24].map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value horas', style: AppTextStyles.input),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 80),
              
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: _saveMedicine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Salvar Receita',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
