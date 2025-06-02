
-- AGGREGATION QUERIES FOR LIBRARY MANAGEMENT SYSTEM --

-- 1. Total fines per member
SELECT 
    M.MemberID,
    M.FullName,
    SUM(P.Amount) AS TotalFines
FROM 
    Member M
JOIN 
    Loan L ON M.MemberID = L.MemberID
JOIN 
    Payment P ON L.LoanID = P.LoanID
GROUP BY 
    M.MemberID, M.FullName;

-- 2. Most active libraries (by loan count)
SELECT 
    L.LibraryID,
    L.Name AS LibraryName,
    COUNT(*) AS TotalLoans
FROM 
    Loan LN
JOIN 
    Book B ON LN.BookID = B.BookID
JOIN 
    Library L ON B.LibraryID = L.LibraryID
GROUP BY 
    L.LibraryID, L.Name
ORDER BY 
    TotalLoans DESC;

-- 3. Average book price per genre
SELECT 
    BG.Genre,
    AVG(B.Price) AS AvgPrice
FROM 
    Book B
JOIN 
    BookGenre BG ON B.BookID = BG.BookID
GROUP BY 
    BG.Genre;

-- 4. Top 3 most reviewed books
SELECT TOP 3 
    B.BookID,
    B.Title,
    COUNT(R.ReviewID) AS ReviewCount
FROM 
    Review R
JOIN 
    Book B ON R.BookID = B.BookID
GROUP BY 
    B.BookID, B.Title
ORDER BY 
    ReviewCount DESC;

-- 5. Library revenue report
SELECT 
    L.LibraryID,
    L.Name,
    SUM(P.Amount) AS TotalRevenue
FROM 
    Library L
JOIN 
    Book B ON L.LibraryID = B.LibraryID
JOIN 
    Loan LN ON B.BookID = LN.BookID
JOIN 
    Payment P ON LN.LoanID = P.LoanID
GROUP BY 
    L.LibraryID, L.Name;

-- 6. Member activity summary (loans + fines)
SELECT 
    M.MemberID,
    M.FullName,
    COUNT(DISTINCT L.LoanID) AS TotalLoans,
    SUM(P.Amount) AS TotalFines
FROM 
    Member M
LEFT JOIN 
    Loan L ON M.MemberID = L.MemberID
LEFT JOIN 
    Payment P ON L.LoanID = P.LoanID
GROUP BY 
    M.MemberID, M.FullName;
