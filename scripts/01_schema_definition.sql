-- Database Initialization
CREATE DATABASE SALES_MANAGEMENT;
USE SALES_MANAGEMENT;
--------------------------------------------------------------------------------
-- Task 1: Create relations with Primary and Foreign Keys
--------------------------------------------------------------------------------
CREATE TABLE KHACHHANG (
    MAKH     CHAR(4)        PRIMARY KEY,
    HOTEN    VARCHAR(40)    NOT NULL,
    DCHI     VARCHAR(50),
    SODT     VARCHAR(20),
    NGSINH   SMALLDATETIME  NOT NULL,
    DOANHSO  MONEY          DEFAULT 0,
    NGDK     SMALLDATETIME  NOT NULL
);

CREATE TABLE NHANVIEN (
    MANV     CHAR(4)        PRIMARY KEY,
    HOTEN    VARCHAR(40)    NOT NULL,
    SODT     VARCHAR(20),
    NGVL     SMALLDATETIME  NOT NULL
);

CREATE TABLE SANPHAM (
    MASP     CHAR(4)        PRIMARY KEY,
    TENSP    VARCHAR(40)    NOT NULL,
    DVT      VARCHAR(20),
    NUOCSX   VARCHAR(40),
    GIA      MONEY          NOT NULL
);

CREATE TABLE HOADON (
    SOHD     INT            PRIMARY KEY,
    NGHD     SMALLDATETIME  NOT NULL,
    MAKH     CHAR(4)        FOREIGN KEY REFERENCES KHACHHANG(MAKH),
    MANV     CHAR(4)        FOREIGN KEY REFERENCES NHANVIEN(MANV),
    TRIGIA   MONEY          NOT NULL
);

CREATE TABLE CTHD (
    SOHD     INT,
    MASP     CHAR(4),
    SL       INT            NOT NULL,
    PRIMARY KEY (SOHD, MASP),
    FOREIGN KEY (SOHD) REFERENCES HOADON(SOHD),
    FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP)
);

--------------------------------------------------------------------------------
-- Task 2: Add attribute GHICHU varchar(20) to SANPHAM
--------------------------------------------------------------------------------
ALTER TABLE SANPHAM 
ADD GHICHU VARCHAR(20);

--------------------------------------------------------------------------------
-- Task 3: Add attribute LOAIKH tinyint to KHACHHANG
--------------------------------------------------------------------------------
ALTER TABLE KHACHHANG 
ADD LOAIKH TINYINT;

--------------------------------------------------------------------------------
-- Task 4: Modify GHICHU data type to varchar(100) in SANPHAM
--------------------------------------------------------------------------------
ALTER TABLE SANPHAM 
ALTER COLUMN GHICHU VARCHAR(100);

--------------------------------------------------------------------------------
-- Task 5: Drop attribute GHICHU from SANPHAM
--------------------------------------------------------------------------------
ALTER TABLE SANPHAM 
DROP COLUMN GHICHU;

--------------------------------------------------------------------------------
-- Task 6: Modify LOAIKH to store descriptive text ("Vang lai", "Thuong xuyen", "Vip")
--------------------------------------------------------------------------------
ALTER TABLE KHACHHANG 
ALTER COLUMN LOAIKH VARCHAR(20);

--------------------------------------------------------------------------------
-- Task 7: Constraint - Product unit (DVT) must be 'cay', 'hop', 'cai', 'quyen', or 'chuc'
--------------------------------------------------------------------------------
ALTER TABLE SANPHAM 
ADD CONSTRAINT CHK_DVT CHECK (DVT IN ('cay', 'hop', 'cai', 'quyen', 'chuc'));

--------------------------------------------------------------------------------
-- Task 8: Constraint - Selling price (GIA) must be at least 500
--------------------------------------------------------------------------------
ALTER TABLE SANPHAM 
ADD CONSTRAINT CHK_GIA CHECK (GIA >= 500);

--------------------------------------------------------------------------------
-- Task 9: Constraint - Each item purchase quantity must be at least 1
--------------------------------------------------------------------------------
ALTER TABLE CTHD 
ADD CONSTRAINT CHK_SL CHECK (SL >= 1);

--------------------------------------------------------------------------------
-- Task 10: Constraint - Customer registration date (NGDK) must be greater than Date of Birth (NGSINH)
--------------------------------------------------------------------------------
ALTER TABLE KHACHHANG 
ADD CONSTRAINT CHK_NGDK_NGSINH CHECK (NGDK > NGSINH);

--------------------------------------------------------------------------------
-- Task 11: Constraint - Purchase date (NGHD) must be >= Registration date (NGDK)
-- Note: Must be implemented via TRIGGER or stored procedure due to inter-table constraints.
--------------------------------------------------------------------------------
GO
CREATE TRIGGER TRG_HOADON_NGHD_KHACHHANG
ON HOADON
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        JOIN KHACHHANG K ON I.MAKH = K.MAKH
        WHERE I.NGHD < K.NGDK
    )
    BEGIN
        RAISERROR ('Error: Purchase date (NGHD) must be greater than or equal to member registration date (NGDK).', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--------------------------------------------------------------------------------
-- Task 12: Constraint - Sales date (NGHD) must be >= Employee hire date (NGVL)
--------------------------------------------------------------------------------
GO
CREATE TRIGGER TRG_HOADON_NGHD_NHANVIEN
ON HOADON
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        JOIN NHANVIEN N ON I.MANV = N.MANV
        WHERE I.NGHD < N.NGVL
    )
    BEGIN
        RAISERROR ('Error: Order date (NGHD) must be greater than or equal to employee hire date (NGVL).', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--------------------------------------------------------------------------------
-- Task 13: Constraint - Each invoice must have at least one order detail
-- Note: Handled by checking CTHD existence when finalizing order details.
--------------------------------------------------------------------------------
GO
CREATE TRIGGER TRG_DELETE_CTHD
ON CTHD
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        SELECT SOHD 
        FROM HOADON H
        WHERE NOT EXISTS (SELECT 1 FROM CTHD C WHERE C.SOHD = H.SOHD)
    )
    BEGIN
        RAISERROR ('Error: Each invoice must contain at least one detail line.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--------------------------------------------------------------------------------
-- Task 14: Constraint - Order total (TRIGIA) equals sum of (Quantity * Unit Price)
--------------------------------------------------------------------------------
GO
CREATE TRIGGER TRG_UPDATE_TRIGIA
ON CTHD
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE HOADON
    SET TRIGIA = ISNULL((
        SELECT SUM(C.SL * S.GIA)
        FROM CTHD C
        JOIN SANPHAM S ON C.MASP = S.MASP
        WHERE C.SOHD = HOADON.SOHD
    ), 0)
    WHERE SOHD IN (
        SELECT DISTINCT SOHD FROM INSERTED
        UNION
        SELECT DISTINCT SOHD FROM DELETED
    );
END;
GO

--------------------------------------------------------------------------------
-- Task 15: Constraint - Customer spending (DOANHSO) equals sum of purchased invoice values
--------------------------------------------------------------------------------
GO
CREATE TRIGGER TRG_UPDATE_DOANHSO
ON HOADON
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE KHACHHANG
    SET DOANHSO = ISNULL((
        SELECT SUM(H.TRIGIA)
        FROM HOADON H
        WHERE H.MAKH = KHACHHANG.MAKH
    ), 0)
    WHERE MAKH IN (
        SELECT DISTINCT MAKH FROM INSERTED
        UNION
        SELECT DISTINCT MAKH FROM DELETED
    );
END;
GO

