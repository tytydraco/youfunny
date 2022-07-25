import 'package:nyxx/nyxx.dart';
import 'package:youfunny/parser.dart';

/// Initialize the Discord bot and listeners given a [token].
class Bot {
  /// Generate a new [Bot] given a Discord [token].
  Bot(this.token) {
    _registerPlugins();
    _registerListener();
  }

  /// Discord token to use.
  final String token;

  late final INyxxWebsocket _bot =
      NyxxFactory.createNyxxWebsocket(token, GatewayIntents.allUnprivileged);

  /// Register logging and exception-catching functionality.
  void _registerPlugins() {
    _bot
      ..registerPlugin(Logging())
      ..registerPlugin(CliIntegration())
      ..registerPlugin(IgnoreExceptions());
  }

  /// Register message listeners, replacing iFunny videos and pictures with
  /// direct URL embeds.
  void _registerListener() {
    _bot.eventsWs.onMessageReceived.listen((event) async {
      final messageText = event.message.content;
      final parser = Parser(messageText);

      String? url;
      final regex = RegExp(r'http.?://ifunny.co/(picture|video)/.*$');
      final matches = regex.firstMatch(messageText);
      final type = matches?.group(1);

      if (!messageText.contains(' ') && type != null) {
        switch (type) {
          case 'picture':
            url = await parser.getPicture();
            break;
          case 'video':
            url = await parser.getVideo();
            break;
        }
      }

      // Skip if we did not parse anything of value here
      if (url != null) {
        await _replaceMessageWithEmbed(event.message, url);
      }
    });
  }

  /// Connect the bot using the [token] given.
  Future<void> connect() async {
    await _bot.connect();
  }

  /// Convert a [url] into a [MessageBuilder].
  MessageBuilder _messageBuilderFromImageUrl(String url) =>
      MessageBuilder.content(url);

  /// Replace a [message] with a [url] embed.
  Future<void> _replaceMessageWithEmbed(IMessage message, String url) async {
    await message.delete(auditReason: 'Replaced with direct URL');
    await message.channel.sendMessage(_messageBuilderFromImageUrl(url));
  }
}
