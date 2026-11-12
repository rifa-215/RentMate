class UserData {
  static final List<Map<String, String>> users = [];

  static Map<String, String>? currentUser;

  static bool register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) {
    final emailExists = users.any(
      (user) => user['email']!.toLowerCase() == email.toLowerCase(),
    );

    if (emailExists) return false;

    final newUser = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
    };

    users.add(newUser);
    currentUser = newUser;

    return true;
  }

  static bool login({required String email, required String password}) {
    for (final user in users) {
      if (user['email']!.toLowerCase() == email.toLowerCase() &&
          user['password'] == password) {
        currentUser = user;
        return true;
      }
    }

    return false;
  }

  static void logout() {
    currentUser = null;
  }

  static void updateProfile({
    required String name,
    required String phone,
    required String address,
  }) {
    if (currentUser == null) return;

    currentUser!['name'] = name;
    currentUser!['phone'] = phone;
    currentUser!['address'] = address;
  }
}
