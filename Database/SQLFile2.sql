CREATE DATABASE QuanLyThuVienSinhVien;
GO

USE QuanLyThuVienSinhVien;
GO

-- =========================================
-- 1. BẢNG LOẠI SÁCH
-- =========================================
CREATE TABLE BookCategories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

-- =========================================
-- 2. BẢNG SINH VIÊN
-- =========================================
CREATE TABLE Students (
    StudentId INT IDENTITY(1,1) PRIMARY KEY,
    StudentCode VARCHAR(20) NOT NULL UNIQUE,
    FullName NVARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NULL,
    ClassName NVARCHAR(50) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- =========================================
-- 3. BẢNG SÁCH
-- =========================================
CREATE TABLE Books (
    BookId INT IDENTITY(1,1) PRIMARY KEY,
    BookCode VARCHAR(20) NOT NULL UNIQUE,
    Title NVARCHAR(200) NOT NULL,
    Author NVARCHAR(100) NULL,
    Publisher NVARCHAR(100) NULL,
    PublishYear INT NULL,
    CategoryId INT NOT NULL,
    QuantityTotal INT NOT NULL DEFAULT 0,
    QuantityAvailable INT NOT NULL DEFAULT 0,
    Status VARCHAR(20) NOT NULL DEFAULT 'Active',
    Note NVARCHAR(255) NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Books_BookCategories
        FOREIGN KEY (CategoryId) REFERENCES BookCategories(CategoryId),

    CONSTRAINT CK_Books_QuantityTotal
        CHECK (QuantityTotal >= 0),

    CONSTRAINT CK_Books_QuantityAvailable
        CHECK (QuantityAvailable >= 0),

    CONSTRAINT CK_Books_Status
        CHECK (Status IN ('Active', 'Inactive'))
);
GO

-- =========================================
-- 4. BẢNG PHIẾU MƯỢN
-- =========================================
CREATE TABLE BorrowTickets (
    TicketId INT IDENTITY(1,1) PRIMARY KEY,
    TicketCode VARCHAR(30) NOT NULL UNIQUE,
    StudentId INT NOT NULL,
    BorrowDate DATE NOT NULL,
    ExpectedReturnDate DATE NOT NULL,
    ReturnDate DATE NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Borrowing',
    Note NVARCHAR(255) NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_BorrowTickets_Students
        FOREIGN KEY (StudentId) REFERENCES Students(StudentId),

    CONSTRAINT CK_BorrowTickets_Status
        CHECK (Status IN ('Borrowing', 'Returned', 'Cancelled', 'Overdue')),

    CONSTRAINT CK_BorrowTickets_Date
        CHECK (ExpectedReturnDate >= BorrowDate)
);
GO

-- =========================================
-- 5. BẢNG CHI TIẾT PHIẾU MƯỢN
-- =========================================
CREATE TABLE BorrowTicketDetails (
    DetailId INT IDENTITY(1,1) PRIMARY KEY,
    TicketId INT NOT NULL,
    BookId INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    ConditionBefore NVARCHAR(255) NULL,
    ConditionAfter NVARCHAR(255) NULL,
    IsReturned BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_BorrowTicketDetails_BorrowTickets
        FOREIGN KEY (TicketId) REFERENCES BorrowTickets(TicketId),

    CONSTRAINT FK_BorrowTicketDetails_Books
        FOREIGN KEY (BookId) REFERENCES Books(BookId),

    CONSTRAINT CK_BorrowTicketDetails_Quantity
        CHECK (Quantity > 0)
);
GO

-- =========================================
-- 6. DỮ LIỆU MẪU
-- =========================================

INSERT INTO BookCategories (CategoryName, Description, IsActive)
VALUES
(N'Công nghệ thông tin', N'Sách lập trình, cơ sở dữ liệu, mạng máy tính', 1),
(N'Kinh tế', N'Sách kinh tế, quản trị, marketing', 1),
(N'Ngoại ngữ', N'Sách tiếng Anh, tiếng Nhật, tiếng Hàn', 1),
(N'Kỹ năng mềm', N'Sách kỹ năng giao tiếp, học tập, làm việc nhóm', 1),
(N'Văn học', N'Truyện, tiểu thuyết và sách văn học', 1);
GO

INSERT INTO Students (StudentCode, FullName, PhoneNumber, Email, ClassName)
VALUES
('SV001', N'Lê Đình Danh', '0911222333', 'danh@student.edu.vn', N'CTK45A'),
('SV002', N'Ngô Thanh Nguyên', '0988777666', 'nguyen@student.edu.vn', N'CTK45A'),
('SV003', N'Trần Văn Minh', '0909123456', 'minh@student.edu.vn', N'CTK44B'),
('SV004', N'Phạm Thị Lan', '0977888999', 'lan@student.edu.vn', N'CTK46C');
GO

INSERT INTO Books 
(BookCode, Title, Author, Publisher, PublishYear, CategoryId, QuantityTotal, QuantityAvailable, Status, Note)
VALUES
('B001', N'Lập trình C# cơ bản', N'Nguyễn Văn A', N'NXB Giáo dục', 2022, 1, 10, 10, 'Active', NULL),
('B002', N'ASP.NET Core MVC thực hành', N'Trần Văn B', N'NXB Công nghệ', 2023, 1, 8, 8, 'Active', NULL),
('B003', N'Cơ sở dữ liệu SQL Server', N'Lê Văn C', N'NXB Đại học', 2021, 1, 12, 12, 'Active', NULL),
('B004', N'Quản trị học căn bản', N'Phạm Văn D', N'NXB Kinh tế', 2020, 2, 6, 6, 'Active', NULL),
('B005', N'Tiếng Anh giao tiếp sinh viên', N'John Smith', N'NXB Ngoại ngữ', 2022, 3, 15, 15, 'Active', NULL),
('B006', N'Kỹ năng làm việc nhóm', N'Nguyễn Thị E', N'NXB Trẻ', 2021, 4, 9, 9, 'Active', NULL),
('B007', N'Tôi thấy hoa vàng trên cỏ xanh', N'Nguyễn Nhật Ánh', N'NXB Trẻ', 2019, 5, 5, 5, 'Active', NULL);
GO

-- Phiếu mượn mẫu
INSERT INTO BorrowTickets 
(TicketCode, StudentId, BorrowDate, ExpectedReturnDate, ReturnDate, Status, Note)
VALUES
('PM001', 1, '2026-05-20', '2026-05-27', '2026-05-26', 'Returned', N'Đã trả đủ sách'),
('PM002', 2, '2026-05-25', '2026-06-01', NULL, 'Borrowing', N'Đang mượn sách lập trình'),
('PM003', 3, '2026-05-15', '2026-05-22', NULL, 'Overdue', N'Quá hạn trả sách');
GO

INSERT INTO BorrowTicketDetails
(TicketId, BookId, Quantity, ConditionBefore, ConditionAfter, IsReturned)
VALUES
(1, 1, 1, N'Sách còn tốt', N'Sách còn tốt', 1),
(1, 3, 1, N'Sách còn tốt', N'Sách hơi cũ', 1),
(2, 2, 1, N'Sách còn tốt', NULL, 0),
(2, 3, 1, N'Sách còn tốt', NULL, 0),
(3, 5, 1, N'Sách còn tốt', NULL, 0);
GO

-- Cập nhật số lượng sách đang được mượn trong dữ liệu mẫu
UPDATE Books SET QuantityAvailable = QuantityAvailable - 1 WHERE BookId = 2;
UPDATE Books SET QuantityAvailable = QuantityAvailable - 1 WHERE BookId = 3;
UPDATE Books SET QuantityAvailable = QuantityAvailable - 1 WHERE BookId = 5;
GO

-- =========================================
-- 7. VIEW THỐNG KÊ DASHBOARD
-- =========================================

CREATE VIEW vw_LibraryDashboard AS
SELECT
    (SELECT COUNT(*) FROM Books WHERE IsDeleted = 0) AS TotalBooks,
    (SELECT SUM(QuantityTotal) FROM Books WHERE IsDeleted = 0) AS TotalBookQuantity,
    (SELECT SUM(QuantityAvailable) FROM Books WHERE IsDeleted = 0) AS AvailableBookQuantity,
    (SELECT COUNT(*) FROM Students WHERE IsActive = 1) AS ActiveStudents,
    (SELECT COUNT(*) FROM BorrowTickets WHERE Status = 'Borrowing') AS BorrowingTicketCount,
    (SELECT COUNT(*) FROM BorrowTickets WHERE Status = 'Returned') AS ReturnedTicketCount,
    (SELECT COUNT(*) FROM BorrowTickets WHERE Status = 'Overdue') AS OverdueTicketCount;
GO

-- =========================================
-- 8. TRUY VẤN KIỂM TRA NHANH
-- =========================================

SELECT * FROM BookCategories;
SELECT * FROM Students;
SELECT * FROM Books;
SELECT * FROM BorrowTickets;
SELECT * FROM BorrowTicketDetails;
SELECT * FROM vw_LibraryDashboard;
GO