import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  final DateTime today = DateTime.now();
  late final List<DateTime> scheduledDates = _generateSchedule();
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _controller, 
    curve: Curves.easeIn
  );

  List<DateTime> _generateSchedule() {
    List<DateTime> dates = [];
    for (var date = DateTime(2025, 1, 1); date.year == 2025; date = date.add(const Duration(days: 3))) {
      dates.add(date);
    }
    return dates;
  }

  bool isScheduled(DateTime day) => scheduledDates.any((d) => 
      d.year == day.year && d.month == day.month && d.day == day.day);

  bool isFuture(DateTime day) => day.isAfter(DateTime(today.year, today.month, today.day));

  DateTime get nextCleaning => scheduledDates.firstWhere((d) => d.isAfter(today), orElse: () => today);

  List<DateTime> get futureCleanings => scheduledDates.where(isFuture).toList();

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasTodayCleaning = isScheduled(today);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cleaning Schedule"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8EAF6), Color(0xFFF3F4F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (hasTodayCleaning) _buildAlert(),
            _buildCalendar(),
            _buildNextCleaning(),
            _buildUpcomingSchedule(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlert() => FadeTransition(
    opacity: _fadeAnimation,
    child: Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.amber.shade700.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 5))],
      ),
      child: const Row(
        children: [
          Icon(Icons.notification_important, color: Colors.white),
          SizedBox(width: 10),
          Expanded(child: Text(
            "Your robot is scheduled to clean today!",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          )),
        ],
      ),
    ),
  );

  Widget _buildCalendar() => Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
    ),
    padding: const EdgeInsets.all(12),
    child: TableCalendar(
      focusedDay: today,
      firstDay: DateTime.utc(2025, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      calendarStyle: const CalendarStyle(
        todayTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        todayDecoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, _) => isScheduled(date) 
          ? Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Icon(
                Icons.cleaning_services,
                size: 20,
                color: date.day == today.day && date.month == today.month 
                  ? Colors.blue 
                  : isFuture(date) ? Colors.green : Colors.grey,
              ),
            )
          : null,
      ),
    ),
  );

  Widget _buildNextCleaning() => Container(
    padding: const EdgeInsets.all(18),
    margin: const EdgeInsets.only(top: 24),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))],
    ),
    child: Row(
      children: [
        const Icon(Icons.calendar_today, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(child: Text(
          "Next Cleaning: ${DateFormat('MMMM dd, yyyy').format(nextCleaning)}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        )),
      ],
    ),
  );

  Widget _buildUpcomingSchedule() => Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(top: 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Upcoming Cleaning Schedule", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (futureCleanings.isEmpty) const Text("No upcoming cleanings scheduled"),
        ...futureCleanings.take(10).map((date) => ListTile(
          leading: const Icon(Icons.cleaning_services, color: Colors.green),
          title: Text(DateFormat('MMMM dd, yyyy - EEEE').format(date)),
          trailing: const Icon(Icons.access_time, color: Colors.blue),
          contentPadding: EdgeInsets.zero,
        )),
        if (futureCleanings.length > 10) Text(
          "+ ${futureCleanings.length - 10} more scheduled",
          style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      ],
    ),
  );
}