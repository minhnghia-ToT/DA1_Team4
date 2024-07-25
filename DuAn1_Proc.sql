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
CREATE PROCEDURE GetQuyenID 
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

