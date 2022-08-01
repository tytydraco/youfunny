import 'dart:io';

import 'package:args/args.dart';
import 'package:youfunny/youfunny.dart';

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

  try {
    final options = parser.parse(arguments);
    final token = options['token'] as String;

    // Start the bot
    final bot = YouFunny(token);
    await bot.connect();
  } catch (e) {
    stdout.writeln(e);
    exit(1);
  }
}
