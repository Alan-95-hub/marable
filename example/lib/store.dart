class Store {
  static Grave grave = Grave();
}

class Grave {
  String? name;
  String? bio;
  String? dob;
  String? dod;
  String? file;

  Grave({
    this.name = 'Иван Иванов',
    this.bio = 'Хороший человек',
    this.dob = '11.11.1934',
    this.dod = '05.05.2004',
    this.file,
  });
}
