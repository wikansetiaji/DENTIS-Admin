class Util{

  static String convertToDateString(String date) {
    final Map<String, String> monthNumber = {
      "01": "Januari",
      "02": "Februari",
      "03": "Maret",
      "04": "April",
      "05": "Mei",
      "06": "Juni",
      "07": "Juli",
      "08": "Agustus",
      "09": "September",
      "10": "Oktober",
      "11": "November",
      "12": "Desember",
    };
    String res = "";
    List<String> dateSplitted = date.split("-");

    res += "${dateSplitted[2]} ${monthNumber[dateSplitted[1]]} ${dateSplitted[0]}";

    return res;
  }


}