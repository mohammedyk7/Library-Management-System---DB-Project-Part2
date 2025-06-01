
-- INDEXES FOR LIBRARY MANAGEMENT SYSTEM --

-- 1. Index on Library Name to speed up search by library name
CREATE NONCLUSTERED INDEX idx_Library_Name
ON Library(Name);
--Why? You’ll often search libraries by name in filters or dropdowns
--EXAMPLE USE : SELECT * FROM Library WHERE Name = 'Central Library';


-- 2. Index on Book Title for fast lookup
CREATE NONCLUSTERED INDEX idx_Book_Title
ON Book(Title);

-- 3. Composite index on Loan(BookID, LoanDate, ReturnDate)
CREATE NONCLUSTERED INDEX idx_Loan_Book_LoanDates
ON Loan(BookID, LoanDate, ReturnDate);

-- 4. Index on Member Email for quick login or lookup
CREATE NONCLUSTERED INDEX idx_Member_Email
ON Member(Email);
--EXAMPLE USE: SELECT * FROM Member WHERE Email = 'alice@example.com';


-- 5. Index on Payment Method for analytics
CREATE NONCLUSTERED INDEX idx_Payment_Method
ON Payment(Method);
-- Helps with analytics: how many payments were made by Cash, Credit, etc.

-- 6. Index on Review BookID to optimize book-based review lookup
CREATE NONCLUSTERED INDEX idx_Review_BookID
ON Review(BookID);
-- showing reviews per book or calculating ratings.

-- 7. Index on BookGenre Genre for genre statistics
CREATE NONCLUSTERED INDEX idx_BookGenre_Genre
ON BookGenre(Genre);
--Genre stats, like most common genres or filtering by genre

-- 8. Index on Staff Position for querying roles
CREATE NONCLUSTERED INDEX idx_Staff_Position
ON Staff(Position);
--Quickly find all librarians, archivists, assistants