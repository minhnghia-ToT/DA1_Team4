-- Tạo Database
CREATE DATABASE DuAn1_Nhom4_Pro131_SD19311
USE DuAn1_Nhom4_Pro131_SD19311
-- Tạo bảng Quyền
CREATE TABLE Quyen (
    IDQuyen INT PRIMARY KEY,
    TenQuyen NVARCHAR(255) NOT NULL UNIQUE
);

-- Thêm dữ liệu vào bảng Quyền
INSERT INTO Quyen (IDQuyen, TenQuyen) VALUES
(1, 'Admin'),
(2, 'Nhân viên');

-- Tạo bảng Sản phẩm
CREATE TABLE SanPham (
    IDSanPham INT PRIMARY KEY,
    Ten NVARCHAR(255) NOT NULL,
    MieuTa NVARCHAR(MAX),
    Gia DECIMAL(18,2) NOT NULL,
    SoLuong INT NOT NULL
);

-- Tạo bảng Admin
CREATE TABLE Adminn (
    IDAdmin INT IDENTITY(1,1) PRIMARY KEY,
    Ten NVARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    MatKhau VARCHAR(255) NOT NULL,
    IDQuyen INT NOT NULL DEFAULT 1, -- Mặc định là Admin
    CONSTRAINT FK_Admin_Quyen FOREIGN KEY (IDQuyen) REFERENCES Quyen(IDQuyen)
);
-- Thêm dữ liệu vào bảng Admin
INSERT INTO Adminn(Ten, Email, MatKhau) VALUES 
(N'Ngô Đức Nhật Anh', 'nhatanh@gmail.com','123')


-- Tạo bảng Nhân viên
CREATE TABLE NhanVien (
    IDNhanVien INT PRIMARY KEY,
    Ten NVARCHAR(255) NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    IDQuyen INT NOT NULL DEFAULT 2, -- Mặc định là Nhân viên
    CONSTRAINT FK_NhanVien_Quyen FOREIGN KEY (IDQuyen) REFERENCES Quyen(IDQuyen)
);

-- Tạo bảng Hàng tồn kho
CREATE TABLE HangTonKho (
    IDHangTonKho INT PRIMARY KEY,
    IDSanPham INT NOT NULL,
    SoLuong INT NOT NULL,
    FOREIGN KEY (IDSanPham) REFERENCES SanPham(IDSanPham)
);

-- Tạo bảng Phiếu nhập
CREATE TABLE PhieuNhap (
    IDNhap INT PRIMARY KEY,
	NgayNhap DATE NOT NULL,
	SoLuong INT NOT NULL,
	IDAdmin INT,
	CONSTRAINT FK_PhieuNhap FOREIGN KEY (IDAdmin) REFERENCES Adminn(IDAdmin)
);

-- Tạo bảng Giao dịch
CREATE TABLE GiaoDich (
    IDGiaoDich INT PRIMARY KEY,
    IDNhanVien INT NOT NULL,
    Ngay DATE NOT NULL,
    TongHoaDon DECIMAL(18,2) NOT NULL,
	IDSanPham INT NOT NULL,
    FOREIGN KEY (IDNhanVien) REFERENCES NhanVien(IDNhanVien),
	FOREIGN KEY (IDSanPham) REFERENCES SanPham(IDSanPham)
);

