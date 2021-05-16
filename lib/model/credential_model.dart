class Credentials {
  int _id;
  String _image;
  String _title;
  String _url;
  String _username;
  String _pass;
  String _extra;

  Credentials(this._id, this._image, this._title, this._url, this._username,
      this._pass, this._extra);

  get id => _id;
  get image => _image;
  get title => _title;
  get url => _url;
  get username => _username;
  get pass => _pass;
  get extra => _extra;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['image'] = _image;
    map['title'] = _title;
    map['url'] = _url;
    map['username'] = _username;
    map['password'] = _pass;
    map['extra'] = _extra;
    return map;
  }

  Credentials.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._image = map['image'];
    this._title = map['title'];
    this._url = map['url'];
    this._username = map['username'];
    this._pass = map['pass'];
    this._extra = map['extra'];
  }
}
