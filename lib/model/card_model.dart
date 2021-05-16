class CreditCard {
  int _id;
  String _bankName;
  String _cardUrl;
  String _cardImage;
  String _cardNumber;
  String _holderName;
  String _validity;
  String _cvv;
  String _pin;
  String _extra;

  CreditCard(
      this._id,
      this._bankName,
      this._cardUrl,
      this._cardImage,
      this._cardNumber,
      this._holderName,
      this._validity,
      this._cvv,
      this._pin,
      this._extra);

  get id => _id;
  get bankName => _bankName;
  get cardUrl => _cardUrl;
  get cardImage => _cardImage;
  get cardNumber => _cardNumber;
  get holderName => _holderName;
  get validity => _validity;
  get cvv => _cvv;
  get pin => _pin;
  get extra => _extra;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['bank'] = _bankName;
    map['url'] = _cardUrl;
    map['image'] = _cardImage;
    map['number'] = _cardNumber;
    map['name'] = _holderName;
    map['validity'] = _validity;
    map['cvv'] = _cvv;
    map['pin'] = _pin;
    map['extra'] = _extra;
    return map;
  }

  CreditCard.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._bankName = map['bank'];
    this._cardUrl = map['url'];
    this._cardImage = map['image'];
    this._cardNumber = map['number'];
    this._holderName = map['name'];
    this._validity = map['validity'];
    this._cvv = map['cvv'];
    this._cvv = map['pin'];
    this._extra = map['extra'];
  }
}
