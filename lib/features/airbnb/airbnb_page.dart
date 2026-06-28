import 'package:flutter/material.dart';
import 'package:habi/config/theme/app_theme.dart';
import 'package:habi/config/theme/app_constants.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/features/airbnb/airbnb_reservation_store.dart';
import 'package:habi/shared/widgets/glass_container.dart';

enum _StayTaskPhase { beforeCheckIn, afterCheckOut }

class _StayTask {
  final String title;
  final String note;
  final _StayTaskPhase phase;
  bool isDone;

  _StayTask({
    required this.title,
    required this.note,
    required this.phase,
    required this.isDone,
  });
}

class AirBnbPage extends StatefulWidget {
  const AirBnbPage({super.key});

  @override
  State<AirBnbPage> createState() => _AirBnbPageState();
}

class _AirBnbPageState extends State<AirBnbPage> {
  _StayTaskPhase _selectedTaskPhase = _StayTaskPhase.beforeCheckIn;

  final List<_StayTask> _tasks = [
    _StayTask(
      title: 'Send check-in message',
      note: 'Share arrival details and door code.',
      phase: _StayTaskPhase.beforeCheckIn,
      isDone: true,
    ),
    _StayTask(
      title: 'Set fresh towels',
      note: 'Two bath towels and one hand towel per guest.',
      phase: _StayTaskPhase.beforeCheckIn,
      isDone: false,
    ),
    _StayTask(
      title: 'Restock coffee station',
      note: 'Coffee, tea, sugar, and filters.',
      phase: _StayTaskPhase.beforeCheckIn,
      isDone: false,
    ),
    _StayTask(
      title: 'Inspect all rooms',
      note: 'Check for damages or forgotten items.',
      phase: _StayTaskPhase.afterCheckOut,
      isDone: false,
    ),
    _StayTask(
      title: 'Start laundry',
      note: 'Sheets, towels, and kitchen cloths.',
      phase: _StayTaskPhase.afterCheckOut,
      isDone: true,
    ),
    _StayTask(
      title: 'Reset smart lock',
      note: 'Remove guest code after departure.',
      phase: _StayTaskPhase.afterCheckOut,
      isDone: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final reservations = AirbnbReservationStore.upcoming;
    final nextReservation = AirbnbReservationStore.nextReservation;

    return Column(
      spacing: AppConstants.spacingMD,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: AppConstants.spacingMD,
          children: [
            MetricCard(
              label: 'Reservations',
              value: reservations.length.toString(),
              icon: Icons.event_available_rounded,
              color: context.colorScheme.primary,
            ).expanded(),
            MetricCard(
              label: 'Nights booked',
              value: AirbnbReservationStore.totalNights.toString(),
              icon: Icons.bed_rounded,
              color: context.colorScheme.tertiary,
            ).expanded(),
            MetricCard(
              label: 'Expected payout',
              value: _formatCurrency(AirbnbReservationStore.totalAmount),
              icon: Icons.payments_rounded,
              color: context.colorScheme.info,
            ).expanded(),
            MetricCard(
              label: 'Avg. stay',
              value:
                  '${AirbnbReservationStore.averageStay.toStringAsFixed(1)}n',
              icon: Icons.timeline_rounded,
              color: context.colorScheme.warning,
            ).expanded(),
          ],
        ),
        Expanded(
          child: Row(
            spacing: AppConstants.spacingMD,
            children: [
              GlassContainer(
                isElevated: true,
                padding: context.paddingLG,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upcoming Reservations',
                                style: context.textTheme.headlineSmall
                                    ?.copyWith(
                                      color: context.colorScheme.onSurface,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              context.gapXS,
                              Text(
                                'Imported from Airbnb pending reservations',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.home_work_rounded,
                          color: context.colorScheme.primary,
                        ),
                      ],
                    ),
                    context.gapLG,
                    Expanded(
                      child: ListView.separated(
                        itemCount: reservations.length,
                        separatorBuilder: (_, _) => context.gapSM,
                        itemBuilder: (context, index) {
                          return _ReservationTile(
                            reservation: reservations[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ).expanded(flex: 2),
              Column(
                spacing: AppConstants.spacingMD,
                children: [
                  _NextStayPanel(reservation: nextReservation).expanded(),
                  _StayTodoPanel(
                    selectedPhase: _selectedTaskPhase,
                    tasks: _tasks
                        .where((task) => task.phase == _selectedTaskPhase)
                        .toList(growable: false),
                    onPhaseChanged: (phase) {
                      setState(() => _selectedTaskPhase = phase);
                    },
                    onTaskToggled: (task) {
                      setState(() => task.isDone = !task.isDone);
                    },
                  ).expanded(),
                ],
              ).expanded(flex: 1),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatCurrency(double value) {
    return '${value.round()} DKK';
  }
}

class _ReservationTile extends StatelessWidget {
  final AirbnbReservation reservation;

  const _ReservationTile({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: context.paddingMD,
      child: Row(
        children: [
          Container(
            width: 64,
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.colorScheme.primary.withValues(alpha: 0.18),
                  context.colorScheme.surfaceContainerLowest.withValues(
                    alpha: 0.48,
                  ),
                ],
              ),
              borderRadius: context.radiusLG,
              border: Border.all(
                color: context.colorScheme.primary.withValues(alpha: 0.14),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _monthLabel(reservation.checkIn),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  reservation.checkIn.day.toString(),
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          context.gapMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation.guest,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                context.gapXS,
                Text(
                  reservation.listing,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                context.gapSM,
                Wrap(
                  spacing: AppConstants.spacingSM,
                  runSpacing: AppConstants.spacingXS,
                  children: [
                    _ReservationMeta(
                      icon: Icons.login,
                      label: _formatDate(reservation.checkIn),
                    ),
                    _ReservationMeta(
                      icon: Icons.logout,
                      label: _formatDate(reservation.checkOut),
                    ),
                    _ReservationMeta(
                      icon: Icons.nights_stay,
                      label: '${reservation.nights} nights',
                    ),
                    _ReservationMeta(
                      icon: Icons.confirmation_number,
                      label: reservation.confirmationCode,
                    ),
                  ],
                ),
              ],
            ),
          ),
          context.gapMD,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                reservation.currency,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                reservation.amount.toStringAsFixed(2),
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextStayPanel extends StatelessWidget {
  final AirbnbReservation? reservation;

  const _NextStayPanel({required this.reservation});

  @override
  Widget build(BuildContext context) {
    final reservation = this.reservation;

    return GlassContainer(
      isElevated: true,
      padding: context.paddingLG,
      child: reservation == null
          ? Center(
              child: Text(
                'No upcoming stays',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next Check-in',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  context.gapMD,
                  Text(
                    _formatDate(reservation.checkIn),
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  context.gapSM,
                  Text(
                    reservation.guest,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  context.gapXS,
                  Text(
                    '${reservation.nights} nights',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  context.gapMD,
                  _DetailLine(
                    label: 'Check-out',
                    value: _formatDate(reservation.checkOut),
                  ),
                  _DetailLine(
                    label: 'Booked',
                    value: _formatDate(reservation.bookingDate),
                  ),
                ],
              ),
            ),
    );
  }
}

class _StayTodoPanel extends StatelessWidget {
  final _StayTaskPhase selectedPhase;
  final List<_StayTask> tasks;
  final ValueChanged<_StayTaskPhase> onPhaseChanged;
  final ValueChanged<_StayTask> onTaskToggled;

  const _StayTodoPanel({
    required this.selectedPhase,
    required this.tasks,
    required this.onPhaseChanged,
    required this.onTaskToggled,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = tasks.where((task) => task.isDone).length;

    return GlassContainer(
      isElevated: true,
      padding: context.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Stay Todos',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              StatusChip(
                label: '$completedCount/${tasks.length}',
                color: context.colorScheme.tertiary,
              ),
            ],
          ),
          context.gapMD,
          Row(
            children: [
              _PhaseButton(
                label: 'Before',
                isSelected: selectedPhase == _StayTaskPhase.beforeCheckIn,
                onPressed: () => onPhaseChanged(_StayTaskPhase.beforeCheckIn),
              ).expanded(),
              context.gapSM,
              _PhaseButton(
                label: 'After',
                isSelected: selectedPhase == _StayTaskPhase.afterCheckOut,
                onPressed: () => onPhaseChanged(_StayTaskPhase.afterCheckOut),
              ).expanded(),
            ],
          ),
          context.gapMD,
          Expanded(
            child: ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (_, _) => context.gapSM,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _StayTodoTile(
                  task: task,
                  onTap: () => onTaskToggled(task),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PhaseButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _PhaseButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isSelected
              ? context.colorScheme.secondary
              : context.colorScheme.surfaceContainerLowest.withValues(
                  alpha: 0.48,
                ),
          foregroundColor: isSelected
              ? context.colorScheme.onSecondary
              : context.colorScheme.onSurfaceVariant,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: context.radiusSM),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? context.colorScheme.onSecondary
                : context.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _StayTodoTile extends StatelessWidget {
  final _StayTask task;
  final VoidCallback onTap;

  const _StayTodoTile({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: context.paddingSM,
      child: InkWell(
        onTap: onTap,
        borderRadius: context.radiusXL,
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Checkbox(
                value: task.isDone,
                visualDensity: VisualDensity.compact,
                onChanged: (_) => onTap(),
              ),
            ),
            context.gapSM,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  context.gapXS,
                  Text(
                    task.note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationMeta extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ReservationMeta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return StatusChip(
      label: label,
      icon: icon,
      color: context.colorScheme.onSurfaceVariant,
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String _monthLabel(DateTime date) {
  const months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  return months[date.month - 1];
}
