# Home Insurance SQL Database Project

## Overview

This project focuses on designing, creating, and querying a relational database for a home insurance dataset.

The goal is to structure two source files, `Contrat.csv` and `Region.csv`, into a relational database using MySQL. The project includes database modeling, table creation, data import, integrity checks, and SQL analysis queries.

## Project Objectives

The main objectives of this project are to:

* Analyze the structure of the source datasets.
* Define an appropriate relational database schema.
* Create a MySQL database with primary and foreign key constraints.
* Import CSV data into the database.
* Verify data integrity after import.
* Write SQL queries to answer business questions.
* Produce a relational schema and screenshots of query results.

## Technologies Used

* MySQL
* MySQL Workbench
* SQL
* Visual Studio Code
* Git / GitHub

## Database Model

The database is based on two main tables:

### `region`

The `region` table contains geographic information such as region name, department name, commune name, and geographic codes.

Primary key:

```sql
Code_dep_code_commune
```

### `contrat`

The `contrat` table contains home insurance contract information such as contract ID, address, surface, housing type, occupation status, contract type, insurance formula, declared goods value, and monthly insurance price.

Primary key:

```sql
Contrat_ID
```

Foreign key:

```sql
Code_dep_code_commune
```

This foreign key links each contract to its geographic information in the `region` table.

## SQL Files

### `01_creation_bdd.sql`

This file creates the MySQL database and the two relational tables:

* `region`
* `contrat`

It also defines the primary key and foreign key constraints.

### `02_verifications_import.sql`

This file contains verification queries used after importing the CSV files into MySQL Workbench.

It checks:

* the number of rows imported into each table;
* the presence of unmatched contracts without a related region;
* the integrity of the relationship between the two tables.

### `03_requetes_analyses.sql`

This file contains the SQL analysis queries required for the project.

The queries cover:

* filtering contracts by postal code;
* listing regions;
* counting main residence contracts;
* identifying the largest housing surfaces;
* calculating average monthly insurance prices;
* grouping contracts by declared goods value;
* analyzing contracts by region, department, commune, housing type, and occupation status.

Additional bonus queries were added to provide further analysis beyond the required minimum.

## Data Import Process

The CSV files were imported using MySQL Workbench.

Import order:

1. `Region.csv` into the `region` table.
2. Manual insertion of three missing geographic codes related to La Réunion.
3. `Contrat.csv` into the `contrat` table.

After import, the final row counts were verified:

```text
region  : 38,919 rows
contrat : 30,335 rows
```

## Relational Integrity

The relationship between `contrat` and `region` was verified using a `LEFT JOIN` query.

The result confirmed that all contracts have a matching geographic entry in the `region` table.

```text
Contracts without region: 0
```

## Example Query

```sql
SELECT
    Contrat_ID,
    Surface
FROM contrat
WHERE Code_postal = '92100'
ORDER BY Contrat_ID;
```

This query lists contract IDs and housing surfaces for contracts located in postal code `92100`.

## Screenshots

The `screenshots/` folder contains screenshots of the SQL queries executed in MySQL Workbench.

Each screenshot shows:

* the SQL query;
* the result grid returned by MySQL Workbench.

These screenshots are used as evidence of the executed queries and their results.

## Author

Stephane-OC : Project completed as part of a data analysis training path.

---

## Notes

This project demonstrates the ability to design a relational database, create tables with SQL, import data, verify data integrity, and write SQL queries to answer business questions from structured data.