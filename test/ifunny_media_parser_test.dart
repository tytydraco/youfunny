import 'package:test/test.dart';
import 'package:youfunny/ifunny_media_parser.dart';

const examplePictureUrl =
    'https://ifunny.co/picture/my-bladder-my-bladder-holding-holding-piss-for-9-piss-7K4foiBj9';
const exampleVideoUrl = 'https://ifunny.co/video/CkXvQLCj9?s=cl';

void main() {
  group('Parser', () {
    test('Picture without other text', () async {
      final parser = IFunnyMediaParser(examplePictureUrl);

      expect(
        await parser.getMediaUrlFromMessage(),
        'https://img.ifunny.co/images/62e71d0652f82ce9bfccb9d2ad2488ded6dad4a3ce3b16f2f021b83dd4405998_1.jpg',
      );
    });

    test('Video without other text', () async {
      final parser = IFunnyMediaParser(exampleVideoUrl);

      expect(
        await parser.getMediaUrlFromMessage(),
        'https://img.ifunny.co/videos/fdb654074c823b3927fb4b7d4dc3fd61e05e63334240bcc2dc603b392aff206f_1.mp4',
      );
    });

    test('Picture with other text', () async {
      final parser = IFunnyMediaParser(
        'Look at the funny! $examplePictureUrl',
      );

      expect(
        parser.getPassedUrlFromMessage(),
        examplePictureUrl,
      );

      expect(
        await parser.getMediaUrlFromMessage(),
        'https://img.ifunny.co/images/62e71d0652f82ce9bfccb9d2ad2488ded6dad4a3ce3b16f2f021b83dd4405998_1.jpg',
      );
    });

    test('Video with other text', () async {
      final parser = IFunnyMediaParser(exampleVideoUrl);

      expect(
        parser.getPassedUrlFromMessage(),
        exampleVideoUrl,
      );

      expect(
        await parser.getMediaUrlFromMessage(),
        'https://img.ifunny.co/videos/fdb654074c823b3927fb4b7d4dc3fd61e05e63334240bcc2dc603b392aff206f_1.mp4',
      );
    });
  });
}
