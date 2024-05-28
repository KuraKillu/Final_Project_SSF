

<h1 align="center"><strong>Dynamic Fan</strong></h1>

  <p align="center">
    Sistem otomatis yang mengatur kecepatan kipas berdasarkan suhu lingkungan menggunakan sensor DHT11 dan Arduino.
    <br />
    <a href="https://github.com/KuraKillu/Final_Project_SSF/blob/main/LaporanProyekAkhir_3.pdf"><strong>Explore the docs »</strong></a>
    <br />
    <br />
  </p>
</div>

<!-- ABOUT THE PROJECT -->
## Introduction to the problem and the solution
Pada perangkat elektronik, panas berlebih merupakan masalah yang sering dihadapi dan dapat berdampak negatif pada kinerja serta umur dari perangkat tersebut. Sistem pendingin konvensional, yang umumnya beroperasi pada kecepatan tetap, sering kali tidak efisien dalam menangani fluktuasi suhu yang terjadi selama operasi.

Untuk mengatasi masalah yang sudah disebutkan sebelumnya, proyek akhir ini mengusulkan pengembangan sistem Dynamic Fan, sebuah kipas yang menyala dan menyesuaikan kecepatan putarnya secara otomatis berdasarkan hasil sensor suhu. Sistem ini akan memanfaatkan sensor suhu untuk memonitor kondisi termal secara real-time dan mengubah nilai PWM (Pulse Width Modulation) yang diberikan ke motor driver untuk mengatur kecepatan putaran kipas. Dengan pendekatan ini, kipas hanya akan beroperasi pada kecepatan yang diperlukan untuk mempertahankan suhu optimal.

## Hardware design and implementation details
Sistem Dynamic Fan yang diusulkan akan terdiri dari beberapa komponen utama: 
- Sensor DHT11
- Arduino Uno
- Motor
<br />
Sensor suhu akan terus-menerus memantau suhu lingkungan dan mengirimkan data ke Arduino. Arduino akan memproses data tersebut dan menentukan nilai PWM yang sesuai untuk mengatur kecepatan putaran. Motor kemudian akan menerapkan nilai PWM ini untuk mengontrol kecepatan motor. Dengan cara ini, kecepatan dapat disesuaikan secara dinamis sesuai dengan perubahan suhu yang terdeteksi. 


## Software implementation details

Dynamic Fan bekerja berdasarkan pembacaan suhu dari sensor DHT11 dan mengatur kecepatan kipas menggunakan sinyal PWM. Bagian pertama dari kode ini menginisialisasi USART untuk komunikasi serial, yang digunakan untuk mentransmisikan data suhu yang dibaca dari sensor DHT11. Proses inisialisasi ini mencakup pengaturan baud rate, mengaktifkan transmitter, dan menentukan format frame data.

Setelah inisialisasi USART, kode beralih ke subroutine utama yang membaca data dari sensor suhu DHT11. Subroutine ini mengirimkan sinyal pulsa ke sensor untuk memulai komunikasi, kemudian membaca data suhu yang dikirim oleh sensor. Data suhu ini kemudian dibandingkan dengan nilai ambang batas untuk menentukan kecepatan kipas. Jika suhu yang terbaca lebih tinggi dari ambang batas yang telah ditentukan, kipas akan diatur untuk berputar pada kecepatan tinggi atau rendah sesuai dengan suhu yang terdeteksi. Jika suhu di bawah ambang batas, kipas akan dimatikan untuk menghemat energi.

Subroutine delay juga ditambahkan untuk menjalankan operasi yang dilakukan oleh sensor DHT11 dan motor yang akan mengontrol kipas. Subroutine delay akan memastikan bahwa sistem memiliki waktu yang tepat untuk memnaca data dari sensor dan dapat mengatur kecepatan kipas dengan akurat. Terdapat pula subroutine USART Transmit yang ditulis untuk mengirim data suhu melalui komunikasi serial.

## Test results and performance evaluation
Pengujian dilakukan dalam dua tahap: simulasi menggunakan Proteus dan pengujian pada rangkaian fisik. Pada tahap pertama, rangkaian sistem diuji di Proteus dengan komponen virtual seperti Arduino, sensor suhu DHT11, dan motor untuk memastikan semua fungsi berjalan dengan benar, termasuk respon terhadap perubahan suhu yang disimulasikan. Pada tahap kedua, pengujian dilakukan pada rangkaian fisik dengan komponen yang sama dihubungkan pada breadboard, di mana sensor suhu dipanaskan secara bertahap untuk memantau respons sistem; kipas diharapkan menyala dan kecepatannya berubah sesuai suhu yang terukur. Hasil simulasi di Proteus menunjukkan sistem bekerja sesuai harapan, dengan kipas aktif pada suhu 25 derajat Celsius dan kecepatannya meningkat pada 30 derajat Celsius, menyesuaikan kecepatan kipas secara dinamis berdasarkan suhu real-time dengan sinyal PWM. Namun, pengujian pada rangkaian fisik tidak memuaskan karena kipas tidak berfungsi meskipun suhu telah melebihi ambang batas, kemungkinan disebabkan oleh kerusakan komponen yang menyebabkan arus tidak cukup kuat untuk menggerakkan motor kipas. 

Evaluasi menunjukkan bahwa simulasi di Proteus berhasil dan memenuhi kriteria penerimaan, tetapi kegagalan pengujian fisik menekankan perlunya perhatian lebih pada pemilihan dan pengujian komponen hardware untuk memastikan semua dalam kondisi baik dan mampu menyediakan arus yang cukup untuk motor kipas.

## Conclusion
Proyek ini berhasil di tingkat simulasi, namun membutuhkan penyesuaian lebih lanjut pada hardware untuk mencapai fungsionalitas yang diinginkan dalam pengujian fisik. Evaluasi dan perbaikan lanjutan diharapkan dapat menyelesaikan masalah ini dan mengoptimalkan kinerja sistem.
