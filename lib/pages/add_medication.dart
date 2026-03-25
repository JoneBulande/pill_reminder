import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pill_reminder/core/ui/app_colors.dart';
import 'package:pill_reminder/core/model/medicine.dart';
import 'package:pill_reminder/widgets/my_text_field.dart';
import 'package:pill_reminder/core/ui/app_text_style.dart';
import 'package:pill_reminder/providers/auth_provider.dart';
import 'package:pill_reminder/providers/medicine_provider.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({super.key});

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  //

  final _formKey = GlobalKey<FormState>();

  TextEditingController medicationNameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController repeatController = TextEditingController();
  TimeOfDay? _selectedTime;
  int _intervalHours = 8;

  bool isChecked = false;

  String? _cachedUserName;

  void _saveMedicine() {
    if (_formKey.currentState?.validate() ?? false) {

      if (medicationNameController.text.isEmpty || _selectedTime == null) return;
      
      final hh = _selectedTime!.hour.toString().padLeft(2, '0');
      final mm = _selectedTime!.minute.toString().padLeft(2, '0');
      final timeString = '$hh:$mm';

      final medicine = Medicine(
        userName: _cachedUserName!,
        name: medicationNameController.text.trim(),
        time: timeString,
        intervalHours: _intervalHours,
      );
      Provider.of<MedicineProvider>(context, listen: false).addMedicine(medicine);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    // Acessa o userName do AuthProvider no initState
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _cachedUserName = authProvider.userName;

    // // Se necessário, carregar o estado do login
    // authProvider.checkLoginStatus().then((_) {
    //   setState(() {
    //     _cachedUserName = authProvider.userName;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 57,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nova receita',
                    style: AppTextStyles.headingRed,
                  ),
                  const SizedBox(height: 7),
                  const Text('Adicione a sua prescrição médica para receber lembretes de quando tomar seu medicamento'),
                  const SizedBox(height: 47),
                  MyTextField(
                    label: 'Remédio',
                    hintText: 'Nome do medicamento',
                    controller: medicationNameController,
                  ),
                  const SizedBox(height: 17),
                  GestureDetector(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => _selectedTime = time);
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Horário', style: AppTextStyles.label),
                          const SizedBox(height: 7),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                              child: Text(_selectedTime?.format(context) ?? '00:00', style: AppTextStyles.input),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recorrência', style: AppTextStyles.label),
                      const SizedBox(height: 7),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _intervalHours,
                              onChanged: (value) => setState(() => _intervalHours = value!),
                              items: [4, 6, 8, 12, 24].map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(
                                    '$value horas',
                                    style: AppTextStyles.input,
                                  ),
                                );
                              }).toList(),
                              hint: Text('Selecione', style: AppTextStyles.label),
                            ),
                          ),
                        ),
                        // child: DropdownButton<int>(
                        //   value: _intervalHours,
                        //   items: [4, 6, 8, 12, 24].map((hours) {
                        //     return DropdownMenuItem(
                        //       value: hours,
                        //       child: Text('$hours horas'),
                        //     );
                        //   }).toList(),
                        //   onChanged: (value) => setState(() => _intervalHours = value!),
                        // ),
                      ),
                      // ),
                    ],
                  ),
                  // const SizedBox(height: 7),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     SizedBox(
                  //       width: 24.0,
                  //       height: 47.0,
                  //       child: Checkbox(
                  //         value: isChecked,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             isChecked = !isChecked;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //     const Text('Tomar agora'),
                  //   ],
                  // ),
                  const SizedBox(height: 17),
                  SizedBox(
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: _saveMedicine,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppColors.redLight,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: AppColors.gray800),
                          SizedBox(width: 7),
                          Text(
                            'Adicionar',
                            style: TextStyle(color: AppColors.gray800, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
