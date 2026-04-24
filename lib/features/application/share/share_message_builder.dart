class ShareMessageBuilder {
  const ShareMessageBuilder();

  String build({
    required String appName,
    required String quoteText,
    required String author,
  }) {
    return '"$quoteText"\n- $author\n\nCompartilhado via $appName';
  }
}