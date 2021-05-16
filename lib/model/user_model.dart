class User {
  int _id;
  String _pin;
  String _email;

  User(this._id, this._pin, this._email);

  int get id => _id;

  String get pin => _pin;

  String get email => _email;

  set id(int id) {
    _id = id;
  }

  set pin(String pin) {
    if (pin.length == 4) _pin = pin;
  }

  set email(String email) {
    if (email.contains('@gmail.com')) _email = email;
  }

  //convert User object to Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['pin'] = _pin;
    map['email'] = _email;
    return map;
  }

  //Convert Map object to User object
  User.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._pin = map['pin'];
    this._email = map['email'];
  }
}
