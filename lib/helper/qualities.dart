import 'package:photo_editor/model/quality.dart';

class Qualities {
  List<Quality> list() {
    return <Quality>[
      Quality("Low", 30),
      Quality("Medium", 60),
      Quality("High", 90),
      Quality("Max", 100),
    ];
  }
}
