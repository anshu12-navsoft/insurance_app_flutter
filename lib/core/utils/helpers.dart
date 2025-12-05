class Helpers {
  static String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static void printDebug(String message) {
    // ignore: avoid_print
    print("DEBUG: $message");
  }
}
