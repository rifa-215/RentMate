class StoreData {
  static bool storeCreated = false;

  static String storeName = '';
  static String description = '';
  static String address = '';

  static void createStore({
    required String name,
    required String desc,
    required String storeAddress,
  }) {
    storeName = name;
    description = desc;
    address = storeAddress;
    storeCreated = true;
  }
}
