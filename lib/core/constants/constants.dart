class Constants {
  static String headLinesByKeywordURL({String keyword}) {
    return 'https://newsapi.org/v2/everything?q=$keyword&apiKey=71589853e3da4fba97e195e856542853';
  }

  static String topHeadLinesURL() {
    return 'https://newsapi.org/v2/top-headlines?country=us&apiKey=71589853e3da4fba97e195e856542853';
  }
}
