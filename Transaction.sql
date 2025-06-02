
-- TRANSACTION SCRIPTS FOR LIBRARY MANAGEMENT SYSTEM --

-- 1. Borrowing a book (insert loan + update availability)
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, Status)
    VALUES (1, 3, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');

    UPDATE Book
    SET IsAvailable = 0
    WHERE BookID = 3;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;

-- 2. Returning a book (update status + return date + availability)
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE Loan
    SET ReturnDate = GETDATE(), Status = 'Returned'
    WHERE LoanID = 7;

    UPDATE Book
    SET IsAvailable = 1
    WHERE BookID = (SELECT BookID FROM Loan WHERE LoanID = 7);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;

-- 3. Registering a payment (with validation)
BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @LoanID INT = 3;
    DECLARE @Amount DECIMAL(10,2) = 5.00;

    IF @Amount > 0
    BEGIN
        INSERT INTO Payment (LoanID, PaymentDate, Amount, Method)
        VALUES (@LoanID, GETDATE(), @Amount, 'Cash');
    END

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;

-- 4. Batch loan insert with rollback on failure
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, Status)
    VALUES 
        (2, 5, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued'),
        (3, 6, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');

    UPDATE Book
    SET IsAvailable = 0
    WHERE BookID IN (5, 6);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;
