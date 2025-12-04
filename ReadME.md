# Library Management System (SQL Project)
## Project Overview

The Library Management System is a SQL-based project designed to manage book inventories, member details, and borrowing transactions.
It uses three key tables: Books, Members, and BorrowingRecords, and includes comprehensive queries for information retrieval, reporting, and analytics.

This project demonstrates strong SQL skills such as database creation, constraints, joins, grouping, CTEs, analytics, and data validation.

### Database Schema
1. Books Table
```
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
```

2. Members Table
```
create table Members (
					  Member_ID int generated always as identity primary key,
					  Name varchar(50) not null,
					  Email varchar(50) unique not null,
					  Phone_No bigint,
					  Address varchar(150),
					  Membership_Date date DEFAULT CURRENT_DATE
);

```

3. BorrowingRecords Table
```
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


```


The project includes:

Books

Members

Borrowing Records

These records simulate real-world borrowing patterns for meaningful reporting.

## Information Retrieval Queries

### a) Books currently borrowed by a specific member

```
select br.borrow_id, b.title, b.author, br.borrow_date
from BorrowingRecords br
join Books b on br.book_id = b.book_id
where br.member_id = 3 and br.return_date is null
order by borrow_date desc;
```

### b) Find members who have overdue books (borrowed more than 30 days ago, not returned).

```
select m.member_id, m.Name, br.borrow_date, (current_date - br.borrow_date) as No_of_days
from borrowingrecords br
join members m on br.member_id = m.member_id
where return_date is null and (current_date - br.borrow_date) > 30
order by no_of_days desc;
```


### c) Retrieve books by genre along with the count of available copies

### v1 retrieves the genre and with no. of books

```
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
```

### d) Find the most borrowed book(s) overall
/*-- Returns all books with the highest borrow count (tie supported) */
```
with borrow_stats as (
	select b.title, count(*) as Borrow_count
	from books b
	join borrowingrecords br on b.book_id = br.book_id
	group by b.title 
)

select * from borrow_stats
where Borrow_count = (select max(Borrow_count) from borrow_stats);
```

### e) Retrieve members who have borrowed books from at least three different genres.
```
select m.member_id, m.Name, count(*) as Borrow_count, 
		count(distinct b.genre) as Genres_Borrowed,
		string_agg(b.genre, ' | ' order by b.genre)
from borrowingrecords br
join members m on m.member_id = br.member_id
join books b on b.book_id = br.book_id
group by m.member_id
having count(distinct b.genre) >= 3
order by Genres_Borrowed desc;
```

## Reporting and Analytics:

### a) Calculate the total number of books borrowed per month.
```
select date_trunc('month', borrow_date)::date as Months_start,
		to_char(borrow_date, 'Mon YYYY') as Month_name,  count(*) as Borrow_count
from borrowingrecords
group by Months_start, Month_name
order by Months_start;
```

### b) Find the top three most active members based on the number of books borrowed.
```
select m.member_id, m.name, count(*) as Borrow_count
from members m
join borrowingrecords br on br.member_id = m.member_id
group by m.member_id, m.name
order by Borrow_count desc
limit 3;
```

### c) Retrieve authors whose books have been borrowed at least 10 times.
```
select b.author, count(*) as Borrow_count
from borrowingrecords br
join books b on br.book_id = b.book_id
group by b.author
having count(*) >= 10
order by Borrow_count desc, b.author;
```

### d) Identify members who have never borrowed a book.
```
select m.member_id, m.name
from members m
left join borrowingrecords br on br.member_id = m.member_id
where br.member_id is null
order by m.member_id;
```