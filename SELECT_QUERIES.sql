SELECT 
    L.LoanID,
    M.FullName AS MemberName,
    B.Title AS BookTitle,
    L.DueDate
FROM 
    Loan L
JOIN 
    Member M ON L.MemberID = M.MemberID
JOIN 
    Book B ON L.BookID = B.BookID
WHERE 
    (L.Status = 'Overdue' OR (L.ReturnDate IS NULL AND L.DueDate < GETDATE()));

--GET /books/unavailable 
	SELECT 
    BookID,
    Title,
    ISBN,
    Price,
    ShelfLocation,
    LibraryID
FROM 
    Book
WHERE 
    IsAvailable = 0;

	--GET /members/top-borrowers
	SELECT 
    M.MemberID,
    M.FullName,
    COUNT(*) AS TotalLoans
FROM 
    Loan L
JOIN 
    Member M ON L.MemberID = M.MemberID
GROUP BY 
    M.MemberID, M.FullName
HAVING 
    COUNT(*) > 2;
	--all members have exactly 2 loans

	--GET /libraries/:id/genres 
	SELECT 
    BookID,
    AVG(CAST(Rating AS FLOAT)) AS AverageRating
FROM 
    Review
GROUP BY 
    BookID;


-- GET /libraries/:id/genres
SELECT 
    BG.Genre,
    COUNT(*) AS GenreCount
FROM 
    BookGenre BG
JOIN 
    Book B ON BG.BookID = B.BookID
WHERE 
    B.LibraryID = 1  -- or use @LibraryID as a parameter
GROUP BY 
    BG.Genre;

	
	-- GET /members/inactive
SELECT 
    MemberID,
    FullName,
    Email,
    Phone
FROM 
    Member
WHERE 
    MemberID NOT IN (SELECT DISTINCT MemberID FROM Loan);

	-- GET /payments/summary
SELECT 
    M.MemberID,
    M.FullName,
    SUM(P.Amount) AS TotalFinesPaid
FROM 
    Payment P
JOIN 
    Loan L ON P.LoanID = L.LoanID
JOIN 
    Member M ON L.MemberID = M.MemberID
GROUP BY 
    M.MemberID, M.FullName;

	-- GET /reviews
SELECT 
    R.ReviewID,
    M.FullName AS MemberName,
    B.Title AS BookTitle,
    R.Rating,
    R.Comment,
    R.ReviewDate
FROM 
    Review R
JOIN 
    Member M ON R.MemberID = M.MemberID
JOIN 
    Book B ON R.BookID = B.BookID;

	-- GET /books/popular
SELECT TOP 3
    B.BookID,
    B.Title,
    COUNT(*) AS LoanCount
FROM 
    Loan L
JOIN 
    Book B ON L.BookID = B.BookID
GROUP BY 
    B.BookID, B.Title
ORDER BY 
    LoanCount DESC;

	-- GET /members/:id/history
SELECT 
    L.LoanID,
    B.Title AS BookTitle,
    L.LoanDate,
    L.DueDate,
    L.ReturnDate,
    L.Status
FROM 
    Loan L
JOIN 
    Book B ON L.BookID = B.BookID
WHERE 
    L.MemberID = 1;

	-- GET /books/rating-summary
SELECT 
    B.BookID,
    B.Title,
    COUNT(R.ReviewID) AS ReviewCount,
    AVG(CAST(R.Rating AS FLOAT)) AS AverageRating
FROM 
    Book B
LEFT JOIN 
    Review R ON B.BookID = R.BookID
GROUP BY 
    B.BookID, B.Title;

	 --Why LEFT JOIN?
--To include books with 0 reviews (shows NULL as avG)

-- GET /books/never-reviewed
SELECT 
    B.BookID,
    B.Title,
    B.ISBN,
    B.Price
FROM 
    Book B
WHERE 
    B.BookID NOT IN (SELECT DISTINCT BookID FROM Review);


	-- GET /staff/library-details
SELECT 
    S.StaffID,
    S.FullName AS StaffName,
    S.Position,
    L.Name AS LibraryName,
    L.Address
FROM 
    Staff S
JOIN 
    Library L ON S.LibraryID = L.LibraryID;


	-- GET /loans/unreturned
SELECT 
    L.LoanID,
    M.FullName AS MemberName,
    B.Title AS BookTitle,
    L.LoanDate,
    L.DueDate
FROM 
    Loan L
JOIN 
    Member M ON L.MemberID = M.MemberID
JOIN 
    Book B ON L.BookID = B.BookID
WHERE 
    L.ReturnDate IS NULL;


	-- GET /books/shelved-by-library
SELECT 
    L.LibraryID,
    L.Name AS LibraryName,
    COUNT(B.BookID) AS TotalBooks
FROM 
    Library L
LEFT JOIN 
    Book B ON L.LibraryID = B.LibraryID
GROUP BY 
    L.LibraryID, L.Name;


	-- GET /payments/by-method
SELECT 
    Method,
    COUNT(*) AS NumberOfPayments,
    SUM(Amount) AS TotalAmount
FROM 
    Payment
GROUP BY 
    Method;


	-- GET /genres/most-popular
SELECT 
    BG.Genre,
    COUNT(*) AS LoanCount
FROM 
    Loan L
JOIN 
    Book B ON L.BookID = B.BookID
JOIN 
    BookGenre BG ON B.BookID = BG.BookID
GROUP BY 
    BG.Genre
ORDER BY 
    LoanCount DESC;

	-- GET /loans/monthly-summary
SELECT 
    FORMAT(LoanDate, 'yyyy-MM') AS LoanMonth,
    COUNT(*) AS TotalLoans
FROM 
    Loan
GROUP BY 
    FORMAT(LoanDate, 'yyyy-MM')
ORDER BY 
    LoanMonth;

	-- GET /books/highest-rated
SELECT TOP 1
    B.BookID,
    B.Title,
    AVG(CAST(R.Rating AS FLOAT)) AS AverageRating
FROM 
    Review R
JOIN 
    Book B ON R.BookID = B.BookID
GROUP BY 
    B.BookID, B.Title
ORDER BY 
    AverageRating DESC;

	-- GET /members/with-fines
SELECT 
    M.MemberID,
    M.FullName,
    COUNT(P.PaymentID) AS NumberOfPayments,
    SUM(P.Amount) AS TotalPaid
FROM 
    Payment P
JOIN 
    Loan L ON P.LoanID = L.LoanID
JOIN 
    Member M ON L.MemberID = M.MemberID
GROUP BY 
    M.MemberID, M.FullName;

	--/books/available-count-by-library
	SELECT 
    L.LibraryID,
    L.Name AS LibraryName,
    COUNT(B.BookID) AS AvailableBooks
FROM 
    Library L
JOIN 
    Book B ON L.LibraryID = B.LibraryID
WHERE 
    B.IsAvailable = 1
GROUP BY 
    L.LibraryID, L.Name;

	--/members/with-loans-but-no-payments
	SELECT DISTINCT 
    M.MemberID,
    M.FullName
FROM 
    Member M
JOIN 
    Loan L ON M.MemberID = L.MemberID
WHERE 
    M.MemberID NOT IN (
        SELECT DISTINCT L2.MemberID
        FROM Payment P
        JOIN Loan L2 ON P.LoanID = L2.LoanID
    );

	--/members/with-overdue-loans
	SELECT DISTINCT 
    M.MemberID,
    M.FullName
FROM 
    Member M
JOIN 
    Loan L ON M.MemberID = L.MemberID
WHERE 
    L.Status = 'Overdue';
