
-- ADVANCED AGGREGATION QUERIES FOR LIBRARY MANAGEMENT SYSTEM --

-- 1. Members who borrowed books but paid no fines
SELECT 
    M.MemberID,
    M.FullName
FROM 
    Member M
JOIN 
    Loan L ON M.MemberID = L.MemberID
WHERE 
    M.MemberID NOT IN (
        SELECT DISTINCT L2.MemberID
        FROM Loan L2
        JOIN Payment P ON L2.LoanID = P.LoanID
    );

-- 2. Genres with high average ratings (above 4.5)
SELECT 
    BG.Genre,
    AVG(CAST(R.Rating AS FLOAT)) AS AvgRating
FROM 
    Review R
JOIN 
    Book B ON R.BookID = B.BookID
JOIN 
    BookGenre BG ON B.BookID = BG.BookID
GROUP BY 
    BG.Genre
HAVING 
    AVG(CAST(R.Rating AS FLOAT)) > 4.5;

-- 3. Most expensive book per genre
SELECT 
    BG.Genre,
    B.Title,
    B.Price
FROM 
    Book B
JOIN 
    BookGenre BG ON B.BookID = BG.BookID
WHERE 
    B.Price = (
        SELECT MAX(B2.Price)
        FROM Book B2
        JOIN BookGenre BG2 ON B2.BookID = BG2.BookID
        WHERE BG2.Genre = BG.Genre
    );

-- 4. Library occupancy rate (percentage of books loaned out)
SELECT 
    L.LibraryID,
    L.Name,
    CAST(COUNT(CASE WHEN B.IsAvailable = 0 THEN 1 END) AS FLOAT) /
    COUNT(*) AS OccupancyRate
FROM 
    Library L
JOIN 
    Book B ON L.LibraryID = B.LibraryID
GROUP BY 
    L.LibraryID, L.Name;

-- 5. Members who borrowed books from multiple genres
SELECT 
    M.MemberID,
    M.FullName,
    COUNT(DISTINCT BG.Genre) AS GenresBorrowed
FROM 
    Member M
JOIN 
    Loan L ON M.MemberID = L.MemberID
JOIN 
    BookGenre BG ON L.BookID = BG.BookID
GROUP BY 
    M.MemberID, M.FullName
HAVING 
    COUNT(DISTINCT BG.Genre) > 1;
