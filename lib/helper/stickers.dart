class Stickers {
  List<List<String>> list() {
    return [
      emoji(),
      emoticon(),
      dog(),
    ];
  }

  List<String> emoji() {
    List<String> list = [];
    for (int i = 1; i <= 11; i++) {
      list.add('assets/stickers/emodji_$i.png');
    }
    return list;
  }

  List<String> emoticon() {
    List<String> list = [];
    for (int i = 1; i <= 20; i++) {
      list.add('assets/stickers/emoticon_$i.png');
    }
    return list;
  }

  List<String> dog() {
    List<String> list = [];
    for (int i = 1; i <= 19; i++) {
      list.add('assets/stickers/dog_$i.png');
    }
    return list;
  }
}

// Щоб додати групи стікерів то треба 
// просто створювати такі штуки як emoji і додавати їх до list()