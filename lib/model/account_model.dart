class AccountModel {
  int _id;
  String _bankName;
  String _accountNumber;
  String _ifscNumber;
  String _holderName;
  String _phoneNumber;
  String _url;
  String _image;
  String _extra;

  AccountModel(this._id, this._bankName, this._accountNumber, this._ifscNumber,
      this._holderName, this._phoneNumber, this._url, this._image, this._extra);

  get id => _id;
  get bankName => _bankName;
  get accountNumber => _accountNumber;
  get ifscNumber => _ifscNumber;
  get holderName => _holderName;
  get phoneNumber => _phoneNumber;
  get url => _url;
  get image => _image;
  get extra => _extra;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['bank'] = _bankName;
    map['accountNumber'] = _accountNumber;
    map['ifsc'] = _ifscNumber;
    map['name'] = _holderName;
    map['phoneNumber'] = _phoneNumber;
    map['url'] = _url;
    map['image'] = _image;
    map['extra'] = _extra;
    return map;
  }

  AccountModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._bankName = map['bank'];
    this._accountNumber = map['accountNumber'];
    this._ifscNumber = map['ifsc'];
    this._holderName = map['name'];
    this._phoneNumber = map['phoneNumber'];
    this._url = map['url'];
    this._image = map['image'];
    this._extra = map['extra'];
  }
}
