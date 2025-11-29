--Database Creation
create database Library_Management_System;


--Verifying Database
select current_database();



--Creation of First Table  - Books
/* Year_Published stored as INT (year only)
   Valid range: 1300 to current year
   Available_Copies defaults to 0 and must be non-negative
   Book_ID auto-generated using identity
   Title + Author must be unique to avoid duplicate books
*/
create table Books (
					Book_ID int generated always as identity primary key , Title varchar(150) not null,
					Author varchar(150) not null, Genre varchar(20),
					Year_Published int 
							check (Year_Published between 1300 
									and extract (year from current_date)), 
					Available_Copies int default 0 check (Available_Copies >= 0),

					--Prevent adding same book twice
					unique(Title, Author)
);

--creation of Members Tables
/* 
   Member_ID is auto-increment identity
   Email must be unique
   Phone_No stored as BIGINT
   Membership_Date defaults to today's date
*/
create table Members (
					  Member_ID int generated always as identity primary key,
					  Name varchar(50) not null,
					  Email varchar(50) unique not null,
					  Phone_No bigint,
					  Address varchar(150),
					  Membership_Date date DEFAULT CURRENT_DATE
);



--Creation of BorrowingRecords table

/*
   Borrow_ID auto-increment
   Member_ID references Members table
   Book_ID references Books table
   Borrow_Date default is current day
   Return_Date must be >= Borrow_Date (logical check)

*/
create table BorrowingRecords (
								Borrow_ID int generated always as identity primary key,
								Member_ID int not null,
								Book_ID int not null,
								Borrow_Date date default current_date,
								Return_Date date,

								-- Foreign Keys
								foreign key (Member_ID) references Members(Member_ID),
								foreign key (Book_ID) references Books(Book_ID)
);






--return date cannot be before borrow date
alter table BorrowingRecords 
add constraint chk_return_date
check (Return_Date is null or Return_Date >= Borrow_Date);



-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------


--Data entries for Books Table

insert into Books (Title, Author, Genre, Year_Published, Available_Copies)
values
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 5),
('1984', 'George Orwell', 'Dystopian', 1949, 3),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925, 4),
('Moby Dick', 'Herman Melville', 'Adventure', 1851, 2),
('Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 6),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 8),
('A Brief History of Time', 'Stephen Hawking', 'Science', 1988, 4),
('The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 1951, 3),
('The Alchemist', 'Paulo Coelho', 'Philosophy', 1988, 7),
('The Lord of the Rings', 'J.R.R. Tolkien', 'Fantasy', 1954, 5),
('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 'Fantasy', 1997, 10),
('The Da Vinci Code', 'Dan Brown', 'Thriller', 2003, 6),
('The Hunger Games', 'Suzanne Collins', 'Dystopian', 2008, 9),
('The Fault in Our Stars', 'John Green', 'Romance', 2012, 4),
('Sapiens', 'Yuval Noah Harari', 'History', 2011, 6),
('The Shining', 'Stephen King', 'Horror', 1977, 5),
('The Girl on the Train', 'Paula Hawkins', 'Thriller', 2015, 0),
('The Kite Runner', 'Khaled Hosseini', 'Drama', 2003, 8),
('Atomic Habits', 'James Clear', 'Self-Help', 2018, 12),
('Rich Dad Poor Dad', 'Robert Kiyosaki', 'Finance', 1997, 10);


select * from Books;


--Data entries for Members Table

insert into Members (Name, Email, Phone_No, Address, Membership_Date)
values
('Rahul Sharma', 'rahul.sharma1@example.com', 9876543210, 'Delhi', '2024-03-01'),
('Anjali Verma', 'anjali.verma@example.com', 9123456780, 'Mumbai', '2024-04-10'),
('John Mathew', 'john.mathew@example.com', 9988776655, 'Bangalore', '2024-02-20'),
('Priya Singh', 'priya.singh@example.com', 9345678901, 'Chennai', '2024-01-15'),
('David Kumar', 'david.kumar@example.com', 9001122334, 'Hyderabad', '2024-05-05'),
('Sneha Joshi', 'sneha.joshi@example.com', 9123345678, 'Pune', '2025-06-10'),
('Aman Gupta', 'aman.gupta@example.com', 9876501234, 'Delhi', '2025-07-12'),
('Kavya Rao', 'kavya.rao@example.com', 9345609873, 'Mysore', '2025-03-22'),
('Saurabh Das', 'saurabh.das@example.com', 9001400200, 'Kolkata', '2025-01-30'),
('Lakshmi Nair', 'lakshmi.nair@example.com', 9123001100, 'Kerala', '2025-02-14'),
('Vikram Patel', 'vikram.patel@example.com', 9356789023, 'Ahmedabad', '2025-03-10'),
('Meera Iyer', 'meera.iyer@example.com', 9887654321, 'Chennai', '2025-05-01'),
('Rohit Jain', 'rohit.jain@example.com', 9786501234, 'Jaipur', '2025-04-12'),
('Aishwarya Reddy', 'aishwarya.r@example.com', 9234509876, 'Hyderabad', '2025-02-19'),
('Nikhil Bansal', 'nikhil.bansal@example.com', 9345098765, 'Delhi', '2025-06-15'),
('Shruti Mehta', 'shruti.mehta@example.com', 9234001122, 'Surat', '2025-03-05'),
('Tarun Khanna', 'tarun.khanna@example.com', 9356700090, 'Delhi', '2025-04-20'),
('Sonali Pillai', 'sonali.pillai@example.com', 9245678012, 'Mumbai', '2025-07-01'),
('Arjun Malhotra', 'arjun.malhotra@example.com', 9988007766, 'Delhi', '2025-06-10'),
('Neha Kapoor', 'neha.kapoor@example.com', 9345601234, 'Bhopal', default);


--extra member not borrowed - new entry
insert into members (Name, Email, Phone_No, Address, Membership_Date) values
('Vignesh Kumar', 'vignesh.kumar@example.com', 9345641234, 'Chennai', '2025-04-10'),
('Arun Kumar', 'arun.kumar@example.com', 9375641234, 'Bangalore', '2025-04-10'),
('Pavithra Kumari', 'pavithra.kumari@example.com', 9345121234, 'Chennai', '2025-04-10');



select * from Members;


--Data entries for BorrowingRecords Table

insert into BorrowingRecords (Member_ID, Book_ID, Borrow_Date, Return_Date)
values
(1, 1,  '2025-08-10', NULL),
(1, 6,  '2025-10-20', '2025-11-28'),
(1, 7,  '2025-09-10', '2025-10-25'),
(2, 2,  '2025-09-01', NULL),
(2, 13, '2025-10-10', '2025-10-20'),
(3, 3,  '2025-11-05', NULL),
(3, 10, '2025-07-01', NULL),
(3, 15, '2025-08-15', '2025-09-05'),
(4, 4,  '2025-08-01', NULL),
(4, 16, '2025-11-10', '2025-11-25'),
(5, 5,  '2025-11-15', NULL),
(5, 20, '2025-09-20', '2025-10-02'),
(6, 10, '2025-11-10', NULL),
(7, 10, '2025-10-12', '2025-10-25'),
(8, 10, '2025-09-14', '2025-09-28'),
(9, 12, '2025-10-18', NULL),
(10, 8, '2025-11-25', NULL),
(11, 19, '2025-11-01', NULL),
(12, 11, '2025-10-22', '2025-11-10'),
(13, 18, '2025-09-01', NULL);

--additional inserts
insert into BorrowingRecords (Member_ID, Book_ID, Borrow_Date, Return_Date)
values (14, 10, '2025-10-01', NULL),
(15, 10, '2025-09-22', '2025-10-03'),
(16, 10, '2025-08-15', NULL),
(17, 10, '2025-11-02', '2025-11-18'),
(18, 6,  '2025-10-05', NULL),
(19, 6,  '2025-11-12', NULL),
(20, 6,  '2025-07-14', '2025-08-01'),
(3, 2,  '2025-07-20', NULL),
(5, 2,  '2025-08-18', '2025-09-02'),
(8, 2,  '2025-10-21', NULL),
(10, 2, '2025-09-10', NULL),
(12, 2, '2025-11-20', NULL),
(14, 5, '2025-10-12', NULL),
(16, 5, '2025-08-02', NULL),
(7, 1, '2025-09-05', NULL),
(9, 1, '2025-11-10', NULL),
(12, 1, '2025-08-25', '2025-09-05');


select * from BorrowingRecords;

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------


--##################################################
--Information Retrieval:
--##################################################


-- a) Retrieve a list of books currently borrowed by a specific member.


select br.borrow_id, b.title, b.author, br.borrow_date
from BorrowingRecords br
join Books b on br.book_id = b.book_id
where br.member_id = 3 and br.return_date is null
order by borrow_date desc;


-- b) Find members who have overdue books (borrowed more than 30 days ago, not returned).


select m.member_id, m.Name, br.borrow_date, (current_date - br.borrow_date) as No_of_days
from borrowingrecords br
join members m on br.member_id = m.member_id
where return_date is null and (current_date - br.borrow_date) > 30
order by no_of_days desc;


--Retrieve books by genre along with the count of available copies

--v1 retrieves the genre and with no. of books

select genre, count(*) as No_of_Books, sum(available_copies) as Total_copies
from books 
group by genre
order by Total_copies desc, genre;

--v2 one row per genre with book genre list and total available copies
select genre, count(*) as total_books_in_genre,
    sum(available_copies) as Total_copies,
    STRING_AGG(Title, ' | ' order by Title) as book_titles
from Books 
group by genre
order by Total_copies desc, genre;


--Find the most borrowed book(s) overall
/*-- Returns all books with the highest borrow count (tie supported) */

with borrow_stats as (
	select b.title, count(*) as Borrow_count
	from books b
	join borrowingrecords br on b.book_id = br.book_id
	group by b.title 
)

select * from borrow_stats
where Borrow_count = (select max(Borrow_count) from borrow_stats);


--Retrieve members who have borrowed books from at least three different genres.

select m.member_id, m.Name, count(*) as Borrow_count, 
		count(distinct b.genre) as Genres_Borrowed,
		string_agg(b.genre, ' | ' order by b.genre)
from borrowingrecords br
join members m on m.member_id = br.member_id
join books b on b.book_id = br.book_id
group by m.member_id
having count(distinct b.genre) >= 3
order by Genres_Borrowed desc;


--##################################################
--Reporting and Analytics:
--##################################################

--Calculate the total number of books borrowed per month.

select date_trunc('month', borrow_date)::date as Months_start,
		to_char(borrow_date, 'Mon YYYY') as Month_name,  count(*) as Borrow_count
from borrowingrecords
group by Months_start, Month_name
order by Months_start;

--Find the top three most active members based on the number of books borrowed.

select m.member_id, m.name, count(*) as Borrow_count
from members m
join borrowingrecords br on br.member_id = m.member_id
group by m.member_id, m.name
order by Borrow_count desc
limit 3;

--Retrieve authors whose books have been borrowed at least 10 times.

select b.author, count(*) as Borrow_count
from borrowingrecords br
join books b on br.book_id = b.book_id
group by b.author
having count(*) >= 10
order by Borrow_count desc, b.author;

--Identify members who have never borrowed a book.

select m.member_id, m.name
from members m
left join borrowingrecords br on br.member_id = m.member_id
where br.member_id is null;













