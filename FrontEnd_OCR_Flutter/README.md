# OCR APP FLUTTER

## Hướng dẫn thiết lập
 # trên môi trường Windows

cần cài đặt vscode, Android Studio và Flutter SDK.

# Bước 1: Cài đặt
Document: https://flutter.dev/docs/get-started/install
# Bước 2: clone project về máy và mở project
# Bước 3: Cài đặt thư viện
 - mở pubspec.yaml và bấm nút "Get Packages" hoặc Ctrl + v

# Bước 4: Thiết lập firebase
  1. Xóa google-services.json tại android\app\google-services.json
  2. truy cập : https://console.firebase.google.com/
  3. Documnet https://firebase.google.com/docs/android/setup
  4. thiết lập theo "Option 1: Add Firebase using the Firebase console"
  Thiết lập Authentication và Storage.
# Bước 5: Chạy ứng dụng
- kiểm tra AVD Manager trong Android Studio nếu chưa có Android emulator.
- mở lib\main.dart => bấm Run Without Debug