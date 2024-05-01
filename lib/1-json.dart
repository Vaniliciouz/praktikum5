import 'dart:convert'; // Mengimpor library untuk pengodean dan penyandi JSON.

void main() { // Mendefinisikan fungsi utama.
  // Mendefinisikan string multi-baris yang berisi data JSON.
  String jsonString = ''' 
    {
      "nama": "Deva Naufal Arrizky Yacob",
      "nim": "22082010054",
      "jurusan": "Sistem Informasi",
      "transkrip": [
        {"kodeMataKuliah": "SI001", "namaMataKuliah": "Pengantar Sistem Informasi", "sks": 3, "nilai": "A-"},
        {"kodeMataKuliah": "SI002", "namaMataKuliah": "Analisis Sistem", "sks": 4, "nilai": "A"},
        {"kodeMataKuliah": "SI003", "namaMataKuliah": "Desain Basis Data", "sks": 3, "nilai": "A"},
        {"kodeMataKuliah": "SI004", "namaMataKuliah": "Sistem Informasi Geografis", "sks": 3, "nilai": "A-"}
      ]
    }
    ''';

  Map<String, dynamic> transkrip = jsonDecode(jsonString); // Mendekode string JSON menjadi Map.

  double totalSks = transkrip['transkrip'] // Menghitung total SKS dengan menjumlahkan SKS untuk setiap mata kuliah.
      .fold(0, (sum, mataKuliah) => sum + mataKuliah['sks']);
  double totalNilai = transkrip['transkrip'].fold( // Menghitung total nilai dengan menjumlahkan nilai untuk setiap mata kuliah.
      0,
      (sum, mataKuliah) =>
          sum + mataKuliah['sks'] * hitungNilaiAngka(mataKuliah['nilai']));

  double ipk = totalNilai / totalSks; // Menghitung IPK dengan membagi total nilai dengan total SKS.
  print('IPK: $ipk'); // Mencetak IPK yang telah dihitung.
}

double hitungNilaiAngka(String nilai) { // Mendefinisikan fungsi untuk menghitung nilai numerik berdasarkan nilai huruf.
  switch (nilai) { // Menggunakan pernyataan switch untuk memetakan nilai huruf ke nilai numerik.
    case 'A':
      return 4.0;
    case 'A-':
      return 3.7;
    case 'B+':
      return 3.3;
    case 'B':
      return 3.0;
    case 'B-':
      return 2.7;
    case 'C+':
      return 2.3;
    case 'C':
      return 2.0;
    case 'C-':
      return 1.7;
    case 'D':
      return 1.0;
    default:
      return 0.0; // Mengembalikan 0 untuk nilai yang tidak dikenali.
  }
}
