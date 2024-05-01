import 'package:flutter/material.dart'; // Mengimpor library Material untuk mengakses widget-widget UI bawaan Flutter.
import 'package:http/http.dart' as http; // Mengimpor library http untuk melakukan permintaan HTTP ke server.
import 'dart:convert'; // Mengimpor library convert untuk mengonversi data JSON ke dalam objek Dart.
import 'package:url_launcher/url_launcher.dart'; // Mengimpor library url_launcher untuk meluncurkan URL pada perangkat.

void main() {
  runApp(
      const MyApp()); // Memulai aplikasi Flutter dengan widget MyApp sebagai root.
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Konstruktor MyApp.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Widget MaterialApp untuk mengatur tema aplikasi dan routing.
      title: 'Daftar Universitas di Indonesia', // Judul aplikasi.
      theme: ThemeData(
        // Tema aplikasi.
        primarySwatch: Colors.blue, // Warna utama tema.
      ),
      home: Scaffold(
        // Widget Scaffold untuk mengatur layout dasar aplikasi.
        appBar: AppBar(
          // AppBar sebagai bagian atas aplikasi.
          title: const Text('Daftar Universitas di Indonesia'), // Judul AppBar.
        ),
        body:
            const UniversitiesList(), // Widget UniversitiesList sebagai isi body.
      ),
    );
  }
}

class UniversitiesList extends StatefulWidget {
  // Kelas untuk membuat widget stateful yang akan menampilkan daftar universitas.
  const UniversitiesList({Key? key})
      : super(key: key); // Konstruktor UniversitiesList.

  @override
  _UniversitiesListState createState() =>
      _UniversitiesListState(); // Mengoverride method createState untuk mengembalikan instance dari _UniversitiesListState.
}

class _UniversitiesListState extends State<UniversitiesList> {
  // Kelas _UniversitiesListState yang merupakan state dari widget UniversitiesList.
  List<dynamic> _universities = []; // List untuk menyimpan data universitas.

  @override
  void initState() {
    // Method initState dipanggil setelah widget dirender untuk pertama kalinya.
    super.initState();
    _fetchUniversities(); // Memanggil method untuk mengambil data universitas dari API.
  }

  Future<void> _fetchUniversities() async {
    // Method untuk mengambil data universitas dari API.
    final response = await http.get(
        // Melakukan permintaan HTTP GET ke API universitas.
        Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));
    if (response.statusCode == 200) {
      // Jika permintaan sukses (status code 200).
      setState(() {
        // Memperbarui state dengan data universitas yang diperoleh.
        _universities = jsonDecode(
            response.body); // Mengonversi respon JSON ke dalam objek Dart.
      });
    } else {
      // Jika permintaan gagal.
      throw Exception('Gagal memuat data universitas'); // Melempar exception.
    }
  }

  void _launchURL(String url) async {
    // Method untuk meluncurkan URL.
    if (await canLaunch(url)) {
      // Memeriksa apakah URL dapat diluncurkan.
      await launch(url); // Meluncurkan URL.
    } else {
      // Jika URL tidak dapat diluncurkan.
      throw 'Could not launch $url'; // Melempar exception.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Method untuk membangun UI widget.
    return ListView.builder(
      // Widget ListView untuk menampilkan daftar universitas.
      itemCount: _universities.length, // Jumlah item dalam daftar.
      itemBuilder: (BuildContext context, int index) {
        // Method untuk membangun setiap item dalam daftar.
        final university = _universities[
            index]; // Mendapatkan data universitas pada indeks tertentu.
        return GestureDetector(
          // Widget GestureDetector untuk menangani interaksi ketika item di-tap.
          onTap: () {
            // Ketika item di-tap.
            _launchURL(university['web_pages']
                [0]); // Meluncurkan URL dari universitas yang dipilih.
          },
          child: Card(
            // Widget Card untuk mengelompokkan konten dan memberikan bayangan.
            elevation: 3, // Tingkat elevasi untuk bayangan.
            margin: EdgeInsets.symmetric(
                horizontal: 8, vertical: 4), // Jarak dari tepi layar.
            child: ListTile(
              // Widget ListTile untuk menampilkan konten dalam bentuk baris.
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8), // Padding untuk konten.
              title: Text(
                // Judul universitas.
                university['name'], // Nama universitas.
                style:
                    TextStyle(fontWeight: FontWeight.bold), // Gaya teks judul.
              ),
              subtitle: Text(university['web_pages']
                  [0]), // Subjudul berisi URL universitas.
            ),
          ),
        );
      },
    );
  }
}
