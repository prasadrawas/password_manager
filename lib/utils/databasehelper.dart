import 'dart:io';

import 'package:password_manager/model/account_model.dart';
import 'package:password_manager/model/card_model.dart';
import 'package:password_manager/model/credential_model.dart';
import 'package:password_manager/model/mobile_banking_model.dart';
import 'package:password_manager/model/netbanking_model.dart';
import 'package:password_manager/model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databasehelper;
  static Database _database;

  //user table structure
  String _usertablename = 'users';
  String _userid = 'id';
  String _userpin = 'pin';
  String _useremail = 'email';

  //password database structure
  String _passwordtablename = 'credentials';
  String _passwordid = 'id';
  String _passwordimg = 'image';
  String _passwordtitle = 'title';
  String _passwordurl = 'url';
  String _passwordusername = 'username';
  String _passwordpass = 'password';
  String _extra = 'extra';

  //card database structure
  String _cardTableName = 'cards';
  String _cardID = 'id';
  String _cardBankName = 'bank';
  String _cardUrl = 'url';
  String _cardImage = 'image';
  String _cardNumber = 'number';
  String _cardHolderName = 'name';
  String _cardValidity = 'validity';
  String _cardCvv = 'cvv';
  String _cardPin = 'pin';

  //account database structure
  String _accountTableName = 'account';
  String _accountID = 'id';
  String _accountBankName = 'bank';
  String _accountNumber = 'accountNumber';
  String _ifscNumber = 'ifsc';
  String _holderName = 'name';
  String _phoneNumber = 'phoneNumber';
  String _bankUrl = 'url';
  String _bankImage = 'image';

  //netbanking database structure
  String _netbankingTable = 'netbanking';
  String _netbankingId = 'id';
  String _netbankingBankName = 'bank';
  String _netbankingUrl = 'url';
  String _netbankingUserId = 'userid';
  String _netbankingCorporateId = 'corporateid';
  String _netbankingLoginPass = 'loginpass';
  String _netbankingProfilePass = 'profilepass';
  String _netbankingTransactionPass = 'transactionpass';
  String __netbankingExtra = 'extra';

  //mobilebanking database structure
  String _mobileBankingTable = 'mobilebanking';
  String _mobileBankingId = 'id';
  String _mobileBankingBankName = 'bank';
  String _mobileBankingUrl = 'url';
  String _mobileBankingAccountNumber = 'accountnumber';
  String _mobileBankingCustomerId = 'customerid';
  String _mobileBankingMPin = 'mpin';
  String _mobileBankingAppPin = 'apppin';
  String _mobileBankingExtra = 'extra';

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databasehelper == null)
      _databasehelper = DatabaseHelper._createInstance();
    return _databasehelper;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'passwords.db';
    var userDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return userDatabase;
  }

  getDatabasePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'passwords.db';
    return path;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''create table $_usertablename(
        $_userid INTEGER PRIMARY KEY AUTOINCREMENT, 
        $_userpin TEXT NOT NULL,
         $_useremail TEXT NOT NULL)''');

    await db.execute('''create table $_passwordtablename(
        $_passwordid INTEGER PRIMARY KEY AUTOINCREMENT,
          $_passwordimg TEXT NOT NULL,
         $_passwordtitle TEXT NOT NULL, 
         $_passwordurl TEXT NOT NULL,
         $_passwordusername TEXT NOT NULL,
          $_passwordpass TEXT NOT NULL,
          $_extra TEXT NOT NULL)''');

    await db.execute('''create table $_cardTableName(
          $_cardID INTEGER PRIMARY KEY AUTOINCREMENT,
          $_cardBankName TEXT NOT NULL,
          $_cardUrl TEXT NOT NULL,
          $_cardImage TEXT NOT NULL,
          $_cardNumber TEXT NOT NULL, 
          $_cardHolderName TEXT NOT NULL,
          $_cardValidity TEXT NOT NULL,
          $_cardCvv TEXT NOT NULL,
          $_cardPin TEXT NOT NULL,
          $_extra TEXT NOT NULL)''');

    await db.execute('''create table $_accountTableName(
          $_accountID INTEGER PRIMARY KEY AUTOINCREMENT,
          $_accountBankName TEXT NOT NULL,
          $_accountNumber TEXT NOT NULL,
          $_ifscNumber TEXT NOT NULL,
          $_holderName TEXT NOT NULL,
          $_phoneNumber TEXT NOT NULL,
          $_bankUrl TEXT NOT NULL,
          $_bankImage TEXT NOT NULL,
          $_extra TEXT NOT NULL)''');

    await db.execute('''create table $_netbankingTable(
          $_netbankingId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_netbankingBankName TEXT NOT NULL,
          $_netbankingUrl TEXT NOT NULL,
          $_netbankingUserId TEXT NOT NULL,
          $_netbankingCorporateId TEXT NOT NULL,
          $_netbankingLoginPass TEXT NOT NULL,
          $_netbankingProfilePass TEXT NOT NULL,
          $_netbankingTransactionPass TEXT NOT NULL,
          $_extra TEXT NOT NULL)''');

    await db.execute('''create table $_mobileBankingTable(
          $_mobileBankingId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_mobileBankingBankName TEXT NOT NULL,
          $_mobileBankingUrl TEXT NOT NULL,
          $_mobileBankingAccountNumber TEXT NOT NULL,
          $_mobileBankingCustomerId TEXT NOT NULL,
          $_mobileBankingMPin TEXT NOT NULL,
          $_mobileBankingAppPin TEXT NOT NULL,
          $_extra TEXT NOT NULL)''');
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();
    return _database;
  }

  createUser(User user) async {
    Database db = await this.database;
    var response = await db.rawQuery('''select * from $_usertablename''');
    var result;
    if (response.isNotEmpty) {
      result = await db.update(_usertablename, user.toMap(),
          where: '${_databasehelper._userid} = ?', whereArgs: [1]);
    } else
      result = await db.insert(_usertablename, user.toMap());
    return result;
  }

  updateUserEmail(email) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        'UPDATE $_usertablename SET $_useremail = ? WHERE $_userid = ?',
        [email, 1]);
    return result;
  }

  updateUserPin(pin) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        'UPDATE $_usertablename SET $_userpin = ? WHERE $_userid = ?',
        [pin, 1]);
    return result;
  }

  fetchUsers() async {
    Database db = await this.database;
    var response = await db.rawQuery('''select * from $_usertablename''');
    return response;
  }

  Future<bool> loginUser(String pin) async {
    Database db = await this.database;
    var result = await db
        .query(_usertablename, where: '${_userpin} = ?', whereArgs: [pin]);
    return result.length == 1;
  }

  insertCredential(Credentials credentials) async {
    Database db = await this.database;
    var response = await db.query(_passwordtablename,
        where: '${_passwordusername}=? AND ${_passwordurl} = ?',
        whereArgs: [credentials.username, credentials.url]);
    var result;
    if (response.length == 0) {
      result = await db.insert(_passwordtablename, credentials.toMap());
    }
    return result;
  }

  getCredentialById(int id) async {
    Database db = await this.database;
    var result = await db
        .rawQuery('select * from $_passwordtablename where $_passwordid = $id');
    return result[0];
  }

  Future<List<Map<String, dynamic>>> fetchCredentials() async {
    Database db = await this.database;
    var response = await db.rawQuery(
        '''select $_passwordid, $_passwordimg, $_passwordtitle, $_passwordusername from $_passwordtablename ORDER BY $_passwordtitle ASC''');
    return response;
  }

  deleteAllPassword() async {
    Database db = await this.database;
    await db.rawQuery('''delete from $_passwordtablename''');
  }

  deleteCredential(int id) async {
    Database db = await this.database;
    await db.rawQuery(
        '''delete from $_passwordtablename where $_passwordid = $id''');
  }

  updateTitle(int id, String title) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_passwordtablename SET $_passwordtitle = ? WHERE $_passwordid = ?',
        [title, id]);
    return response;
  }

  updateURL(int id, String URL) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_passwordtablename SET $_passwordurl = ?, $_passwordimg = ? WHERE $_passwordid = ?',
        [URL, URL + "/favicon.ico", id]);
    return response;
  }

  updateUsername(int id, String username) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_passwordtablename SET $_passwordusername = ? WHERE $_passwordid = ?',
        [username, id]);
    return response;
  }

  updatePassword(int id, String password) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_passwordtablename SET $_passwordpass = ? WHERE $_passwordid = ?',
        [password, id]);
    return response;
  }

  updatePasswordExtras(int id, String extra) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_passwordtablename SET $_extra = ? WHERE $_passwordid = ?',
        [extra, id]);
    return response;
  }

  insertCard(CreditCard card) async {
    Database db = await this.database;
    var response = await db.query(_cardTableName,
        where: '${_cardNumber} = ?', whereArgs: [card.cardNumber]);

    var result;
    if (response.length == 0) {
      result = await db.insert(_cardTableName, card.toMap());
    }
    return result;
  }

  fetchCards() async {
    Database db = await this.database;
    var response = await db.rawQuery(
        'SELECT $_cardID,$_cardImage,$_cardBankName,$_cardHolderName FROM $_cardTableName ORDER BY $_cardBankName ASC');
    return response;
  }

  getCardsById(int id) async {
    Database db = await this.database;
    var result =
        await db.rawQuery('select * from $_cardTableName where $_cardID = $id');
    return result[0];
  }

  updateCardBankName(int id, String name) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_cardTableName SET $_cardBankName = ? WHERE $_cardID = ?',
        [name, id]);
    return response;
  }

  updateCardURL(int id, String url) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_cardTableName SET $_cardUrl = ?, $_cardImage = ? WHERE $_cardID = ?',
        [url, url + "/favicon.ico", id]);
    return response;
  }

  updateCardNumber(int id, String number) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_cardTableName SET $_cardNumber = ? WHERE $_cardID = ?',
        [number, id]);
    return response;
  }

  updateCardHolderName(int id, String name) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_cardTableName SET $_cardHolderName = ? WHERE $_cardID = ?',
        [name, id]);
    return response;
  }

  updateCardValidity(int id, String validity) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_cardTableName SET $_cardValidity = ? WHERE $_cardID = ?',
        [validity, id]);
    return response;
  }

  updateCardCVV(int id, String cvv) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_cardTableName SET $_cardCvv = ? WHERE $_cardID = ?',
        [cvv, id]);
    return response;
  }

  updateCardPin(int id, String pin) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_cardTableName SET $_cardPin = ? WHERE $_cardID = ?',
        [pin, id]);
    return response;
  }

  updateCardExtras(int id, String extra) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_cardTableName SET $_extra = ? WHERE $_cardID = ?',
        [extra, id]);
    return response;
  }

  deleteCard(int id) async {
    Database db = await this.database;
    var response = await db
        .rawDelete('DELETE FROM $_cardTableName WHERE $_cardID = ?', [id]);
    return response;
  }

  getAllCards() async {
    Database db = await this.database;
    return await db.rawQuery('SELECT * FROM $_cardTableName');
  }

  insertAccount(AccountModel account) async {
    Database db = await this.database;
    var response = await db.query(_accountTableName,
        where: '$_accountNumber=?', whereArgs: [account.accountNumber]);

    var result;
    if (response.length == 0) {
      result = await db.insert(_accountTableName, account.toMap());
    }
    return result;
  }

  fetchAccounts() async {
    Database db = await this.database;
    var response = await db.rawQuery(
        '''select $_accountID,$_accountBankName, $_bankImage,$_holderName from $_accountTableName ORDER BY $_cardBankName ASC''');
    return response;
  }

  getAccountById(int id) async {
    Database db = await this.database;
    var result = await db
        .rawQuery('select * from $_accountTableName where $_accountID=$id');
    return result[0];
  }

  updateAccountBankName(int id, String name) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_accountTableName SET $_accountBankName = ? WHERE $_accountID = ?',
        [name, id]);
    return response;
  }

  updateAccountNumber(int id, String number) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_accountTableName SET $_accountNumber = ? WHERE $_accountID = ?',
        [number, id]);
    return response;
  }

  updateAccountNIFSC(int id, String ifsc) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_accountTableName SET $_ifscNumber = ? WHERE $_accountID = ?',
        [ifsc, id]);
    return response;
  }

  updateAccountHolderName(int id, String name) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_accountTableName SET $_holderName = ? WHERE $_accountID = ?',
        [name, id]);
    return response;
  }

  updateAccountPhoneNumber(int id, String number) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_accountTableName SET $_phoneNumber = ? WHERE $_accountID = ?',
        [number, id]);
    return response;
  }

  updateAccountUrl(int id, String url) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_accountTableName SET $_bankUrl = ?, $_bankImage = ? WHERE $_accountID = ?',
        [url, url + "/favicon.ico", id]);
    return response;
  }

  updateAccountExtras(int id, String extra) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_accountTableName SET $_extra = ? WHERE $_accountID = ?',
        [extra, id]);
    return response;
  }

  deleteAccount(int id) async {
    Database db = await this.database;
    await db
        .rawQuery('''delete from $_accountTableName where $_accountID = $id''');
  }

  getUserData() async {
    Database db = await this.database;
    var response = await db.rawQuery('SELECT * FROM $_usertablename');
    return response[0];
  }

  //net banking crud
  insertNetBanking(NetBankingModel account) async {
    Database db = await this.database;
    var response = await db.query(_netbankingTable,
        where: '$_netbankingUserId=?', whereArgs: [account.userid]);

    var result;
    if (response.length == 0) {
      result = await db.insert(_netbankingTable, account.toMap());
    }
    return result;
  }

  fetchNetbanking() async {
    Database db = await this.database;
    var response = await db.rawQuery(
        '''select $_netbankingId,$_netbankingUrl,$_netbankingBankName,$_netbankingUserId from $_netbankingTable ORDER BY $_netbankingBankName ASC''');
    return response;
  }

  getNetBankingById(int id) async {
    Database db = await this.database;
    var result = await db
        .rawQuery('select * from $_netbankingTable where $_netbankingId=$id');
    return result[0];
  }

  updateNetBanking(int id, String columnName, String newData) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_netbankingTable SET $columnName = ? WHERE $_netbankingId = ?',
        [newData, id]);
    return response;
  }

  updateNetBankingBankName(int id, String name) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_netbankingTable SET $_netbankingBankName = ? WHERE $_netbankingId = ?',
        [name, id]);
    return response;
  }

  updateNetbankingUrl(int id, String url) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_netbankingTable SET $_netbankingUrl = ? WHERE $_netbankingId = ?',
        [url, id]);
    return response;
  }

  updateNetbankingUserid(int id, String userid) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_netbankingTable SET $_netbankingUserId = ? WHERE $_netbankingId = ?',
        [userid, id]);
    return response;
  }

  updateNetbankingCorporateId(int id, String corporateid) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_netbankingTable SET $_netbankingCorporateId = ? WHERE $_netbankingId = ?',
        [corporateid, id]);
    return response;
  }

  updateNetbankingLoginpass(int id, String loginpass) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_netbankingTable SET $_netbankingLoginPass = ? WHERE $_netbankingId = ?',
        [loginpass, id]);
    return response;
  }

  updateNetbankingProfilepass(int id, String profilpass) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_netbankingTable SET $_netbankingProfilePass = ? WHERE $_netbankingId = ?',
        [profilpass, id]);
    return response;
  }

  updateNetbankingTransactionPass(int id, String transactionPass) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_netbankingTable SET $_netbankingTransactionPass = ? WHERE $_netbankingId = ?',
        [transactionPass, id]);
    return response;
  }

  updateNetbankingExtra(int id, String extra) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_netbankingTable SET $__netbankingExtra = ? WHERE $_netbankingId = ?',
        [extra, id]);
    return response;
  }

  deleteNetbanking(int id) async {
    Database db = await this.database;
    await db
        .rawQuery('''delete from $_netbankingTable where $_accountID = $id''');
  }

  //mobile banking crud
  insertMobileBanking(MobileBankingModel account) async {
    Database db = await this.database;
    var response = await db.query(_mobileBankingTable,
        where: '$_mobileBankingId=?', whereArgs: [account.accountNumber]);

    var result;
    if (response.length == 0) {
      result = await db.insert(_mobileBankingTable, account.toMap());
    }
    return result;
  }

  fetchMobileBanking() async {
    Database db = await this.database;
    var response = await db.rawQuery(
        '''select $_mobileBankingId, $_mobileBankingBankName, $_mobileBankingUrl, $_mobileBankingCustomerId from $_mobileBankingTable ORDER BY $_mobileBankingBankName ASC''');
    return response;
  }

  updateMobileBankingBankName(int id, String name) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_mobileBankingTable SET $_mobileBankingBankName = ? WHERE $_mobileBankingId = ?',
        [name, id]);
    return response;
  }

  updateMobileBankingUrl(int id, String url) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_mobileBankingTable SET $_mobileBankingUrl = ? WHERE $_mobileBankingId = ?',
        [url, id]);
    return response;
  }

  updateMobileBankingAccountNumber(int id, String accoutnumber) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_mobileBankingTable SET $_mobileBankingAccountNumber = ? WHERE $_mobileBankingId = ?',
        [accoutnumber, id]);
    return response;
  }

  updateMobileBankingCustomerId(int id, String customerid) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_mobileBankingTable SET $_mobileBankingCustomerId = ? WHERE $_mobileBankingId = ?',
        [customerid, id]);
    return response;
  }

  updateMobileBankingMPin(int id, String mpin) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_mobileBankingTable SET $_mobileBankingMPin = ? WHERE $_mobileBankingId = ?',
        [mpin, id]);
    return response;
  }

  updateMobileBankingAppPin(int id, String appPin) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_mobileBankingTable SET $_mobileBankingAppPin = ? WHERE $_mobileBankingId = ?',
        [appPin, id]);
    return response;
  }

  updateMobileBankingExtras(int id, String extra) async {
    Database db = await this.database;
    var response = await db.rawUpdate(
        'UPDATE $_mobileBankingTable SET $_mobileBankingExtra = ? WHERE $_mobileBankingId = ?',
        [extra, id]);
    return response;
  }

  deleteMobileBanking(int id) async {
    Database db = await this.database;
    await db.rawQuery(
        '''delete from $_mobileBankingTable where $_mobileBankingId = $id''');
  }

  getMobilebankingById(int id) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        '''select * from $_mobileBankingTable where $_mobileBankingId = $id''');

    return result[0];
  }
}
