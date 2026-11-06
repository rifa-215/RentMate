import 'package:flutter/material.dart';

import 'create_store.dart';
import 'store_data.dart';
import 'store_dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showStoreDashboard = false;
  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // HEADER PROFILE
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
            ),
          ),

          // ISI PROFILE
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),

                  // INFORMASI PENGGUNA
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFFFFF3E8),
                        child: Icon(Icons.person, size: 38, color: orange),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User RentMate',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'user@email.com',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // TOKO SAYA
                  _profileMenu(
                    icon: Icons.store_outlined,
                    title: 'Toko Saya',
                    subtitle: 'Mulai menyewakan barangmu',
                    onTap: () {
                      if (StoreData.storeCreated) {
                        setState(() {
                          showStoreDashboard = true;
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateStoreScreen(),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // RIWAYAT PENYEWAAN
                  _profileMenu(
                    icon: Icons.receipt_long_outlined,
                    title: 'Riwayat Penyewaan',
                    subtitle: 'Lihat transaksi penyewaanmu',
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  _profileMenu(
                    icon: Icons.favorite_border,
                    title: 'Favorites',
                    subtitle: 'Barang favoritmu',
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  _profileMenu(
                    icon: Icons.settings_outlined,
                    title: 'Pengaturan',
                    subtitle: 'Atur akun dan preferensi',
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  _profileMenu(
                    icon: Icons.help_outline,
                    title: 'Bantuan',
                    subtitle: 'FAQ dan pusat bantuan',
                    onTap: () {},
                  ),

                  const SizedBox(height: 25),

                  // BANNER BUAT TOKO
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E8),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.storefront, size: 45, color: orange),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Punya barang untuk disewakan?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Buat toko dan mulai sewakan barangmu!',
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileMenu({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: orange, size: 25),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
