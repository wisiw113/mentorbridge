# MentorBridge

> **Mỗi bước đi đều có người hướng dẫn.**

MentorBridge là ứng dụng kết nối **Mentor** và **Mentee**, hỗ trợ người học tìm kiếm Mentor phù hợp, xem và đăng ký các buổi mentoring, quản lý lịch hẹn, trao đổi qua chat và đánh giá sau buổi mentoring.

Hệ thống được xây dựng nhằm mô phỏng một nền tảng mentoring trực tuyến với ba nhóm người dùng chính: **Mentee, Mentor và Admin**.

---

## 📌 Giới thiệu

Trong quá trình học tập, người học có thể gặp khó khăn khi tìm kiếm người có kinh nghiệm để định hướng và hỗ trợ. MentorBridge được xây dựng nhằm tạo ra một môi trường kết nối giữa người cần hỗ trợ (**Mentee**) và người có kiến thức, kinh nghiệm (**Mentor**).

Ứng dụng tập trung vào quy trình:

```text
Mentee tìm Mentor
       ↓
Xem thông tin Mentor
       ↓
Xem Session
       ↓
Đặt Appointment
       ↓
Mentor xác nhận
       ↓
Tham gia Session
       ↓
Hoàn thành Session
       ↓
Đánh giá
```

---

## 🎯 Mục tiêu

* Xây dựng nền tảng kết nối Mentor và Mentee.
* Hỗ trợ Mentor tạo và quản lý các buổi mentoring.
* Hỗ trợ Mentee tìm kiếm Mentor và đăng ký Session.
* Quản lý lịch hẹn giữa Mentor và Mentee.
* Hỗ trợ trao đổi thông qua chức năng chat.
* Hỗ trợ đánh giá sau khi hoàn thành Session.
* Cung cấp hệ thống thông báo.
* Cung cấp khu vực quản trị cho Admin.

---

## 👥 Đối tượng sử dụng

### 👨‍🎓 Mentee

Mentee là người tìm kiếm sự hướng dẫn từ Mentor.

Các chức năng chính:

* Đăng ký tài khoản.
* Đăng nhập.
* Hoàn thiện hồ sơ.
* Tìm kiếm Mentor.
* Xem thông tin Mentor.
* Xem các Session.
* Đặt Appointment.
* Xem và quản lý Appointment.
* Theo dõi Session.
* Chat với Mentor.
* Nhận thông báo.
* Đánh giá Session / Mentor.
* Quản lý thông tin cá nhân.

---

### 👨‍🏫 Mentor

Mentor là người cung cấp kiến thức và tổ chức các buổi mentoring.

Các chức năng chính:

* Đăng ký tài khoản.
* Đăng nhập.
* Hoàn thiện hồ sơ Mentor.
* Quản lý thông tin cá nhân.
* Tạo Session.
* Quản lý Session.
* Quản lý lịch mentoring.
* Xem danh sách Mentee.
* Xử lý yêu cầu Appointment.
* Theo dõi các buổi mentoring.
* Chat với Mentee.
* Nhận thông báo.
* Đánh giá sau Session.

---

### 👨‍💼 Admin

Admin chịu trách nhiệm quản lý và giám sát hệ thống.

Các chức năng chính:

* Đăng nhập Admin.
* Quản lý người dùng.
* Quản lý tài khoản Mentor / Mentee.
* Quản lý Session.
* Quản lý Appointment.
* Theo dõi hoạt động hệ thống.
* Xem thông tin tổng quan hệ thống.

---

## ⚙️ Chức năng chính

### 🔐 Authentication

* Đăng ký tài khoản.
* Đăng nhập.
* Đăng nhập bằng Google.
* Hoàn thiện hồ sơ.
* Phân quyền người dùng.
* Kiểm tra trạng thái tài khoản.
* Chờ Admin phê duyệt đối với tài khoản cần phê duyệt.

### 👤 Profile

* Xem thông tin cá nhân.
* Cập nhật thông tin cá nhân.
* Hiển thị thông tin Mentor.
* Hiển thị chuyên ngành và thông tin liên quan.

### 🔎 Mentor Search

Mentee có thể:

* Tìm kiếm Mentor.
* Xem danh sách Mentor.
* Xem profile Mentor.
* Xem các Session mà Mentor cung cấp.

### 📅 Session

Mentor có thể:

* Tạo Session.
* Chỉnh sửa / quản lý Session.
* Thiết lập thời gian Session.
* Thiết lập số lượng Mentee.
* Theo dõi các Mentee tham gia.

Mentee có thể:

* Xem Session.
* Xem chi tiết Session.
* Đăng ký Session.

### 📆 Appointment

Hệ thống hỗ trợ quản lý lịch hẹn giữa Mentor và Mentee.

Các trạng thái Appointment có thể được sử dụng để quản lý vòng đời của một lịch hẹn.

Hệ thống cũng kiểm tra lịch để hạn chế việc tạo hoặc tham gia Session / Appointment khi bị trùng thời gian.

### 💬 Chat

Mentor và Mentee có thể:

* Xem danh sách cuộc trò chuyện.
* Trao đổi trực tiếp.
* Gửi và nhận tin nhắn.

### ⭐ Rating

Sau khi hoàn thành Session, người dùng có thể thực hiện đánh giá.

Rating giúp hệ thống ghi nhận phản hồi và hỗ trợ Mentee tham khảo chất lượng Mentor.

### 🔔 Notification

Hệ thống cung cấp chức năng thông báo cho các hoạt động liên quan đến người dùng, Appointment, Session và các tương tác trong hệ thống.

### 🛠️ Admin Management

Admin có thể quản lý:

```text
Users
Sessions
Appointments
Activities
```

và theo dõi tình trạng hoạt động của hệ thống.

---

## 🏗️ Công nghệ sử dụng

| Công nghệ               | Mục đích                     |
| ----------------------- | ---------------------------- |
| Flutter                 | Xây dựng giao diện ứng dụng  |
| Dart                    | Ngôn ngữ lập trình           |
| Firebase Authentication | Xác thực người dùng          |
| Cloud Firestore         | Lưu trữ dữ liệu              |
| Firebase                | Backend / dịch vụ nền tảng   |
| Google Sign-In          | Đăng nhập Google             |
| Git                     | Quản lý phiên bản            |
| GitHub                  | Lưu trữ và cộng tác mã nguồn |

---

## 📁 Cấu trúc dự án

```text
lib/
│
├── core/
│   └── theme/
│
├── models/
│   ├── appointment_model.dart
│   ├── session_model.dart
│   └── ...
│
├── services/
│   ├── auth_service.dart
│   ├── appointment_service.dart
│   ├── session_service.dart
│   ├── rating_service.dart
│   ├── notification_service.dart
│   └── ...
│
├── screens/
│   │
│   ├── auth/
│   │
│   ├── admin/
│   │
│   ├── mentor/
│   │
│   ├── mentee/
│   │
│   └── chat/
│
├── widgets/
│   └── ...
│
├── firebase_options.dart
└── main.dart
```

Dự án được tổ chức theo các nhóm chức năng nhằm tách biệt giao diện, model, service và các thành phần dùng chung.

---

## 🔄 Quy trình hoạt động tổng quát

```text
                         MentorBridge
                              │
              ┌───────────────┼───────────────┐
              │               │               │
            Mentee          Mentor          Admin
              │               │               │
              ↓               ↓               ↓
         Đăng nhập        Đăng nhập       Đăng nhập
              │               │               │
              ↓               ↓               ↓
        Tìm Mentor        Tạo Session     Quản lý User
              │               │               │
              ↓               ↓               ↓
        Xem Session       Quản lý Session  Quản lý Session
              │               │               │
              ↓               │               ↓
       Đặt Appointment ───────┤        Quản lý Appointment
              │               │
              ↓               ↓
          Xác nhận ←──── Mentor
              │
              ↓
           Session
              │
              ↓
           Rating
              │
              ↓
         Notification

        Mentee ←──────── Chat ────────→ Mentor
```

---

## 🗄️ Dữ liệu chính

Các nhóm dữ liệu chính của hệ thống bao gồm:

```text
User
 │
 ├── role
 ├── profile
 └── status

Session
 │
 ├── Mentor
 ├── thời gian
 ├── thông tin Session
 └── số lượng Mentee

Appointment
 │
 ├── Mentor
 ├── Mentee
 ├── Session
 ├── thời gian
 └── trạng thái

Rating
 │
 ├── người đánh giá
 ├── đối tượng được đánh giá
 ├── số sao
 └── nhận xét

Message
 │
 ├── sender
 ├── receiver
 └── nội dung

Notification
 │
 ├── người nhận
 ├── nội dung
 └── trạng thái đọc
```

---

## 🚀 Cài đặt và chạy dự án

### 1. Clone repository

```bash
git clone https://github.com/wisiw113/mentorbridge.git
```

### 2. Di chuyển vào thư mục dự án

```bash
cd mentorbridge
```

### 3. Cài đặt dependencies

```bash
flutter pub get
```

### 4. Kiểm tra thiết bị

```bash
flutter devices
```

### 5. Chạy ứng dụng

```bash
flutter run
```

Để chạy trên Chrome:

```bash
flutter run -d chrome
```

---

## 🔥 Firebase Configuration

Dự án sử dụng Firebase cho Authentication và Cloud Firestore.

Để chạy dự án trong môi trường phát triển cá nhân, cần cấu hình Firebase tương ứng với project của bạn và tạo file cấu hình Firebase cho nền tảng đang sử dụng.

> Không commit các thông tin bảo mật hoặc credential riêng tư vào repository.

---

## 🧪 Business Rules

Một số quy tắc nghiệp vụ chính:

* Người dùng phải đăng nhập để sử dụng các chức năng yêu cầu xác thực.
* Người dùng được phân quyền dựa trên role.
* Mentor có thể tạo Session.
* Mentee có thể đăng ký Session.
* Appointment phải thuộc về một Session hợp lệ.
* Hệ thống kiểm tra xung đột thời gian trước khi tạo hoặc tham gia Session / Appointment.
* Rating được thực hiện dựa trên Session đã hoàn thành.
* Admin có quyền quản lý dữ liệu người dùng và các dữ liệu chính của hệ thống.

---

## 🎨 Giao diện

MentorBridge sử dụng phong cách giao diện **Soft Mint**, hướng đến cảm giác nhẹ nhàng, thân thiện và phù hợp với một nền tảng hỗ trợ học tập.

Các màn hình được tổ chức riêng theo từng vai trò:

```text
Authentication
     │
     ├── Mentee
     │     ├── Home
     │     ├── Search
     │     ├── Activity
     │     ├── Pending
     │     └── Profile
     │
     ├── Mentor
     │     ├── Home
     │     ├── Schedule
     │     ├── Activity
     │     └── Profile
     │
     ├── Admin
     │     ├── Dashboard
     │     ├── Users
     │     ├── Sessions
     │     └── Appointments
     │
     └── Chat
```

---

## 📚 Mục đích dự án

MentorBridge được phát triển trong khuôn khổ **đồ án môn Công nghệ phần mềm**, với mục tiêu áp dụng kiến thức về:

* Phân tích yêu cầu phần mềm.
* Phân tích nghiệp vụ.
* Thiết kế Use Case.
* Thiết kế cơ sở dữ liệu.
* Thiết kế giao diện.
* Lập trình ứng dụng.
* Quản lý phiên bản bằng Git/GitHub.
* Kiểm thử và xử lý các quy tắc nghiệp vụ.

---

## 👨‍💻 Thành viên

**MentorBridge Team**

GitHub Repository:

https://github.com/wisiw113/mentorbridge

---

## 📌 Trạng thái dự án

**Development**

Dự án đang trong quá trình hoàn thiện các chức năng và kiểm thử trước khi triển khai phiên bản hoàn chỉnh.

---

## 📄 License

This project is developed for educational purposes.
