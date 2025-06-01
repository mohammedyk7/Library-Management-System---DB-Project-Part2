
-- FUNCTIONS FOR LIBRARY MANAGEMENT SYSTEM --
--Functions: calculate averages, get member stats, return book lists--

-- 1. Function: GetTopRatedBooks (table-valued)
CREATE FUNCTION fn_GetTopRatedBooks()
RETURNS TABLE
AS
RETURN (
    SELECT 
        B.BookID,
        B.Title,
        AVG(CAST(R.Rating AS FLOAT)) AS AverageRating
    FROM 
        Review R
    JOIN 
        Book B ON R.BookID = B.BookID
    GROUP BY 
        B.BookID, B.Title
    HAVING 
        COUNT(R.ReviewID) >= 2
);

-- 2. Function: GetOutstandingFines (scalar)
CREATE FUNCTION fn_GetOutstandingFines(@MemberID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalPaid DECIMAL(10,2)
    SELECT @TotalPaid = ISNULL(SUM(P.Amount), 0)
    FROM Payment P
    JOIN Loan L ON P.LoanID = L.LoanID
    WHERE L.MemberID = @MemberID;

    RETURN @TotalPaid;
END;
--returns only a single value ..
 --Frontend Use:
--Member Profile page:
--"You’ve paid: 2 rials in fines"

-- 3. Function: CountBooksInGenre (scalar)
CREATE FUNCTION fn_CountBooksInGenre(@Genre VARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;
    SELECT @Count = COUNT(*) 
    FROM BookGenre
    WHERE Genre = @Genre;
    RETURN @Count;
END;
--frontend Use:
--Genre filters: “(Fiction: 32)”

-- 4. Function: GetMemberLoanCount (scalar)
CREATE FUNCTION fn_GetMemberLoanCount(@MemberID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalLoans INT;
    SELECT @TotalLoans = COUNT(*) FROM Loan WHERE MemberID = @MemberID;
    RETURN @TotalLoans;
END;

--Counts how many books a member has borrowed
--Frontend Use:
--Member profile: “Total books borrowed: 7”

CREATE FUNCTION GetBookAverageRating(@BookID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @AvgRating FLOAT;
    SELECT @AvgRating = AVG(CAST(Rating AS FLOAT))
    FROM Review
    WHERE BookID = @BookID;
    RETURN @AvgRating;
END;


CREATE FUNCTION GetNextAvailableBook(@Genre VARCHAR(50), @Title VARCHAR(150), @LibraryID INT)
RETURNS INT
AS
BEGIN
    DECLARE @BookID INT;
    SELECT TOP 1 @BookID = B.BookID
    FROM Book B
    JOIN BookGenre BG ON B.BookID = BG.BookID
    WHERE BG.Genre = @Genre AND B.Title = @Title AND B.LibraryID = @LibraryID AND B.IsAvailable = 1;
    RETURN @BookID;
END;


-- Function: CalculateLibraryOccupancyRate(LibraryID)
CREATE FUNCTION CalculateLibraryOccupancyRate(@LibraryID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TotalBooks INT, @IssuedBooks INT;

    SELECT @TotalBooks = COUNT(*) FROM Book WHERE LibraryID = @LibraryID;
    SELECT @IssuedBooks = COUNT(*) FROM Book WHERE LibraryID = @LibraryID AND IsAvailable = 0;

    RETURN CASE 
        WHEN @TotalBooks = 0 THEN 0 
        ELSE CAST(@IssuedBooks AS FLOAT) / @TotalBooks 
    END;
END;

-- Function: fn_GetLateReturnDays(LoanID)
CREATE FUNCTION fn_GetLateReturnDays(@LoanID INT)
RETURNS INT
AS
BEGIN
    DECLARE @LateDays INT;
    SELECT @LateDays = 
        CASE 
            WHEN ReturnDate IS NULL THEN 0
            WHEN DATEDIFF(DAY, DueDate, ReturnDate) < 0 THEN 0
            ELSE DATEDIFF(DAY, DueDate, ReturnDate)
        END
    FROM Loan
    WHERE LoanID = @LoanID;
    RETURN @LateDays;
END;

-- Function: fn_ListAvailableBooksByLibrary(LibraryID)
CREATE FUNCTION fn_ListAvailableBooksByLibrary(@LibraryID INT)
RETURNS TABLE
AS
RETURN (
    SELECT BookID, Title, ShelfLocation
    FROM Book
    WHERE LibraryID = @LibraryID AND IsAvailable = 1
);

-- Function: fn_FormatMemberName(MemberID)
CREATE FUNCTION fn_FormatMemberName(@MemberID INT)
RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @FormattedName VARCHAR(200);
    SELECT @FormattedName = CONCAT(PARSENAME(REPLACE(FullName, ' ', '.'), 1), ', ', PARSENAME(REPLACE(FullName, ' ', '.'), 2))
    FROM Member
    WHERE MemberID = @MemberID;
    RETURN @FormattedName;
END;


