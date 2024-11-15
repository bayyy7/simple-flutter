class User {
  const User({
    required this.id,
    required this.accountId,
    required this.accountNumber,
    required this.name,
    required this.address,
    required this.idCard,
    required this.mothersName,
    required this.dateOfBirth,
    required this.gender,
    required this.balance,
  });

  final int id;
  final int accountId;
  final int accountNumber;
  final String name;
  final String address;
  final int idCard;
  final String mothersName;
  final DateTime dateOfBirth;
  final String gender;
  final int balance;

  factory User.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return User(
      id: data['id'] as int,
      accountId: data['account_id'] as int,
      accountNumber: data['account_number'] as int,
      name: data['name'] as String,
      address: data['address'] as String,
      idCard: data['id_card'] as int,
      mothersName: data['mothers_name'] as String,
      dateOfBirth: DateTime.parse(data['date_of_birth'] as String),
      gender: data['gender'] as String,
      balance: data['balance'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'account_number': accountNumber,
      'name': name,
      'address': address,
      'id_card': idCard,
      'mothers_name': mothersName,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'balance': balance,
    };
  }
}
