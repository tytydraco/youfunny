import 'dart:io';

import 'package:args/args.dart';
import 'package:youfunny/bot.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser();
  parser
    ..addFlag(
        'help',
        abbr: 'h',
        help: 'Shows the usage',
        negatable: false,
        callback: (enabled) {
          if (enabled) {
            stdout.writeln(parser.usage);
            exit(0);
          }
        },
    )
    ..addOption(
      'token',
      abbr: 't',
      help: 'Discord bot token',
      mandatory: true,
    );

  final options = parser.parse(arguments);
  final String token = options['token'];

  // Start the bot
  final bot = Bot(token);
  await bot.connect();
}
