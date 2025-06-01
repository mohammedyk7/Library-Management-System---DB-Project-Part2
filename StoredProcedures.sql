
-- STORED PROCEDURES FOR LIBRARY MANAGEMENT SYSTEM --

-- 1. Procedure: MarkBookAsUnavailable
CREATE PROCEDURE sp_MarkBookAsUnavailable
    @BookID INT
AS
BEGIN
    UPDATE Book
    SET IsAvailable = 0
    WHERE BookID = @BookID;
END;

-- 2. Procedure: UpdateLoanStatus
CREATE PROCEDURE sp_UpdateLoanStatus
    @LoanID INT,
    @NewStatus VARCHAR(20)
AS
BEGIN
    UPDATE Loan
    SET Status = @NewStatus
    WHERE LoanID = @LoanID;b v
END;

-- 3. Procedure: AddNewLoan
CREATE PROCEDURE sp_AddNewLoan
    @MemberID INT,
    @BookID INT,
    @LoanDate DATE,
    @DueDate DATE
AS
BEGIN
    INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, Status)
    VALUES (@MemberID, @BookID, @LoanDate, @DueDate, 'Issued');

    -- Optionally mark the book as unavailable
    UPDATE Book
    SET IsAvailable = 0
    WHERE BookID = @BookID;
END;

-- 4. Procedure: PayFine
CREATE PROCEDURE sp_PayFine
    @LoanID INT,
    @Amount DECIMAL(10,2),
    @PaymentDate DATE,
    @Method VARCHAR(30)
AS
BEGIN
    INSERT INTO Payment (LoanID, PaymentDate, Amount, Method)
    VALUES (@LoanID, @PaymentDate, @Amount, @Method);
END;

-- 5. Procedure: AddReview
CREATE PROCEDURE sp_AddReview
    @MemberID INT,
    @BookID INT,
    @Rating INT,
    @Comment TEXT,
    @ReviewDate DATE
AS
BEGIN
    INSERT INTO Review (MemberID, BookID, Rating, Comment, ReviewDate)
    VALUES (@MemberID, @BookID, @Rating, @Comment, @ReviewDate);
END;


CREATE FUNCTION fn_GetLoanCountByMember
(
    @MemberID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @LoanCount INT;

    SELECT @LoanCount = COUNT(*)
    FROM Loan
    WHERE MemberID = @MemberID;

    RETURN @LoanCount;
END;

-- Returns the number of loans for member #3
SELECT dbo.fn_GetLoanCountByMember(3);

