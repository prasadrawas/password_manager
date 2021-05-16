class NetBankingModel {
  int _id;
  String _bankName;
  String _url;
  String _userid;
  String _corporateid;
  String _loginpass;
  String _profilepass;
  String _transactionpass;
  String _extra;

  NetBankingModel(
      this._id,
      this._bankName,
      this._url,
      this._userid,
      this._corporateid,
      this._loginpass,
      this._profilepass,
      this._transactionpass,
      this._extra);

  get id => _id;
  get bankName => _bankName;
  get url => _url;
  get userid => _userid;
  get corporateid => _corporateid;
  get loginpass => _loginpass;
  get profilepass => _profilepass;
  get transactionpass => _transactionpass;
  get extra => _extra;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['bank'] = _bankName;
    map['url'] = _url;
    map['userid'] = _userid;
    map['corporateid'] = _corporateid;
    map['loginpass'] = _loginpass;
    map['profilepass'] = _profilepass;
    map['transactionpass'] = _transactionpass;
    map['extra'] = _extra;
    return map;
  }

  NetBankingModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._bankName = map['bank'];
    this._url = map['url'];
    this._userid = map['userid'];
    this._corporateid = map['corporateid'];
    this._loginpass = map['loginpass'];
    this._profilepass = map['profilepass'];
    this._transactionpass = map['transactionpass'];
    this._extra = map['extra'];
  }
}
