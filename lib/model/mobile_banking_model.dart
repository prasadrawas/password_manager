class MobileBankingModel {
  int _id;
  String _bankName;
  String _url;
  String _accountNumber;
  String _customerId;
  String _mPin;
  String _appPin;
  String _extra;

  MobileBankingModel(this._id, this._bankName, this._url, this._accountNumber,
      this._customerId, this._mPin, this._appPin, this._extra);

  get id => _id;
  get bankName => _bankName;
  get url => _url;
  get accountNumber => _accountNumber;
  get customerId => _customerId;
  get mPin => _mPin;
  get appPin => _appPin;
  get extra => _extra;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['bank'] = _bankName;
    map['url'] = _url;
    map['accountnumber'] = _accountNumber;
    map['customerid'] = _customerId;
    map['mpin'] = _mPin;
    map['apppin'] = _appPin;
    map['extra'] = _extra;
    return map;
  }

  MobileBankingModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._bankName = map['bank'];
    this._url = map['url'];
    this._accountNumber = map['accountnumber'];
    this._customerId = map['customerid'];
    this._mPin = map['mpin'];
    this._appPin = map['apppin'];
    this._extra = map['extra'];
  }
}
