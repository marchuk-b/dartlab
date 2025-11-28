import 'package:photo_editor/model/texture.dart';

class Textures {
  List<Texture> list() {
    List<Texture> textures = [];
    for (int i = 1; i <= 16; i++) {
      textures.add(Texture(name: "T$i", path: "assets/textures/t$i.jpg"));
    }
    return textures;
  }
}
