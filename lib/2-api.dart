import 'package:flutter/material.dart'; // Mengimpor library Flutter Material untuk membangun UI.
import 'package:http/http.dart' as http; // Mengimpor library http untuk melakukan permintaan HTTP.
import 'dart:convert'; // Mengimpor library untuk pengkodean dan penyandi JSON.

void main() { // Fungsi utama untuk menjalankan aplikasi.
  runApp(const MyApp()); // Menjalankan aplikasi menggunakan widget MyApp.
}

class Activity { // Kelas untuk merepresentasikan aktivitas.
  String aktivitas; // Variabel untuk menyimpan nama aktivitas.
  String jenis; // Variabel untuk menyimpan jenis aktivitas.

  Activity({required this.aktivitas, required this.jenis}); // Konstruktor dengan parameter wajib.

  factory Activity.fromJson(Map<String, dynamic> json) { // Metode fabrik untuk membuat objek Activity dari JSON.
    return Activity( // Mengembalikan objek Activity dengan data dari JSON.
      aktivitas: json['activity'], // Mengisi aktivitas dari JSON.
      jenis: json['type'], // Mengisi jenis aktivitas dari JSON.
    );
  }
}

class MyApp extends StatefulWidget { // Widget MyApp yang dapat berubah.
  const MyApp({super.key}); // Konstruktor MyApp.

  @override
  State<StatefulWidget> createState() { // Membuat state untuk widget MyApp.
    return MyAppState(); // Mengembalikan MyAppState sebagai state.
  }
}

class MyAppState extends State<MyApp> { // State dari MyApp.
  late Future<Activity> futureActivity; // Masa depan untuk data aktivitas.

  String url = "https://www.boredapi.com/api/activity"; // URL untuk mendapatkan aktivitas acak.

  Future<Activity> init() async { // Fungsi untuk inisialisasi futureActivity.
    return Activity(aktivitas: "", jenis: ""); // Mengembalikan objek Activity kosong.
  }

  Future<Activity> fetchData() async { // Fungsi untuk mengambil data aktivitas dari API.
    final response = await http.get(Uri.parse(url)); // Mengirim permintaan GET ke URL.
    if (response.statusCode == 200) { // Jika permintaan berhasil.
      return Activity.fromJson(jsonDecode(response.body)); // Mengembalikan objek Activity dari JSON.
    } else { // Jika permintaan gagal.
      throw Exception('Gagal load'); // Melontarkan pengecualian.
    }
  }

  @override
  void initState() { // Menginisialisasi state sebelum widget dibangun.
    super.initState(); // Memanggil initState dari superclass.
    futureActivity = init(); // Menginisialisasi futureActivity.
  }

  @override
  Widget build(Object context) { // Membangun widget.
    return MaterialApp( // Mengembalikan MaterialApp sebagai root widget.
        home: Scaffold( // Menggunakan Scaffold sebagai struktur dasar UI.
      body: Center( // Menempatkan konten utama di tengah.
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ // Membuat kolom utama.
          Padding( // Widget untuk memberikan padding.
            padding: const EdgeInsets.only(bottom: 20), // Padding di bagian bawah tombol.
            child: ElevatedButton( // Tombol untuk memperbarui aktivitas.
              onPressed: () { // Saat tombol ditekan.
                setState(() { // Memperbarui state.
                  futureActivity = fetchData(); // Memperbarui futureActivity dengan data baru.
                });
              },
              child: const Text("Saya bosan ..."), // Teks di dalam tombol.
            ),
          ),
          FutureBuilder<Activity>( // Widget untuk menampilkan aktivitas yang akan datang.
            future: futureActivity, // Menggunakan futureActivity sebagai sumber data.
            builder: (context, snapshot) { // Membangun tampilan berdasarkan status snapshot.
              if (snapshot.hasData) { // Jika data tersedia.
                return Center( // Menempatkan konten di tengah.
                    child: Column( // Kolom untuk menampilkan data.
                        mainAxisAlignment: MainAxisAlignment.center, // Penempatan data di tengah.
                        children: [
                      Text(snapshot.data!.aktivitas), // Teks untuk menampilkan aktivitas.
                      Text("Jenis: ${snapshot.data!.jenis}") // Teks untuk menampilkan jenis aktivitas.
                    ]));
              } else if (snapshot.hasError) { // Jika terjadi kesalahan.
                return Text('${snapshot.error}'); // Menampilkan pesan kesalahan.
              }
              return const CircularProgressIndicator(); // Tampilkan indikator loading jika tidak ada data.
            },
          ),
        ]),
      ),
    ));
  }
}
