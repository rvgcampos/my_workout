class Utils {
  static String getWeekdayName(int day) {
    Map<int,String> weekDayMap = {
      1 : 'Segunda-Feira',
      2 : 'Terça-Feira',
      3 : 'Quarta-Feira',
      4 : 'Quinta-Feira',
      5 : 'Sexta-Feira',
      6 : 'Sábado',
      7 : 'Domingo',
    };
    return weekDayMap[day];
  }
}