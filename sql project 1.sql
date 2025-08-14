
CREATE DATABASE LibraryDB;
USE LibraryDB;

CREATE TABLE Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50)
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author_id INT,
    genre VARCHAR(50),
    publication_year INT,
    total_copies INT,
    available_copies INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);


CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    join_date DATE
);


CREATE TABLE BorrowingTransactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    member_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

INSERT INTO Authors (name, country) VALUES
('J.K. Rowling', 'UK'),
('George R.R. Martin', 'USA'),
('Agatha Christie', 'UK');

INSERT INTO Books (title, author_id, genre, publication_year, total_copies, available_copies) VALUES
('Harry Potter and the Philosopher''s Stone', 1, 'Fantasy', 1997, 5, 5),
('A Game of Thrones', 2, 'Fantasy', 1996, 3, 3),
('Murder on the Orient Express', 3, 'Mystery', 1934, 4, 4);

INSERT INTO Members (name, email, phone, join_date) VALUES
('Alice Johnson', 'alice@example.com', '9876543210', '2023-01-15'),
('Bob Smith', 'bob@example.com', '8765432109', '2023-03-10'),
('Charlie Brown', 'charlie@example.com', '7654321098', '2024-05-20');

INSERT INTO BorrowingTransactions (book_id, member_id, borrow_date, return_date) VALUES
(1, 1, '2025-07-08', '2025-07-11'),
(2, 2, '2025-07-09', NULL),
(3, 3, '2025-07-10', NULL);

SELECT b.book_id, b.title, b.available_copies
FROM Books b
ORDER BY b.title;

SELECT m.member_id, m.name, COUNT(bt.transaction_id) AS total_borrowed
FROM Members m
LEFT JOIN BorrowingTransactions bt ON m.member_id = bt.member_id
GROUP BY m.member_id, m.name
ORDER BY total_borrowed DESC;

SELECT bt.transaction_id, b.title, m.name AS member_name, bt.borrow_date, bt.return_date
FROM BorrowingTransactions bt
JOIN Books b ON bt.book_id = b.book_id
JOIN Members m ON bt.member_id = m.member_id
ORDER BY bt.borrow_date DESC;

SELECT b.title, m.name AS borrowed_by, bt.borrow_date
FROM BorrowingTransactions bt
JOIN Books b ON bt.book_id = b.book_id
JOIN Members m ON bt.member_id = m.member_id
WHERE bt.return_date IS NULL;

SELECT b.title, COUNT(bt.book_id) AS borrow_count
FROM BorrowingTransactions bt
JOIN Books b ON bt.book_id = b.book_id
GROUP BY b.title
ORDER BY borrow_count DESC;
