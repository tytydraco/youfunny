import 'package:http/http.dart' as http;

/// Fetch and parse the contents of a [messageText] to a media URL from iFunny.
class IFunnyMediaParser {
  /// Create a new [IFunnyMediaParser] given a [messageText].
  IFunnyMediaParser(this.messageText);

  /// Message string containing a URL to parse.
  final String messageText;

  /// Parse the picture or video URL from a message.
  ///
  /// Returns null if the message failed to be parsed.
  Future<String?> getMediaUrlFromMessage() async {
    final regex = RegExp('(http.?://ifunny.co/(picture|video)/[^ ]*)');
    final matches = regex.firstMatch(messageText);
    final url = matches?.group(1);
    final type = matches?.group(2);

    // Skip ambiguous URLs.
    if (matches == null || url == null || type == null) return null;

    final html = await _getHtml(url);
    // Skip if HTML cannot be fetched.
    if (html == null) return null;

    switch (type) {
      case 'picture':
        return _getPictureUrl(html);
      case 'video':
        return _getVideoUrl(html);
      default:
        return null;
    }
  }

  /// Get the raw HTML contents.
  Future<String?> _getHtml(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  /// Extract the direct video URL.
  Future<String?> _getVideoUrl(String html) async {
    final regex = RegExp('<video.*?data-src="(.*?)".*?></video>');
    return regex.firstMatch(html)?.group(1);
  }

  /// Extract the direct picture URL.
  Future<String?> _getPictureUrl(String html) async {
    final regex = RegExp('<img src="(.*?)".*?>');
    return regex.firstMatch(html)?.group(1);
  }
}
