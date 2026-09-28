# SQL Server – Relational Database & Query Practice

A hands-on SQL Server project focused on **relational database design, data integrity, SQL querying, and business-oriented data analysis**.
This project is based on two database scenarios: **Sales Management** and **Academic Management**, with exercises covering database definition, data manipulation, business constraints, and complex SQL queries.

## 🎯 Project Objectives

* Practice designing relational databases from business requirements.
* Implement primary keys, foreign keys, constraints, and data validation rules.
* Strengthen SQL querying skills from basic retrieval to complex analytical queries.
* Practice transforming business questions into SQL queries.
* Build a foundation for database validation and data-oriented software testing.

## 🗂️ Database 1 – Sales Management

The Sales Management database models a simple retail business with:

* `KHACHHANG` – Customers
* `NHANVIEN` – Employees
* `SANPHAM` – Products
* `HOADON` – Invoices
* `CTHD` – Invoice Details

The database includes relationships between customers, employees, invoices, and products.

### SQL topics

* Database and table creation
* Primary Keys and Foreign Keys
* `CHECK`, `DEFAULT`, and business constraints
* Data insertion and updates
* Multi-table `JOIN`
* Filtering and sorting
* Aggregation and grouping
* Subqueries
* `EXISTS` / `NOT EXISTS`
* Top-N queries
* Revenue analysis
* Product and customer analysis

The exercise set includes 45 query problems, ranging from product filtering and invoice analysis to revenue, customer ranking, product sales analysis, and cross-condition queries.

## 🎓 Database 2 – Academic Management

The Academic Management database models a university academic system:

* `HOCVIEN` – Students
* `LOP` – Classes
* `KHOA` – Departments
* `MONHOC` – Subjects
* `DIEUKIEN` – Prerequisite Subjects
* `GIAOVIEN` – Lecturers
* `GIANGDAY` – Teaching Assignments
* `KETQUATHI` – Exam Results

These entities represent relationships between students, classes, departments, subjects, lecturers, teaching assignments, prerequisites, and exam results.

### Advanced SQL Practice

The project covers:

* Complex relational queries
* Self-referencing relationships
* Prerequisite subject analysis
* Latest exam attempt analysis
* Student performance analysis
* Lecturer workload analysis
* Aggregation by department / semester / academic year
* Ranking and highest/lowest value queries
* `EXISTS` / `NOT EXISTS`
* Nested subqueries
* Conditional logic

The exercise set contains 35 query problems, including latest-attempt analysis, lecturer assignments, student performance, subject results, and highest-score analysis.

## 🧩 Database Skills Demonstrated

| Area            | Skills                            |
| --------------- | --------------------------------- |
| Database Design | Relational modeling, PK, FK       |
| Data Integrity  | CHECK constraints, business rules |
| DDL             | CREATE, ALTER, DROP               |
| DML             | INSERT, UPDATE                    |
| Querying        | SELECT, JOIN, GROUP BY, HAVING    |
| Advanced SQL    | Subqueries, EXISTS, NOT EXISTS    |
| Analysis        | Aggregation, ranking, Top-N       |
| Data Validation | Business-rule validation          |
| SQL Server      | T-SQL practice                    |

## 📁 Project Structure

```text
SQL-Server-Database-Practice/
│
├── README.md
│
├── docs/
│   ├── erd/
│   │   ├── sales-management-erd.png
│   │   └── academic-management-erd.png
│   │
│   └── screenshots/
│       ├── sales-query-results/
│       └── academic-query-results/
│
├── sales-management/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_constraints.sql
│   ├── 04_insert_data.sql
│   ├── 05_update_data.sql
│   └── queries/
│       ├── 01_basic_queries.sql
│       ├── 02_join_queries.sql
│       ├── 03_aggregation.sql
│       ├── 04_subqueries.sql
│       └── 05_advanced_queries.sql
│
├── academic-management/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_constraints.sql
│   ├── 04_insert_data.sql
│   ├── 05_update_data.sql
│   └── queries/
│       ├── 01_basic_queries.sql
│       ├── 02_join_queries.sql
│       ├── 03_aggregation.sql
│       ├── 04_subqueries.sql
│       └── 05_advanced_queries.sql
│
└── .gitignore
```

## 🚀 Key Takeaways

This project helped strengthen my understanding of relational database design and SQL Server querying, while improving my ability to translate business requirements into SQL logic and validate data relationships.

**Tech Stack:** SQL Server · T-SQL · SSMS
