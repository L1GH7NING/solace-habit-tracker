import 'package:flutter/material.dart';
import 'package:zenith_habit_tracker/features/habits/pages/edit_habit_page.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/daily_goal_selector.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/edit_form_components.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/shared_habit_widgets.dart';

class EditHabitView extends StatelessWidget {
  final EditHabitPageStateAccess access;

  const EditHabitView({super.key, required this.access});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          MainHabitIcon(
            accentColor: access.accentColor,
            iconData: access.currentIconData,
            onTap: access.showAppearancePicker,
          ),
          const SizedBox(height: 32),
          const SectionLabel(label: 'HABIT NAME'),
          const SizedBox(height: 10),
          HabitNameInput(controller: access.controller.titleController),
          const SizedBox(height: 8),
          HabitDescriptionInput(
            controller: access.controller.descriptionController,
          ),
          const SizedBox(height: 28),
          Column(
            children: [
              FrequencySelectorCard(
                accentColor: access.accentColor,
                frequencyType: access.controller.frequencyType,
                onChanged: (type) {
                  access.controller.setFrequency(type);
                  access.rebuild();
                },
              ),

              // 🔥 Smooth expand/collapse & fade animation
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: access.controller.frequencyType == 'DAILY'
                      ? Padding(
                          key: const ValueKey('day_picker'),
                          padding: const EdgeInsets.only(top: 16),
                          child: DayPickerCard(
                            accentColor: access.accentColor,
                            selectedDays: access.controller.frequencyDays,
                            onDayToggle: (day) {
                              access.controller.toggleFrequencyDay(day);
                              access.rebuild();
                            },
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('empty_picker')),
                ),
              ),

              const SizedBox(height: 16),

              DailyGoalSelector(
                accentColor: access.accentColor,
                habitName: access.controller.titleController.text,
                frequencyType: access.controller.frequencyType,
                initialValue: access.controller.targetValue,
                initialUnit: access.controller.unit,
                onValueChanged: (v) {
                  access.controller.targetValue = v;
                  access.rebuild();
                },
                onUnitChanged: (u) {
                  access.controller.unit = u;
                  access.rebuild();
                },
              ),
            ],
          ),

          const SizedBox(height: 28),
          HabitTimeCard(
            hasTime: access.hasTime,
            selectedTime: access.selectedTime,
            accentColor: access.accentColor,
            onToggle: access.setHasTime,
            onTimeTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: access.selectedTime,
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: false,
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                access.setSelectedTime(picked);
              }
            },
          ),
          const SizedBox(height: 16),
          if (access.hasTime) ...[
            ReminderCard(
              hasTime: access.hasTime,
              reminderEnabled: access.reminderEnabled,
              selectedOffset: access.selectedReminderOffset,
              reminderOptions: access.reminderOptions,
              accentColor: access.accentColor,
              onToggle: access.setReminderEnabled,
              onOffsetChanged: (value) {
                if (value != null) {
                  access.setSelectedReminderOffset(value);
                }
              },
            ),
          ],
          const SizedBox(height: 28),
          PrimaryGradientButton(
            text: 'Save Changes',
            onPressed: access.handleSave,
          ),
          const SizedBox(height: 16),
          DeleteHabitButton(onPressed: access.controller.deleteHabit),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
