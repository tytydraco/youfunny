import 'package:nyxx/nyxx.dart';
import 'package:youfunny/ifunny_media_parser.dart';

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
    _bot.eventsWs.onMessageReceived
        .listen((event) => _handleIncomingMessage(event.message));
  }

  Future<void> _handleIncomingMessage(IMessage message) async {
    final channel = message.channel;
    final author = message.author.username;
    final messageText = message.content;

    final parser = IFunnyMediaParser(messageText);
    final mediaUrl = await parser.getMediaUrlFromMessage();

    // Skip if we did not parse anything of value here.
    if (mediaUrl == null) return;

    // Send media embed.
    await message.delete(auditReason: 'Replaced with direct URL');
    await channel.sendMessage(MessageBuilder.content(mediaUrl));

    final otherText = messageText.replaceFirst(mediaUrl, '').trim();

    // Send any text left afterwards (if there is any).
    if (otherText.isNotEmpty) {
      await channel.sendMessage(MessageBuilder.content('$author: $otherText'));
    } else {
      await channel.sendMessage(MessageBuilder.content('Sent by $author'));
    }
  }

  /// Connect the bot using the [token] given.
  Future<void> connect() => _bot.connect();
}
