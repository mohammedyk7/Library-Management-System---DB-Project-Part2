
-- TRIGGERS FOR LIBRARY MANAGEMENT SYSTEM --

-- 1. Trigger: trg_UpdateBookAvailability
-- After a new loan, mark the book as unavailable
CREATE TRIGGER trg_UpdateBookAvailability
ON Loan
AFTER INSERT
AS
BEGIN
    UPDATE B
    SET B.IsAvailable = 0
    FROM Book B
    JOIN inserted i ON B.BookID = i.BookID;
END;

-- 2. Trigger: trg_LoanDateValidation
-- Prevent invalid return dates (return date before loan date)
CREATE TRIGGER trg_LoanDateValidation
ON Loan
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT * FROM inserted
        WHERE ReturnDate IS NOT NULL AND ReturnDate < LoanDate
    )
    BEGIN
        RAISERROR('Return date cannot be earlier than loan date.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, ReturnDate, Status)
        SELECT MemberID, BookID, LoanDate, DueDate, ReturnDate, Status
        FROM inserted;
    END
END;

CREATE TABLE LibraryRevenue (
    LibraryID INT PRIMARY KEY,
    TotalRevenue DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
);

CREATE TRIGGER trg_CalculateLibraryRevenue
ON Payment
AFTER INSERT
AS
BEGIN
    UPDATE LR
    SET LR.TotalRevenue = LR.TotalRevenue + i.Amount
    FROM inserted i
    JOIN Loan L ON L.LoanID = i.LoanID
    JOIN Book B ON B.BookID = L.BookID
    JOIN LibraryRevenue LR ON B.LibraryID = LR.LibraryID;
END;
