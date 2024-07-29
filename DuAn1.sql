create database DuAn1
use DuAn1
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
	HinhAnh VARCHAR(40) NOT NULL,
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
    IDNhanVien INT IDENTITY(1,1) PRIMARY KEY,
    Ten NVARCHAR(255) NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    IDQuyen INT NOT NULL DEFAULT 2, -- Mặc định là Nhân viên
    CONSTRAINT FK_NhanVien_Quyen FOREIGN KEY (IDQuyen) REFERENCES Quyen(IDQuyen)
);
Insert into NhanVien
values (2,N'Trần Minh Nghĩa', '1', 'nghia@gmail.com', 2)
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
ALTER TABLE SanPham
ADD HinhAnh VARCHAR(40) NOT NULL;

CREATE OR ALTER PROCEDURE DangNhap (@email varchar(255), @matkhau varchar(255))
AS
BEGIN
    DECLARE @status INT;
    -- Kiểm tra đăng nhập cho Adminn
    IF EXISTS (SELECT 1 FROM Adminn WHERE Email = @email AND MatKhau = @matkhau)
        SET @status = 1;
    -- Kiểm tra đăng nhập cho NhanVien
    ELSE IF EXISTS (SELECT 1 FROM NhanVien WHERE Email = @email AND MatKhau = @matkhau)
        SET @status = 2;
    -- Trường hợp không tìm thấy tài khoản
    ELSE
        SET @status = 0;
    SELECT @status;
END;
select * from Adminn

-- Tạo Stored Procedure
CREATE OR ALTER PROCEDURE GetQuyenID 
    @TenQuyen NVARCHAR(255)
AS
BEGIN
    -- Trả về ID quyền tương ứng
    SELECT IDQuyen FROM Quyen WHERE TenQuyen = @TenQuyen;
END
--------------------------------------San Pham-----------------------------------------------------
CREATE OR ALTER PROCEDURE Insert_SanPham 
@idsanpham int, @ten nvarchar(50), @mieuta nvarchar(max), @gia decimal(18,2), @soluong int
AS
BEGIN
	INSERT INTO SanPham(IDSanPham, Ten, MieuTa, Gia, SoLuong)
	VALUES(@idsanpham, @ten, @mieuta, @gia, @soluong)
END

CREATE OR ALTER PROCEDURE Update_SanPham 
@idsanpham int, @ten nvarchar(50), @mieuta nvarchar(max), @gia decimal(18,2), @soluong int
AS
BEGIN
	UPDATE SanPham SET Ten = @ten, MieuTa = @mieuta, Gia = @gia, SoLuong = @soluong
	WHERE IDSanPham = @idsanpham
END

CREATE OR ALTER PROCEDURE Delete_SanPham @idsanpham int
AS
BEGIN
	DELETE FROM SanPham
	WHERE IDSanPham = @idsanpham
END

CREATE OR ALTER PROCEDURE Search_SanPham @ten nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT IDSanPham, Ten, MieuTa, Gia, SoLuong
	FROM SanPham WHERE Ten LIKE '%' + @ten + '%'
END
---------------------------------------------------------------------------------------------------
--------------------------------------Nhân Viên----------------------------------------------------
-- Danh sách nhân viên
CREATE OR ALTER PROCEDURE DanhSachNV
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM NhanVien
END
-- Thêm nhân viên
CREATE OR ALTER PROCEDURE InsertNhanVien 
    @Ten NVARCHAR(255),
    @MatKhau VARCHAR(255),
    @Email VARCHAR(255)
AS
BEGIN
    -- Kiểm tra xem Email đã tồn tại chưa
    IF EXISTS (SELECT 1 FROM NhanVien WHERE Email = @Email)
    BEGIN
        -- Nếu Email đã tồn tại, trả về thông báo lỗi
        RAISERROR('Email đã tồn tại!', 16, 1);
        RETURN;
    END;

    -- Thêm nhân viên mới vào bảng NhanVien
    INSERT INTO NhanVien (Ten, MatKhau, Email, IDQuyen)
    VALUES (@Ten, @MatKhau, @Email, 2); -- IDQuyen mặc định là 2 (Nhân viên)

    -- Trả về thông báo thành công
    SELECT 'Thêm nhân viên thành công!';
END;

-- Cập nhật thông tin nhân viên
CREATE OR ALTER PROCEDURE UpdateNhanVien
    @IDNhanVien INT,
    @Ten NVARCHAR(255),
    @MatKhau VARCHAR(255),
    @Email VARCHAR(255)
AS
BEGIN
    -- Kiểm tra xem IDNhanVien có tồn tại hay không
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE IDNhanVien = @IDNhanVien)
    BEGIN
        -- Nếu IDNhanVien không tồn tại, trả về thông báo lỗi
        RAISERROR('ID Nhân viên không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Cập nhật thông tin nhân viên
    UPDATE NhanVien
    SET Ten = @Ten,
        MatKhau = @MatKhau,
        Email = @Email
    WHERE IDNhanVien = @IDNhanVien;

    -- Trả về thông báo thành công
    SELECT 'Cập nhật thông tin nhân viên thành công!';
END;

-- Xóa nhân viên
CREATE OR ALTER PROCEDURE DeleteNhanVien
    @IDNhanVien INT
AS
BEGIN
    -- Kiểm tra xem IDNhanVien có tồn tại hay không
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE IDNhanVien = @IDNhanVien)
    BEGIN
        -- Nếu IDNhanVien không tồn tại, trả về thông báo lỗi
        RAISERROR('ID Nhân viên không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Xóa nhân viên khỏi bảng NhanVien
    DELETE FROM NhanVien
    WHERE IDNhanVien = @IDNhanVien;

    -- Trả về thông báo thành công
    SELECT 'Xóa nhân viên thành công!';
END;
-- Tìm kiếm nhân viên
CREATE OR ALTER PROCEDURE SearchNhanVien
    @Ten NVARCHAR(255)
AS
BEGIN
    SELECT * FROM NhanVien WHERE Ten LIKE '%' + @Ten + '%';
END;
---------------------------------------------------------------------------------------------------
----------------------------------------Admin------------------------------------------------------
-- Insert Admin
CREATE OR ALTER PROCEDURE InsertAdmin 
    @Ten NVARCHAR(255),
    @MatKhau VARCHAR(255),
    @Email VARCHAR(255)
AS
BEGIN
    -- Kiểm tra xem Email đã tồn tại chưa
    IF EXISTS (SELECT 1 FROM Adminn WHERE Email = @Email)
    BEGIN
        -- Nếu Email đã tồn tại, trả về thông báo lỗi
        RAISERROR('Email đã tồn tại!', 16, 1);
        RETURN;
    END;

    -- Thêm admin mới vào bảng Adminn
    INSERT INTO Adminn (Ten, MatKhau, Email, IDQuyen)
    VALUES (@Ten, @MatKhau, @Email, 1); -- IDQuyen mặc định là 1 (Admin)

    -- Trả về thông báo thành công
    SELECT 'Thêm admin thành công!';
END;

-- Cập nhật thông tin Admin
CREATE OR ALTER PROCEDURE UpdateAdmin
    @IDAdmin INT,
    @Ten NVARCHAR(255),
    @MatKhau VARCHAR(255),
    @Email VARCHAR(255)
AS
BEGIN
    -- Kiểm tra xem IDAdmin có tồn tại hay không
    IF NOT EXISTS (SELECT 1 FROM Adminn WHERE IDAdmin = @IDAdmin)
    BEGIN
        -- Nếu IDAdmin không tồn tại, trả về thông báo lỗi
        RAISERROR('ID Admin không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Cập nhật thông tin admin
    UPDATE Adminn
    SET Ten = @Ten,
        MatKhau = @MatKhau,
        Email = @Email
    WHERE IDAdmin = @IDAdmin;

    -- Trả về thông báo thành công
    SELECT 'Cập nhật thông tin admin thành công!';
END;

-- Xóa Admin
CREATE OR ALTER PROCEDURE DeleteAdmin
    @IDAdmin INT
AS
BEGIN
    -- Kiểm tra xem IDAdmin có tồn tại hay không
    IF NOT EXISTS (SELECT 1 FROM Adminn WHERE IDAdmin = @IDAdmin)
    BEGIN
        -- Nếu IDAdmin không tồn tại, trả về thông báo lỗi
        RAISERROR('ID Admin không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Xóa admin khỏi bảng Adminn
    DELETE FROM Adminn
    WHERE IDAdmin = @IDAdmin;

    -- Trả về thông báo thành công
    SELECT 'Xóa admin thành công!';
END;

-- Tìm Admin theo tên
CREATE OR ALTER PROCEDURE SearchAdmin
    @Ten NVARCHAR(255)
AS
BEGIN
    -- Tìm admin theo tên (không phân biệt chữ hoa chữ thường)
    SELECT *
    FROM Adminn
    WHERE Ten LIKE '%' + @Ten + '%';
END;

-- Stored procedure để thống kê số lượng hàng tồn kho
CREATE PROCEDURE ThongKeTonKho
AS
BEGIN
    SELECT 
        s.Ten AS TenSanPham,
        SUM(htk.SoLuong) AS SoLuongTonKho
    FROM 
        SanPham s
    JOIN 
        HangTonKho htk ON s.IDSanPham = htk.IDSanPham
    GROUP BY 
        s.IDSanPham, s.Ten
    ORDER BY 
        s.Ten;
END;
GO

