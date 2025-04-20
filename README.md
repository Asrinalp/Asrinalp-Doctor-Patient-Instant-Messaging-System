
# 📘 Doktor-Hasta Mesajlaşma Sistemi

## 🔧 Geliştirme Ortamı

- ASP.NET Web Forms (.NET Framework)
- Microsoft Access Veritabanı (.accdb)
- Visual Studio 
- Lokal çalışacak şekilde tasarlanmıştır

## 🗂️ Klasör & Dosya Yapısı

| Klasör / Dosya         | Açıklama |
|------------------------|----------|
| **App_Data**           | MS Access veritabanı (.accdb) ve log.txt dosyasını içerir |
| **Images**             | Login görselleri (örn: `doctor-login.jpg`) |
| **Uploads**            | Sohbet dosya paylaşımları bu klasöre yüklenir |
| **HashingHelper.cs**   | SHA256 ile şifreleme metodu içerir |
| **Global.asax**        | Oturum kontrolleri ve yönlendirme |
| **Chat.aspx**          | Gerçek zamanlı mesajlaşma ekranı |
| **Messages.aspx**      | Hasta için sohbet listesi |
| **DoctorMessages.aspx**| Doktor için sohbet listesi |
| **PatientDashboard.aspx / DoctorDashboard.aspx** | Rol tabanlı ana paneller |
| **Login.aspx / Register.aspx** | Giriş ve kayıt ekranları |
| **Profile.aspx**       | Profil düzenleme (güncellenebilir bilgiler + şifre) |
| **FindDoctor.aspx**    | Hastaların doktorları listeleyip mesaj başlatabildiği sayfa |

## 🚀 Uygulamanın Kurulumu

1. Visual Studio ile Dosyayı açınız.
2. **Pages** klasöründeki `Login.aspx` sayfasını **Başlangıç Sayfası** olarak ayarlayınız.
3. Projeyi başlatınız.
4. Kullanıcı girişi sayfasında Kullanıcı Adı ve Şifresiyle Giriş yapınız. 
(Örnek Doktor: Kullanıcı Adı:drAlp / Şifre: 1234)
(Örnek Doktor: Kullanıcı Adı:drAsrin / Şifre: 1234)
(Örnek Hasta: Kullanıcı Adı: ayse. / Şifre: 1234)
5. Giriş için yeni kullanıcı oluşturulabilir veya veritabanı elle düzenlenebilir
(Doktorlar veritabanında halihazırda bulunmalıdır. (İleri aşamalarda doktor kimliğiyle doğrulama eklenebilir.))
6. Dashboardlar üzerinden; 
- Kullanıcılar hasta/doktor görüntüleyebilir(Role göre değişir.) 
- Profil sekmesi üzerinden bilgilerini güncelleyebilir.
- Mesajlar kısmından mesajlaşmalarını görüntüleyebilir.
- Mesaj içerisinde metin ve dosya gönderimi gerçekleştirebilir.

## 🔐 Güvenli Giriş Sistemi

- Kayıt sırasında şifreler **SHA256** algoritmasıyla hashlenir
- Login işleminde hem düz şifre hem de hash kontrolü yapılır
- Düz şifreyle giriş yapılırsa sistem şifreyi anında hashleyerek günceller ✅

## ⚙️ Ekstra Özellikler

- ✔️ SHA256 Hashleme (HashingHelper.cs)
- ✔️ Sistem Loglama (App_Data klasörü içerisinde log.txt içerisinde.)
- ✔️ Dosya yükleme ve gönderme
- ✔️ Mesajlaşma içerisinde geçmiş mesaj aratma
- ✔️ Mesaj okundu/görülme durumları / Mesaj atıldığında tek tik / Okunduğunda Çift tik
- ✔️ Rol bazlı dinamik menü ve yönlendirme
- ✔️ Modern ve duyarlı (responsive) tasarım
- ✔️ Kayıt olma ve diğer formlarda try-catch ve koşul doğrulamaları.

## ❗ Bilinen Eksikler / Sınırlamalar

- Doktorların register olması aktif değil çünkü doktor kimliğine ihtiyaç var.
- Kullanıcıların profil fotoğrafı yüklemesi kullanım dışı uygunsuz olabileceği için. (Kontrol sağlanmalı.)
- Online kullanıcı takibi oturum tabanlıdır (aynı makine oturumu herkes için "aktif" olabilir)
- E-posta doğrulaması mevcut değil
