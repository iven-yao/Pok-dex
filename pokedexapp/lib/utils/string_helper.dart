class StringHelper {
  static String transformPokemonName(String name) {
    List<String> words = name.split('-');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    return capitalizedWords.join(' ');
  }

  static String formatId(int number) {
    return number.toString().padLeft(4, '0');
  }
}