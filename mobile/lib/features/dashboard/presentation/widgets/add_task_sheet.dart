import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskSheet extends StatefulWidget {
  final void Function(String) onAdd;

  const AddTaskSheet({super.key, required this.onAdd});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  String? _selectedTask;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primary;
    final l = AppLocalizations.of(context);

    final tasks = [
      l.isArabic ? 'الري' : 'Irrigation',
      l.isArabic ? 'تسميد' : 'Fertilization',
      l.isArabic ? 'رش المبيدات' : 'Spraying',
      l.isArabic ? 'الحصاد' : 'Harvesting',
      l.isArabic ? 'تقليم' : 'Pruning',
      l.isArabic ? 'حراثة التربة' : 'Soil Tilling',
    ];

    if (_selectedTask == null) {
      _selectedTask = tasks.first;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? Pallete.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Pallete.darkOutline : Pallete.neutral200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l.isArabic ? 'إضافة مهمة جديدة' : 'Add New Task',
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedTask,
            decoration: InputDecoration(
              labelText: l.isArabic ? 'نوع المهمة' : 'Task Type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            dropdownColor: isDark ? Pallete.darkCard : Colors.white,
            items: tasks
                .map(
                  (task) => DropdownMenuItem(
                    value: task,
                    child: Text(
                      task,
                      style: GoogleFonts.manrope(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedTask = val);
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallete.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                if (_selectedTask != null) {
                  widget.onAdd(_selectedTask!);
                  Navigator.pop(context);
                }
              },
              child: Text(
                l.isArabic ? 'حفظ' : 'Save',
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
