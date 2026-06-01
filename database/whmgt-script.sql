-- ============================================================
-- SQL Script: Tạo cơ sở dữ liệu Quản lý kho hàng
-- Database: WarehouseManagementDb
-- SQL Server 2019+
-- Phiên bản script: 2026-06-01 (đồng bộ migration 20260531152953_InitialCreate)
-- ============================================================

USE master;
GO

IF DB_ID('WarehouseManagementDb') IS NOT NULL
BEGIN
    ALTER DATABASE WarehouseManagementDb SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE WarehouseManagementDb;
END
GO

CREATE DATABASE WarehouseManagementDb;
GO

USE WarehouseManagementDb;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- ============================================================
-- ASP.NET Core Identity Tables
-- ============================================================

CREATE TABLE AspNetRoles (
    Id NVARCHAR(128) NOT NULL PRIMARY KEY,
    Name NVARCHAR(256) NULL,
    NormalizedName NVARCHAR(256) NULL,
    ConcurrencyStamp NVARCHAR(MAX) NULL
);
GO

CREATE UNIQUE INDEX IX_AspNetRoles_NormalizedName ON AspNetRoles(NormalizedName) WHERE NormalizedName IS NOT NULL;
GO

CREATE TABLE AspNetUsers (
    Id NVARCHAR(128) NOT NULL PRIMARY KEY,
    FullName NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UserName NVARCHAR(256) NULL,
    NormalizedUserName NVARCHAR(256) NULL,
    Email NVARCHAR(256) NULL,
    NormalizedEmail NVARCHAR(256) NULL,
    EmailConfirmed BIT NOT NULL DEFAULT 0,
    PasswordHash NVARCHAR(MAX) NULL,
    SecurityStamp NVARCHAR(MAX) NULL,
    ConcurrencyStamp NVARCHAR(MAX) NULL,
    PhoneNumber NVARCHAR(MAX) NULL,
    PhoneNumberConfirmed BIT NOT NULL DEFAULT 0,
    TwoFactorEnabled BIT NOT NULL DEFAULT 0,
    LockoutEnd DATETIMEOFFSET NULL,
    LockoutEnabled BIT NOT NULL DEFAULT 1,
    AccessFailedCount INT NOT NULL DEFAULT 0
);
GO

CREATE UNIQUE INDEX IX_AspNetUsers_NormalizedUserName ON AspNetUsers(NormalizedUserName) WHERE NormalizedUserName IS NOT NULL;
CREATE INDEX IX_AspNetUsers_NormalizedEmail ON AspNetUsers(NormalizedEmail);
GO

CREATE TABLE AspNetRoleClaims (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RoleId NVARCHAR(128) NOT NULL REFERENCES AspNetRoles(Id) ON DELETE CASCADE,
    ClaimType NVARCHAR(MAX) NULL,
    ClaimValue NVARCHAR(MAX) NULL
);
GO

CREATE TABLE AspNetUserClaims (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserId NVARCHAR(128) NOT NULL REFERENCES AspNetUsers(Id) ON DELETE CASCADE,
    ClaimType NVARCHAR(MAX) NULL,
    ClaimValue NVARCHAR(MAX) NULL
);
GO

CREATE TABLE AspNetUserLogins (
    LoginProvider NVARCHAR(128) NOT NULL,
    ProviderKey NVARCHAR(128) NOT NULL,
    ProviderDisplayName NVARCHAR(MAX) NULL,
    UserId NVARCHAR(128) NOT NULL REFERENCES AspNetUsers(Id) ON DELETE CASCADE,
    PRIMARY KEY (LoginProvider, ProviderKey)
);
GO

CREATE TABLE AspNetUserRoles (
    UserId NVARCHAR(128) NOT NULL REFERENCES AspNetUsers(Id) ON DELETE CASCADE,
    RoleId NVARCHAR(128) NOT NULL REFERENCES AspNetRoles(Id) ON DELETE CASCADE,
    PRIMARY KEY (UserId, RoleId)
);
GO

CREATE TABLE AspNetUserTokens (
    UserId NVARCHAR(128) NOT NULL REFERENCES AspNetUsers(Id) ON DELETE CASCADE,
    LoginProvider NVARCHAR(128) NOT NULL,
    Name NVARCHAR(128) NOT NULL,
    Value NVARCHAR(MAX) NULL,
    PRIMARY KEY (UserId, LoginProvider, Name)
);
GO

-- ============================================================
-- Application Tables
-- ============================================================

CREATE TABLE Categories (
    CategoryId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CategoryCode NVARCHAR(50) NOT NULL,
    CategoryName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL
);
GO

CREATE UNIQUE INDEX IX_Categories_CategoryCode ON Categories(CategoryCode);
GO

CREATE TABLE Units (
    UnitId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UnitName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL
);
GO

CREATE UNIQUE INDEX IX_Units_UnitName ON Units(UnitName);
GO

CREATE TABLE Products (
    ProductId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductCode NVARCHAR(50) NOT NULL,
    ProductName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Barcode NVARCHAR(100) NULL,
    CategoryId INT NOT NULL,
    UnitId INT NOT NULL,
    CostPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    SellingPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    MinimumStock DECIMAL(18,2) NOT NULL DEFAULT 0,
    CurrentStock DECIMAL(18,2) NOT NULL DEFAULT 0,
    ImageUrl NVARCHAR(500) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL,
    RowVersion ROWVERSION NOT NULL,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId) ON DELETE NO ACTION,
    CONSTRAINT FK_Products_Units FOREIGN KEY (UnitId) REFERENCES Units(UnitId) ON DELETE NO ACTION
);
GO

CREATE UNIQUE INDEX IX_Products_ProductCode ON Products(ProductCode);
GO

CREATE TABLE Suppliers (
    SupplierId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SupplierCode NVARCHAR(50) NOT NULL,
    SupplierName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    ContactName NVARCHAR(255) NULL,
    Phone NVARCHAR(50) NULL,
    Email NVARCHAR(255) NULL,
    Address NVARCHAR(500) NULL,
    TaxCode NVARCHAR(50) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL
);
GO

CREATE UNIQUE INDEX IX_Suppliers_SupplierCode ON Suppliers(SupplierCode);
GO

CREATE TABLE Customers (
    CustomerId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CustomerCode NVARCHAR(50) NOT NULL,
    CustomerName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Phone NVARCHAR(50) NULL,
    Email NVARCHAR(255) NULL,
    Address NVARCHAR(500) NULL,
    TaxCode NVARCHAR(50) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL
);
GO

CREATE UNIQUE INDEX IX_Customers_CustomerCode ON Customers(CustomerCode);
GO

CREATE TABLE StockIns (
    StockInId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    StockInCode NVARCHAR(50) NOT NULL,
    SupplierId INT NOT NULL,
    StockInDate DATETIME2 NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Draft',
    Note NVARCHAR(MAX) NULL,
    CreatedBy NVARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL,
    ConfirmedBy NVARCHAR(255) NULL,
    ConfirmedAt DATETIME2 NULL,
    CONSTRAINT FK_StockIns_Suppliers FOREIGN KEY (SupplierId) REFERENCES Suppliers(SupplierId) ON DELETE NO ACTION
);
GO

CREATE UNIQUE INDEX IX_StockIns_StockInCode ON StockIns(StockInCode);
GO

CREATE TABLE StockInDetails (
    StockInDetailId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    StockInId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity DECIMAL(18,2) NOT NULL DEFAULT 0,
    UnitPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    Amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    Note NVARCHAR(500) NULL,
    CONSTRAINT FK_StockInDetails_StockIns FOREIGN KEY (StockInId) REFERENCES StockIns(StockInId) ON DELETE CASCADE,
    CONSTRAINT FK_StockInDetails_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE NO ACTION
);
GO

CREATE TABLE StockOuts (
    StockOutId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    StockOutCode NVARCHAR(50) NOT NULL,
    CustomerId INT NULL,
    StockOutDate DATETIME2 NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Draft',
    Note NVARCHAR(MAX) NULL,
    CreatedBy NVARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL,
    ConfirmedBy NVARCHAR(255) NULL,
    ConfirmedAt DATETIME2 NULL,
    CONSTRAINT FK_StockOuts_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId) ON DELETE NO ACTION
);
GO

CREATE UNIQUE INDEX IX_StockOuts_StockOutCode ON StockOuts(StockOutCode);
GO

CREATE TABLE StockOutDetails (
    StockOutDetailId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    StockOutId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity DECIMAL(18,2) NOT NULL DEFAULT 0,
    UnitPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    Amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    Note NVARCHAR(500) NULL,
    CONSTRAINT FK_StockOutDetails_StockOuts FOREIGN KEY (StockOutId) REFERENCES StockOuts(StockOutId) ON DELETE CASCADE,
    CONSTRAINT FK_StockOutDetails_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE NO ACTION
);
GO

CREATE TABLE InventoryTransactions (
    InventoryTransactionId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductId INT NOT NULL,
    TransactionDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    TransactionType NVARCHAR(50) NOT NULL,
    ReferenceCode NVARCHAR(50) NOT NULL,
    ReferenceType NVARCHAR(50) NOT NULL,
    Quantity DECIMAL(18,2) NOT NULL DEFAULT 0,
    UnitPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    StockBefore DECIMAL(18,2) NOT NULL DEFAULT 0,
    StockAfter DECIMAL(18,2) NOT NULL DEFAULT 0,
    Note NVARCHAR(1000) NULL,
    CreatedBy NVARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_InventoryTransactions_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE NO ACTION
);
GO

CREATE INDEX IX_InventoryTransactions_ProductId ON InventoryTransactions(ProductId);
CREATE INDEX IX_InventoryTransactions_TransactionDate ON InventoryTransactions(TransactionDate);
CREATE INDEX IX_InventoryTransactions_ReferenceCode ON InventoryTransactions(ReferenceCode);
GO

-- ============================================================
-- Seed Data
-- ============================================================

-- Roles
INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp) VALUES
(NEWID(), 'Admin', 'ADMIN', NEWID()),
(NEWID(), 'Manager', 'MANAGER', NEWID()),
(NEWID(), 'Staff', 'STAFF', NEWID()),
(NEWID(), 'Viewer', 'VIEWER', NEWID());
GO

-- Categories
INSERT INTO Categories (CategoryCode, CategoryName, Description, IsActive, CreatedAt) VALUES
(N'NH000001', N'Điện tử', N'Thiết bị điện tử', 1, GETDATE()),
(N'NH000002', N'Gia dụng', N'Đồ gia dụng', 1, GETDATE()),
(N'NH000003', N'Văn phòng phẩm', N'Dụng cụ văn phòng', 1, GETDATE()),
(N'NH000004', N'Phụ kiện', N'Phụ kiện các loại', 1, GETDATE()),
(N'NH000005', N'Khác', N'Hàng hóa khác', 1, GETDATE());
GO

-- Units
INSERT INTO Units (UnitName, Description, IsActive, CreatedAt) VALUES
(N'Cái', N'Đơn vị: cái', 1, GETDATE()),
(N'Hộp', N'Đơn vị: hộp', 1, GETDATE()),
(N'Thùng', N'Đơn vị: thùng', 1, GETDATE()),
(N'Kg', N'Đơn vị: kilogram', 1, GETDATE()),
(N'Mét', N'Đơn vị: mét', 1, GETDATE()),
(N'Lít', N'Đơn vị: lít', 1, GETDATE()),
(N'Bộ', N'Đơn vị: bộ', 1, GETDATE());
GO

-- Suppliers
INSERT INTO Suppliers (SupplierCode, SupplierName, ContactName, Phone, Email, Address, IsActive, CreatedAt) VALUES
(N'NCC000001', N'Công ty TNHH ABC', N'Nguyễn Văn A', '0901234567', 'contact@abc.com', N'123 Nguyễn Trãi, Q.1, TP.HCM', 1, GETDATE()),
(N'NCC000002', N'Công ty Thương mại XYZ', N'Trần Thị B', '0912345678', 'info@xyz.vn', N'456 Lê Lợi, Q.3, TP.HCM', 1, GETDATE()),
(N'NCC000003', N'Nhà cung cấp Minh Long', N'Lê Văn C', '0923456789', 'minhlong@email.com', N'789 Hai Bà Trưng, Q.5, TP.HCM', 1, GETDATE());
GO

-- Customers
INSERT INTO Customers (CustomerCode, CustomerName, Phone, Email, Address, IsActive, CreatedAt) VALUES
(N'KH000001', N'Khách lẻ', '', '', '', 1, GETDATE()),
(N'KH000002', N'Công ty TNHH Demo', '0934567890', 'demo@company.vn', N'100 Võ Văn Tần, Q.3, TP.HCM', 1, GETDATE()),
(N'KH000003', N'Đại lý khu vực 1', '0945678901', 'daily1@email.com', N'200 Cách Mạng Tháng 8, Q.10, TP.HCM', 1, GETDATE());
GO

-- ============================================================
-- EF Migrations History (đánh dấu migration đã áp dụng)
-- ============================================================

CREATE TABLE __EFMigrationsHistory (
    MigrationId NVARCHAR(150) NOT NULL PRIMARY KEY,
    ProductVersion NVARCHAR(32) NOT NULL
);
GO

INSERT INTO __EFMigrationsHistory (MigrationId, ProductVersion) VALUES
('20260531152953_InitialCreate', '8.0.11');
GO

PRINT N'Database WarehouseManagementDb created successfully.';
PRINT N'Default admin user will be created by application on first run (admin / Admin@123).';
GO
