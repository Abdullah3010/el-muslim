import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/prayer_time/managers/mg_prayer_time.dart';
import 'package:al_muslim/modules/prayer_time/presentation/widgets/w_date_switcher.dart';
import 'package:al_muslim/modules/prayer_time/presentation/widgets/w_next_prayer_timer.dart';
import 'package:al_muslim/modules/prayer_time/presentation/widgets/w_prayer_times_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnPrayTime extends StatefulWidget {
  const SnPrayTime({super.key});

  @override
  State<SnPrayTime> createState() => _SnPrayTimeState();
}

class _SnPrayTimeState extends State<SnPrayTime> with WidgetsBindingObserver {
  late final MgPrayerTime _mgPrayerTime;
  DateTime _lastActiveDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _mgPrayerTime = Modular.get<MgPrayerTime>();
    _mgPrayerTime.loadPrayerTimes();
    _lastActiveDate = DateTime.now();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndRefreshIfDateChanged();
    }
  }

  void _checkAndRefreshIfDateChanged() {
    final now = DateTime.now();
    final selectedDate = _mgPrayerTime.selectedDate;
    final hasDateChanged =
        now.year != _lastActiveDate.year ||
        now.month != _lastActiveDate.month ||
        now.day != _lastActiveDate.day;
    final isSelectedNotToday =
        selectedDate.year != now.year ||
        selectedDate.month != now.month ||
        selectedDate.day != now.day;

    if (hasDateChanged || isSelectedNotToday) {
      _lastActiveDate = now;
      _mgPrayerTime.loadPrayerTimes(forDate: now);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      withNavBar: true,
      padding: EdgeInsets.zero,
      appBar: WSharedAppBar(
        leading: InkWell(
          onTap: () => Modular.to.pushNamed(RoutesNames.prayTime.prayTimeSettings),
          child: Assets.icons.settings.svg(),
        ),
        action: Assets.icons.qipla.svg(),
        title: 'Prayer Times'.translated,
        withBack: false,
      ),
      body: AnimatedBuilder(
        animation: _mgPrayerTime,
        builder: (context, child) {
          if (_mgPrayerTime.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_mgPrayerTime.status == PrayerTimeStatus.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_mgPrayerTime.errorMessage ?? 'Unable to load prayer times', textAlign: TextAlign.center),
                  SizedBox(height: 12.h),
                  ElevatedButton(onPressed: () => _mgPrayerTime.loadPrayerTimes(), child: const Text('Retry')),
                ],
              ),
            );
          }

          if (!_mgPrayerTime.hasData) {
            return const SizedBox.shrink();
          }

          final nextPrayerLabel =
              _mgPrayerTime.nextPrayerName.isNotEmpty ? _mgPrayerTime.nextPrayerName.translated : 'Next prayer';
          return ListView(
            children: [
              WNextPrayerTimer(
                nextPrayerLabel: nextPrayerLabel,
                countdown: _mgPrayerTime.nextPrayerCountdown,
                locationLabel: _mgPrayerTime.currentLocationLabel,
                description: 'Countdown to $nextPrayerLabel',
              ),
              SizedBox(height: 33.h),
              WDateSwitcher(
                readableLabel: _mgPrayerTime.readableDate,
                gregorianLabel: _mgPrayerTime.gregorianDateLabel,
                hijriLabel: _mgPrayerTime.hijriDateLabel,
                onPrevious: _mgPrayerTime.canGoToPreviousDay ? () => _mgPrayerTime.goToPreviousDay() : null,
                onNext: () => _mgPrayerTime.goToNextDay(),
              ),
              // SizedBox(height: 20.h),
              WPrayerTimesList(
                entries: _mgPrayerTime.prayerTimeEntries,
                highlightedPrayer: _mgPrayerTime.nextPrayerName,
                manager: _mgPrayerTime,
              ),
              Constants.navbarHeight.verticalSpace,
            ],
          );
        },
      ),
    );
  }
}
