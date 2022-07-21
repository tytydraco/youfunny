import 'package:test/test.dart';
import 'package:youfunny/parser.dart';

void main() {
  group('Parser', () {
    test('Picture', () async {
      final parser = Parser(
        'https://ifunny.co/picture/my-bladder-my-bladder-holding-holding-piss-for-9-piss-7K4foiBj9',
      );

      expect(
        await parser.getPicture(),
        'https://img.ifunny.co/images/62e71d0652f82ce9bfccb9d2ad2488ded6dad4a3ce3b16f2f021b83dd4405998_1.jpg',
      );
    });

    test('Video', () async {
      final parser = Parser(
        'https://ifunny.co/video/CkXvQLCj9?s=cl',
      );

      expect(
        await parser.getVideo(),
        'https://img.ifunny.co/videos/fdb654074c823b3927fb4b7d4dc3fd61e05e63334240bcc2dc603b392aff206f_1.mp4',
      );
    });
  });
}
