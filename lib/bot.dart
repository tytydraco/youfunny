import 'package:nyxx/nyxx.dart';
import 'package:youfunny/parser.dart';

/// Initialize the Discord bot and listeners given a [token].
class Bot {
  final String token;
  late final INyxxWebsocket _bot;

  Bot(this.token) {
    _bot = NyxxFactory
        .createNyxxWebsocket(token, GatewayIntents.allUnprivileged);

    _registerPlugins();
    _registerListener();
  }

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
      final messageText = event.message.content.toString();
      final parser = Parser(messageText);

      String? url;
      if (messageText.startsWith('https://ifunny.co/video') &&
          !messageText.contains(' ')) {
        url = await parser.getVideo();
      } else if (messageText.startsWith('https://ifunny.co/picture') &&
          !messageText.contains(' ')) {
        url = await parser.getVideo();
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
    message.channel.sendMessage(_messageBuilderFromImageUrl(url));
  }
}
