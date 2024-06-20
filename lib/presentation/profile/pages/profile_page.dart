import 'package:celebrities/presentation/common/CustomButtomPopUp.dart';
import 'package:celebrities/presentation/common/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:celebrities/data/local/shared_preferences_service.dart';
import 'package:celebrities/data/local/database_helper.dart';
import 'package:get_it/get_it.dart';

class ProfilePage extends StatelessWidget {
  final SharedPreferencesService _sharedPrefs = GetIt.I<SharedPreferencesService>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> _logout(BuildContext context) async {
    await _databaseHelper.deleteAllArticles(); // Hapus database lokal
    await _sharedPrefs.clear(); // Hapus sesi
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false); // Arahkan ke halaman login
  }

  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CustomBottomPopup(
          imagePath: 'assets/logo.png',
          title: 'Logout',
          description: 'Apakah Anda yakin ingin logout?',
          positiveButtonText: 'Ya',
          negativeButtonText: 'Tidak',
          onPositiveButtonPressed: () {
            Navigator.of(context).pop();
            _logout(context);
          },
          onNegativeButtonPressed: () {
            Navigator.of(context).pop();
          },
          dismissible: true,
          dismissOutside: true,
          onDismiss: () {
            print('Popup dismissed');
          },
          showCloseButton: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person, // Ikon avatar bawaan Flutter
                  size: 50,
                  color: Colors.white,
                ),
                backgroundColor: Colors.pink,
              ),
              SizedBox(height: 16),
              Text(
                'Nama: John Doe',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'ID: 123456789',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Alamat: Jalan Merdeka No. 1',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              CustomButton(
                text: 'Logout',
                onPressed: () => _showLogoutConfirmation(context),
                isLoading: false, // Sesuaikan jika perlu menampilkan loading state
              ),
            ],
          ),
        ),
      ),
    );
  }
}