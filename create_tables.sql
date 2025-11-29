create database Library_Management_System;

select current_database();

create table Books (
					Book_ID int, Title varchar(50),
					Author varchar(50), Genre varchar(20),
					Year_Published DATE, Available_Copies  
					
);