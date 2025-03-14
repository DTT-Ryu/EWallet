USE EWallet;

-- Bảng người dùng
CREATE TABLE tblUsers (
    iUserID_PK INT IDENTITY(1,1) PRIMARY KEY,  -- Mã người dùng (PK)
    sPhoneNumber VARCHAR(10) UNIQUE NOT NULL,  -- Số điện thoại
    sFullName NVARCHAR(100) NOT NULL,          -- Họ tên
    sCCCD VARCHAR(12) UNIQUE NOT NULL,         -- Căn cước công dân
    dBirthDate DATE NOT NULL,                  -- Ngày sinh
    sEmail VARCHAR(100) UNIQUE NOT NULL,       -- Email
    fBalance DECIMAL(15,2) DEFAULT 0,          -- Số dư ví
    sPasswordHash VARCHAR(255) NOT NULL,       -- Mật khẩu đã mã hóa
    sPinCode VARCHAR(6) NOT NULL,              -- Mã PIN
    dCreatedAt DATETIME DEFAULT GETDATE(),     -- Ngày tạo tài khoản
    sStatus NVARCHAR(10) CHECK (sStatus IN ('active', 'blocked')) DEFAULT 'active'  -- Trạng thái tài khoản
);

-- Bảng ngân hàng
CREATE TABLE tblBanks (
    sBankID_PK VARCHAR(10) PRIMARY KEY NOT NULL,  -- Mã ngân hàng (PK)
    sBankName NVARCHAR(100) UNIQUE NOT NULL,      -- Tên ngân hàng
    sImage VARCHAR(255) NULL                      -- Ảnh logo ngân hàng (có thể NULL)
);

-- Bảng tài khoản ngân hàng
CREATE TABLE tblBankAccounts (
    iAccountID_PK INT IDENTITY(1,1) PRIMARY KEY,  -- Mã tài khoản ngân hàng (PK)
    iUserID_FK INT NOT NULL,                      -- Mã người dùng (FK)
    sBankID_FK VARCHAR(10) NOT NULL,              -- Mã ngân hàng (FK)
    sAccountNumber VARCHAR(20) UNIQUE NOT NULL,   -- Số tài khoản ngân hàng
    sStatus NVARCHAR(10) CHECK (sStatus IN ('active', 'blocked')) DEFAULT 'active',

    CONSTRAINT FK_tblBankAccounts_User FOREIGN KEY (iUserID_FK) REFERENCES tblUsers(iUserID_PK),
    CONSTRAINT FK_tblBankAccounts_Bank FOREIGN KEY (sBankID_FK) REFERENCES tblBanks(sBankID_PK)
);

-- Bảng giao dịch
CREATE TABLE tblTransactions (
    iTransactionID_PK INT IDENTITY(1,1) PRIMARY KEY,  -- Mã giao dịch (PK)
    iSenderUserID_FK INT NOT NULL,                    -- Người gửi (FK)
    sTransactionType NVARCHAR(10) CHECK (sTransactionType IN ('deposit', 'withdraw', 'transfer')) NOT NULL,  -- Loại giao dịch
    fAmount DECIMAL(15,2) NOT NULL,                   -- Số tiền giao dịch
    dCreatedAt DATETIME DEFAULT GETDATE(),            -- Thời gian thực hiện
    sDescription NVARCHAR(255) NULL,                  -- Nội dung giao dịch
    iRecipientUserID_FK INT NULL,                     -- Người nhận (FK - có thể NULL)
    iBankAccountID_FK INT NULL,                       -- Tài khoản ngân hàng (FK - có thể NULL)
    sStatus NVARCHAR(10) CHECK (sStatus IN ('pending', 'completed', 'failed')) DEFAULT 'pending',

    CONSTRAINT FK_tblTransactions_Sender FOREIGN KEY (iSenderUserID_FK) REFERENCES tblUsers(iUserID_PK),
    CONSTRAINT FK_tblTransactions_Recipient FOREIGN KEY (iRecipientUserID_FK) REFERENCES tblUsers(iUserID_PK),
    CONSTRAINT FK_tblTransactions_Bank FOREIGN KEY (iBankAccountID_FK) REFERENCES tblBankAccounts(iAccountID_PK)
);

-- Bảng quản trị viên
CREATE TABLE tblAdmin (
    iAdminID_PK INT IDENTITY(1,1) PRIMARY KEY,  -- Mã Admin (PK)
    sFullName NVARCHAR(100) NOT NULL,           -- Tên Admin
    sPhoneNumber VARCHAR(10) UNIQUE NOT NULL,   -- Số điện thoại đăng nhập
    sPasswordHash VARCHAR(255) NOT NULL         -- Mật khẩu mã hóa
);


USE EWallet;

-- Dữ liệu cho bảng người dùng
INSERT INTO tblUsers (sPhoneNumber, sFullName, sCCCD, dBirthDate, sEmail, fBalance, sPasswordHash, sPinCode, sStatus)
VALUES 
('0123456789', 'Nguyễn Văn A', '012345678901', '1990-01-01', 'a@example.com', 15000000, 'password123', '123456', 'active'),
('0987654321', 'Trần Thị B', '123456789012', '1992-02-02', 'b@example.com', 25000000, 'password456', '654321', 'active'),
('0912345678', 'Lê Văn C', '234567890123', '1988-03-03', 'c@example.com', 5000000, 'password789', '111111', 'blocked'),
('0934567890', 'Phạm Thị D', '345678901234', '1995-04-04', 'd@example.com', 30000000, 'password321', '222222', 'active'),
('0945678901', 'Vũ Văn E', '456789012345', '1985-05-05', 'e@example.com', 20000000, 'password654', '333333', 'active'),
('0976543210', 'Hoàng Thị F', '567890123456', '1993-06-06', 'f@example.com', 10000000, 'password987', '444444', 'active'),
('0965432109', 'Đặng Văn G', '678901234567', '1991-07-07', 'g@example.com', 17000000, 'password159', '555555', 'blocked'),
('0954321098', 'Phan Thị H', '789012345678', '1994-08-08', 'h@example.com', 22000000, 'password753', '666666', 'active'),
('0943210987', 'Ngô Văn I', '890123456789', '1996-09-09', 'i@example.com', 27000000, 'password852', '777777', 'active'),
('0932109876', 'Bùi Thị J', '901234567890', '1989-10-10', 'j@example.com', 32000000, 'password951', '888888', 'active');

-- Dữ liệu cho bảng ngân hàng
INSERT INTO tblBanks (sBankID_PK, sBankName)
VALUES 
('BIDV', 'Ngân hàng Đầu tư và Phát triển Việt Nam'),
('VCB', 'Vietcombank (Ngân hàng Ngoại thương Việt Nam)'),
('VPB', 'VPBank (Ngân hàng Việt Nam Thịnh Vượng)'),
('TCB', 'Techcombank (Ngân hàng Kỹ Thương Việt Nam)'),
('TPB', 'TPBank (Ngân hàng Tiên Phong');

-- Dữ liệu cho bảng tài khoản ngân hàng
INSERT INTO tblBankAccounts (iUserID_FK, sBankID_FK, sAccountNumber, sStatus)
VALUES 
(1, 'BIDV', '012345678901', 'active'),
(2, 'VCB', '123456789012', 'active'),
(3, 'VPB', '234567890123', 'blocked'),
(4, 'TCB', '345678901234', 'active'),
(5, 'TPB', '456789012345', 'active'),
(6, 'BIDV', '567890123456', 'active'),
(7, 'VCB', '678901234567', 'blocked'),
(8, 'VPB', '789012345678', 'active'),
(9, 'TCB', '890123456789', 'active'),
(10, 'TPB', '901234567890', 'active');

-- Dữ liệu cho bảng giao dịch
INSERT INTO tblTransactions (iSenderUserID_FK, sTransactionType, fAmount, sDescription, iRecipientUserID_FK, iBankAccountID_FK, sStatus)
VALUES 
(1, 'deposit', 15000000, 'Nạp tiền từ ngân hàng', NULL, 1, 'completed'),
(2, 'deposit', 25000000, 'Nạp tiền từ ngân hàng', NULL, 2, 'completed'),
(3, 'withdraw', 5000000, 'Rút tiền về ngân hàng', NULL, 3, 'completed'),
(4, 'transfer', 3000000, 'Chuyển tiền cho bạn', 5, NULL, 'completed'),
(5, 'transfer', 2000000, 'Chuyển tiền cho bạn', 6, NULL, 'completed'),
(6, 'deposit', 10000000, 'Nạp tiền từ ngân hàng', NULL, 6, 'completed'),
(7, 'withdraw', 7000000, 'Rút tiền về ngân hàng', NULL, 7, 'completed'),
(8, 'transfer', 1000000, 'Chuyển tiền cho bạn', 9, NULL, 'completed'),
(9, 'deposit', 27000000, 'Nạp tiền từ ngân hàng', NULL, 9, 'completed'),
(10, 'withdraw', 1500000, 'Rút tiền về ngân hàng', NULL, 10, 'completed');

-- Dữ liệu cho bảng quản trị viên
INSERT INTO tblAdmin (sFullName, sPhoneNumber, sPasswordHash)
VALUES 
('Admin One', '0911111111', 'admin123'),
('Admin Two', '0922222222', 'admin456'),
('Admin Three', '0933333333', 'admin789');
