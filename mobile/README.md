# bramble_mobile

Bramble - Modern Minimalist Novel Reader Mobile App (Flutter).

## Yêu cầu

- Flutter SDK (Dart >=3.4.0 <4.0.0)
- Dart pub cache đã thêm vào PATH: `$HOME/.pub-cache/bin`

## Cài đặt lần đầu

```bash
flutter pub get                 # cài dependencies (bao gồm derry)
dart pub global activate derry  # cài derry CLI global (chỉ cần 1 lần/máy)
```

Nếu gõ `derry` báo "command not found", thêm PATH:

```bash
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

Kiểm tra: `derry -v`

## Các lệnh hay dùng (qua derry)

Xem toàn bộ script: `derry ls`

| Lệnh | Mô tả |
|---|---|
| `derry get` | `flutter pub get` |
| `derry clean` | clean + pub get lại |
| `derry format` | format code (`dart format`) |
| `derry analyze` | `flutter analyze` |
| `derry test` | chạy unit test |
| `derry check` | format + analyze + test |
| `derry run:dev` | `flutter run` |
| `derry build_runner` | chạy code generation 1 lần |
| `derry build_runner:watch` | chạy code generation, tự build lại khi file đổi |
| `derry build:apk` | build APK release |
| `derry build:appbundle` | build App Bundle release |
| `derry build:ios` | build iOS release (không codesign) |
| `derry build:all` | build apk + ios |

## Dependency Injection

Project dùng `get_it` làm service locator. Đăng ký repository/bloc/cubit tại
[lib/core/di/injection_container.dart](lib/core/di/injection_container.dart), gọi `sl<XBloc>()` / `sl<XRepository>()`
để lấy instance thay vì `context.read`.

## Biến môi trường / file nhạy cảm

`.env`, `key.properties`, keystore, `google-services.json`, `GoogleService-Info.plist`... đã bị
`.gitignore` chặn, không push lên git. Xin file cấu hình thật từ người quản lý project rồi đặt
đúng vị trí tương ứng (Android: `android/key.properties`, `android/app/google-services.json`;
iOS: `ios/Runner/GoogleService-Info.plist`).
