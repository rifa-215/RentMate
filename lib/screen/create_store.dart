import 'package:flutter/material.dart';

import 'store_data.dart';

class CreateStoreScreen extends StatefulWidget {
  const CreateStoreScreen({super.key});

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  final TextEditingController storeNameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  static const Color orange = Color(0xFFFF8A00);

  @override
  void dispose() {
    storeNameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Buat Toko',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mulai Sewakan Barangmu!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lengkapi informasi toko untuk mulai menyewakan barang di RentMate.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),

            const SizedBox(height: 25),

            const Text(
              'Nama Toko',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: storeNameController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama toko',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Deskripsi Toko',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ceritakan tentang toko kamu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Alamat Toko',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Masukkan alamat toko',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (storeNameController.text.trim().isEmpty ||
                      descriptionController.text.trim().isEmpty ||
                      addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lengkapi semua informasi toko!'),
                      ),
                    );
                    return;
                  }

                  StoreData.createStore(
                    name: storeNameController.text.trim(),
                    desc: descriptionController.text.trim(),
                    storeAddress: addressController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Toko berhasil dibuat!')),
                  );

                  Navigator.pop(context);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Buat Toko',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
