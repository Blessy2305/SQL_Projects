drop database if exists library;
create database library;
use library;

-- publishers

drop table if exists tbl_publisher;
CREATE TABLE tbl_publisher (
    publisher_publisherName VARCHAR(100) PRIMARY KEY,
    publisher_publisherAddress VARCHAR(100) NOT NULL,
    publisher_publisherPhone VARCHAR(100) NOT NULL
);

-- Books

drop table if exists tbl_book;
CREATE TABLE tbl_book (
    book_bookId INT NOT NULL AUTO_INCREMENT,
    book_title VARCHAR(100) NOT NULL,
    book_publisherName VARCHAR(100) NOT NULL,
    PRIMARY KEY (book_bookId),
    FOREIGN KEY (book_publisherName)
        REFERENCES tbl_publisher (publisher_publisherName)
        ON DELETE CASCADE
);

-- Authors

drop table if exists tbl_book_authors;
CREATE TABLE tbl_book_authors (
    book_authors_authorId INT NOT NULL AUTO_INCREMENT,
    book_authors_bookId INT NOT NULL,
    book_authors_authorname VARCHAR(100) NOT NULL,
    PRIMARY KEY (book_authors_authorId),
    FOREIGN KEY (book_authors_bookId)
        REFERENCES tbl_book (book_bookId)
        ON DELETE CASCADE
);

-- Library

drop table if exists tbl_librarybranch;
CREATE TABLE tbl_librarybranch (
    library_branch_branchId INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_branchName VARCHAR(100) NOT NULL,
    library_branch_branchAddress VARCHAR(100) NOT NULL
); 

-- Copies

drop table if exists tbl_book_copies;
CREATE TABLE tbl_book_copies (
    book_copies_copiesId INT NOT NULL AUTO_INCREMENT,
    book_copies_bookId INT NOT NULL,
    book_copies_branchId INT NOT NULL,
    book_copies_no_of_copies INT NOT NULL,
    PRIMARY KEY (book_copies_copiesId),
    FOREIGN KEY (book_copies_bookId)
        REFERENCES tbl_book (book_bookId),
    FOREIGN KEY (book_copies_branchId)
        REFERENCES tbl_librarybranch (library_branch_branchId)
        ON DELETE CASCADE
);

-- Borrower

drop table if exists tbl_borrower;
CREATE TABLE tbl_borrower (
    borrower_cardno INT PRIMARY KEY AUTO_INCREMENT,
    borrower_borrowerName VARCHAR(100) NOT NULL,
    borrower_borrowerAddress VARCHAR(100) NOT NULL,
    borrower_borrowerphone VARCHAR(100) NOT NULL
);

-- Loan

drop table if exists tbl_book_loans;
CREATE TABLE tbl_book_loans (
    book_loans_loansId INT AUTO_INCREMENT,
    book_loans_bookId INT NOT NULL,
    book_loans_branchId INT NOT NULL,
    book_loans_cardNo INT NOT NULL,
    book_loans_dateout DATE NOT NULL,
    book_loans_duedate DATE NOT NULL,
    PRIMARY KEY (book_loans_loansId),
    FOREIGN KEY (book_loans_bookId)
        REFERENCES tbl_book (book_bookId),
    FOREIGN KEY (book_loans_branchId)
        REFERENCES tbl_librarybranch (library_branch_branchId),
    FOREIGN KEY (book_loans_cardNo)
        REFERENCES tbl_borrower (borrower_cardNo)
        ON DELETE CASCADE
);


SELECT 
    *
FROM
    tbl_publisher;
SELECT 
    *
FROM
    tbl_book;
SELECT 
    *
FROM
    tbl_book_authors;
SELECT 
    *
FROM
    tbl_librarybranch;
SELECT 
    *
FROM
    tbl_book_copies;
SELECT 
    *
FROM
    tbl_borrower;
SELECT 
    *
FROM
    tbl_book_loans;



-- Task Questions

SELECT 
    *
FROM
    tbl_librarybranch;
SELECT 
    *
FROM
    tbl_book;
SELECT 
    *
FROM
    tbl_book_copies;
SELECT 
    c.book_copies_no_of_copies,
    b.book_title,
    l.library_branch_branchName
FROM
    tbl_book_copies AS c
        INNER JOIN
    tbl_librarybranch AS l ON l.library_branch_branchId = c.book_copies_branchId
        INNER JOIN
    tbl_book AS b ON b.book_bookId = c.book_copies_bookId
WHERE
    l.library_branch_branchName = 'sharpstown'
        AND b.book_title = 'The Lost Tribe';

-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT 
    c.book_copies_no_of_copies,
    b.book_title,
    l.library_branch_branchName
FROM
    tbl_book_copies AS c
        INNER JOIN
    tbl_librarybranch AS l ON l.library_branch_branchId = c.book_copies_branchId
        INNER JOIN
    tbl_book AS b ON b.book_bookId = c.book_copies_bookId
WHERE
    b.book_title = 'The Lost Tribe';

-- 3.Retrieve the names of all borrowers who do not have any books checked out.
SELECT 
    *
FROM
    tbl_borrower;
SELECT 
    b.borrower_borrowerName
FROM
    tbl_borrower AS b
WHERE
    borrower_cardno NOT IN (SELECT 
            l.book_loans_cardNo
        FROM
            tbl_book_loans AS l);

-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
SELECT 
    *
FROM
    tbl_librarybranch;
SELECT 
    *
FROM
    tbl_book_loans;
SELECT 
    d.book_title,
    b.borrower_borrowerName,
    b.borrower_borrowerAddress,
    l.book_loans_duedate,
    f.library_branch_branchName
FROM
    tbl_borrower b
        INNER JOIN
    tbl_book_loans l ON l.book_loans_cardNo = b.borrower_cardno
        INNER JOIN
    tbl_book d ON d.book_bookId = l.book_loans_bookId
        INNER JOIN
    tbl_librarybranch f ON l.book_loans_branchId = f.library_branch_branchId
WHERE
    f.library_branch_branchName = 'sharpstown'
        AND l.book_loans_duedate = '2018-02-03';
 
 -- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT 
    *
FROM
    tbl_librarybranch;
SELECT 
    *
FROM
    tbl_book_loans;
SELECT 
    l.library_branch_branchName, SUM(lo.book_loans_bookID)
FROM
    tbl_librarybranch AS l
        INNER JOIN
    tbl_book_loans AS lo ON l.library_branch_branchId = lo.book_loans_branchId
GROUP BY l.library_branch_branchName;
 
 
-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT 
    b.borrower_borrowerName,
    b.borrower_borrowerAddress,
    COUNT(l.book_loans_bookId) AS count
FROM
    tbl_borrower AS b
        INNER JOIN
    tbl_book_loans AS l ON b.borrower_cardno = l.book_loans_cardNo
        INNER JOIN
    tbl_book d ON d.book_bookId = l.book_loans_bookId
GROUP BY b.borrower_borrowerName , b.borrower_borrowerAddress
HAVING count > 5;

-- 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT 
    a.book_authors_authorname,
    c.book_copies_no_of_copies,
    l.library_branch_branchName,
    b.book_title
FROM
    tbl_book_authors AS a
        INNER JOIN
    tbl_book AS b ON a.book_authors_bookId = b.book_bookID
        INNER JOIN
    tbl_book_copies AS c ON b.book_bookID = c.book_copies_bookID
        INNER JOIN
    tbl_librarybranch AS l ON c.book_copies_branchId = l.library_branch_branchId
WHERE
    l.library_branch_branchName = 'Central'
        AND a.book_authors_authorname = 'Stephen King';
 
 
 