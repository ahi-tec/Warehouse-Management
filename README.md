# 📦 Warehouse Management System

Ứng dụng **Quản lý kho** là hệ thống web giúp doanh nghiệp, cửa hàng hoặc đơn vị vận hành nội bộ quản lý toàn bộ vòng đời hàng hóa: từ danh mục ban đầu, nhập kho, xuất kho, theo dõi tồn kho đến thống kê và báo cáo.

Hệ thống phù hợp cho cửa hàng bán lẻ đa mặt hàng, doanh nghiệp nhỏ và vừa, hoặc các đơn vị cần quản trị kho tập trung qua mạng nội bộ hoặc internet.

👉 [https://www.ahitec.com/p/phan-mem-quan-ly-thiet-bi-it.html](https://www.ahitec.com/p/phan-mem-quan-ly-kho-warehouse.html)

---

## 🚀 Overview

Warehouse Management System được xây dựng nhằm giải quyết các bài toán quản lý kho thường gặp:

📂 Quản lý nhiều nhóm hàng và nhiều mặt hàng cùng lúc.

🧾 Theo dõi nhập kho và xuất kho theo chứng từ.

🔄 Tự động cập nhật tồn kho khi xác nhận phiếu.

🕒 Truy vết lịch sử giao dịch kho theo thời gian.

⚠️ Cảnh báo hàng sắp hết để chủ động bổ sung.

📊 Cung cấp báo cáo phục vụ vận hành và ra quyết định.

---

## ✨ Key Features

### 📊 Dashboard

- Hiển thị tổng quan số lượng mặt hàng, nhà cung cấp và khách hàng.
- Theo dõi số liệu nhập xuất gần đây.
- Cảnh báo tồn kho thấp.
- Biểu đồ xu hướng nhập xuất theo tháng.

### 🗂️ Master Data Management

- Quản lý nhóm hàng.
- Quản lý đơn vị tính.
- Quản lý mặt hàng.
- Khai báo mã hàng, tên hàng, mã vạch, nhóm hàng, đơn vị tính.
- Khai báo giá nhập, giá bán và tồn tối thiểu.
- Hỗ trợ tìm kiếm và lọc dữ liệu.

### 🤝 Partner Management

- Quản lý nhà cung cấp.
- Quản lý khách hàng cá nhân hoặc doanh nghiệp.
- Lưu thông tin liên hệ, mô tả và trạng thái hoạt động.

### 🏬 Inventory Operations

#### 📥 Stock In

- Tạo phiếu nhập kho với nhiều dòng hàng.
- Tự động tính thành tiền và tổng tiền phiếu.
- Lưu phiếu ở trạng thái nháp.
- Xác nhận phiếu để cộng tồn kho.
- Hủy phiếu khi cần hoàn tác.

#### 📤 Stock Out

- Tạo phiếu xuất kho với nhiều dòng hàng.
- Kiểm tra tồn kho trước khi xác nhận.
- Xác nhận phiếu để trừ tồn kho.
- Hủy phiếu để cộng hoàn tồn kho theo quy tắc nghiệp vụ.

### 📦 Inventory Tracking

- Xem tồn kho theo từng mặt hàng.
- Lọc theo nhóm hàng, trạng thái hoặc mức tồn.
- Theo dõi lịch sử biến động kho theo thời gian.
- Kiểm tra tồn trước và tồn sau của từng giao dịch.

### 📈 Reports

- Báo cáo tồn kho tổng hợp.
- Báo cáo nhập kho theo khoảng thời gian.
- Báo cáo xuất kho theo khoảng thời gian.
- Báo cáo nhập xuất tồn.
- Danh sách mặt hàng sắp hết.
- Xuất báo cáo tồn kho ra Excel.

### 🔐 User & Permission Management

- Đăng nhập, đăng xuất.
- Đổi mật khẩu.
- Phân quyền theo vai trò.
- Chặn truy cập chức năng ngoài quyền.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| ⚙️ Backend | ASP.NET Core MVC 8.0 |
| 🧩 ORM | Entity Framework Core 8.0 |
| 🗄️ Database | Microsoft SQL Server |
| 🔐 Authentication | ASP.NET Core Identity |
| 🎨 UI | Razor Views, Bootstrap 5, Bootstrap Icons |
| 📊 Chart | Chart.js |

---

## 🏗️ Architecture

Ứng dụng được thiết kế theo mô hình MVC, tách rõ các lớp xử lý:

```text
Controller  ->  Service  ->  Data/DbContext  ->  SQL Server
     |
     v
 Razor Views
