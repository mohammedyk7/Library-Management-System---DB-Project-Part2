
-- VIEWS FOR LIBRARY MANAGEMENT SYSTEM --

-- 1. View: PopularBooks - top 5 most borrowed books
CREATE VIEW ViewPopularBooks AS
SELECT TOP 5
    B.BookID,
    B.Title,
    COUNT(L.LoanID) AS TotalLoans
FROM 
    Loan L
JOIN 
    Book B ON L.BookID = B.BookID
GROUP BY 
    B.BookID, B.Title
ORDER BY 
    TotalLoans DESC;
	--this will help view my best-seller books ..

-- 2. View: CurrentLoans - list of books currently on loan
CREATE VIEW ViewCurrentLoans AS
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
	
	
	--Helps librarians follow up on due items or manage availability

-- 3. View: BookRatingsSummary - average rating and total reviews per book
CREATE VIEW ViewBookRatingsSummary AS
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

	-- Useful for readers to assess popularity

-- 4. View: MemberFinesSummary - total fines paid by each member
CREATE VIEW ViewMemberFinesSummary AS
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

	--Great for billing, refunds, or tracking payment history

-- 5. View: GenreLoanCount - number of loans per genre
CREATE VIEW ViewGenreLoanCount AS
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
    BG.Genre;
