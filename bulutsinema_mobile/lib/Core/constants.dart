class AppConstants {
  AppConstants._();

  static const String baseUrlPrefKey = 'api_base_url';

  /// PC'nin api_server.py çalıştırdığı adres. Telefon ve PC aynı Wi-Fi/hotspot
  /// ağında olmalı. Uygulama içindeki Ayarlar (⚙) ekranından değiştirilebilir.
  static const String defaultBaseUrl = 'http://192.168.137.1:5005';
}
