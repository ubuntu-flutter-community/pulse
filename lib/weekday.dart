enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;
}

WeekDay weekDayFromIndex(int index) {
  return WeekDay.values[index - 1];
}
