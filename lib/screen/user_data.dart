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
      'profileImage': '',
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

  static bool updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
    required String profileImage,
  }) {
    if (currentUser == null) return false;

    final emailExists = users.any(
      (user) =>
          user != currentUser &&
          user['email']!.toLowerCase() == email.toLowerCase(),
    );

    if (emailExists) return false;

    currentUser!['name'] = name;
    currentUser!['email'] = email;
    currentUser!['phone'] = phone;
    currentUser!['address'] = address;
    currentUser!['password'] = password;
    currentUser!['profileImage'] = profileImage;

    return true;
  }
}
