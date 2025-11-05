class Stickers {
  List<List<String>> list() {
    return [
      emoji(),
      people(),
      numbr(),
    ];
  }

  List<String> emoji() {
    List<String> list = [];
    for (int i = 1; i <= 3; i++) {
      list.add('assets/stickers/emodji_$i.png');
    }
    return list;
  }

  List<String> people() {
    List<String> list = [];
    for (int i = 1; i <= 1; i++) {
      list.add('assets/stickers/people_$i.png');
    }
    return list;
  }

  List<String> numbr() {
    List<String> list = [];
    for (int i = 1; i <= 1; i++) {
      list.add('assets/stickers/numbers_$i.png');
    }
    return list;
  }
}

// Щоб додати групи стікерів то треба 
// просто створювати такі штуки як emoji і додавати їх до list()