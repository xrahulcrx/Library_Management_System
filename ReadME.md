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

```
🧱 Key Features

✔️ Prevents duplicate books using UNIQUE(Title, Author)
✔️ Ensures logical dates (Return_Date >= Borrow_Date)
✔️ Strong referential integrity with foreign keys
✔️ Realistic sample data for all three tables
✔️ Advanced SQL queries for analytics and reporting

📥 Sample Data

The project includes:

20 Books

23 Members

30+ Borrowing Records

These records simulate real-world borrowing patterns for meaningful reporting.

🔍 Information Retrieval Queries
a) Books currently borrowed by a specific member

Retrieves ongoing (not returned) loans.

b) Members with overdue books (>30 days, not returned)

Identifies all overdue borrowers using date arithmetic.

c) Books by genre & available copy counts

Two versions:

Summary count

Detailed book list per genre (using STRING_AGG)

d) Most borrowed book(s)

Uses a CTE to compute borrow statistics and returns all top titles even if tied.

e) Members who borrowed from at least 3 genres

Uses COUNT(DISTINCT genre) to detect diverse reading habits.

📊 Reporting & Analytics Queries
a) Total books borrowed per month

Grouped by date_trunc('month', ...).

b) Top 3 most active members

Based on number of books borrowed.

c) Authors with ≥ 10 borrows

Shows most popular authors.

d) Members who have never borrowed a book

Left join to identify inactive members.