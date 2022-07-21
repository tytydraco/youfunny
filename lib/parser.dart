import 'package:http/http.dart' as http;

/// Fetch and parse the contents of a [url] from iFunny.
class Parser {
  /// Create a new [Parser] given a [url].
  Parser(this.url);

  /// URL to parse.
  final String url;

  /// Get the raw HTML contents.
  Future<String?> _getHtml() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  /// Extract the direct video URL.
  Future<String?> getVideo() async {
    final html = await _getHtml();
    if (html == null) {
      return null;
    }

    final regex = RegExp('<video.*?data-src="(.*?)".*?></video>');
    return regex.firstMatch(html)?.group(1);
  }

  /// Extract the direct picture URL.
  Future<String?> getPicture() async {
    final html = await _getHtml();
    if (html == null) {
      return null;
    }

    final regex = RegExp('<img src="(.*?)".*?>');
    return regex.firstMatch(html)?.group(1);
  }
}
