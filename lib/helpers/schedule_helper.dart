class ScheduleHelper {
  static List<DateTime> generateSchedule() {
    List<DateTime> dates = [];
    for (var date = DateTime(2025, 1, 1); date.year == 2025; date = date.add(const Duration(days: 3))) {
      dates.add(date);
    }
    return dates;
  }

  static DateTime getNextCleaning(DateTime fromDate) {
    final dates = generateSchedule();
    return dates.firstWhere((d) => d.isAfter(fromDate), orElse: () => fromDate);
  }
}
