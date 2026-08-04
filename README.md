<p align="center">
  <img src="assets/img/logo.png" alt="Home Insurance SQL project logo" width="320">
</p>

<h1 align="center">Home Insurance SQL Database Project</h1>

<p align="center">
  Relational database design, geographic data normalization,<br>
  integrity validation, and SQL analysis for a home insurance dataset
</p>

<p align="center">
  <img src="https://img.shields.io/badge/MySQL-Database-4479A1?logo=mysql&logoColor=white" alt="MySQL Database">
  <img src="https://img.shields.io/badge/MySQL%20Workbench-SQL-4479A1?logo=mysql&logoColor=white" alt="MySQL Workbench">
  <img src="https://img.shields.io/badge/Model-Relational-7C3AED" alt="Relational model">
  <img src="https://img.shields.io/badge/Integrity-PK%20%2F%20FK-059669" alt="Primary and foreign key integrity">
</p>

---

## Overview

This project focuses on designing, creating, populating, normalizing, validating, and querying a relational database for a **home insurance dataset**.

Its purpose is to transform two source files, `Contrat.csv` and `Region.csv`, into a structured MySQL database that connects insurance contracts to a geographic reference system.

The project covers the complete database workflow:

- source-data analysis;
- relational database modeling;
- table creation with primary and foreign key constraints;
- CSV data import through MySQL Workbench;
- correction of geographic labels affected by character-encoding issues;
- insertion of missing geographic references;
- row-count and referential-integrity validation;
- SQL analyses answering business questions;
- screenshots documenting each query and its result.

## Objectives

- Analyze the structure and purpose of the source data.
- Build a clear and consistent relational database.
- Preserve geographic and postal codes in the correct format.
- Enforce entity integrity through primary keys.
- Enforce referential integrity between contracts and geographic data.
- Correct corrupted French characters introduced during CSV import.
- Add missing geographic references required by the contract data.
- Validate imported row counts and detect possible orphan records.
- Use SQL to answer insurance-related business questions.
- Document the database model, implementation process, and analysis results.

## Source Data

| File | Content | Destination table |
|---|---|---|
| `Region.csv` | Regions, academies, departments, communes, and geographic codes | `region` |
| `Contrat.csv` | Addresses, housing characteristics, insurance formulas, declared property values, and monthly premiums | `contrat` |

The `region` table acts as the geographic reference table. Despite its name, it contains information at several geographic levels: **region, academy, department, and commune**.

## Data Workflow

```mermaid
flowchart LR
    A[Create database] --> B[Import Region.csv]
    B --> C[Normalize encoding and add missing references]
    C --> D[Import Contrat.csv]
    D --> E[Validate row counts and relationships]
    E --> F[Run SQL analyses]
    F --> G[Document results with screenshots]
```

## Final Relational Model

The final model contains two tables linked through the shared geographic identifier `Code_dep_code_commune`.

```mermaid
erDiagram
    REGION ||--o{ CONTRAT : "locates"

    REGION {
        string Code_dep_code_commune PK
        string reg_code
        string reg_nom
        string aca_nom
        string dep_nom
        string com_nom_maj_court
        string dep_code
        string dep_nom_num
    }

    CONTRAT {
        int Contrat_ID PK
        string No_voie
        string B_T_Q
        string Type_de_voie
        string Voie
        string Code_dep_code_commune FK
        string Code_postal
        int Surface
        string Type_local
        string Occupation
        string Type_contrat
        string Formule
        string Valeur_declaree_biens
        decimal Prix_cotisation_mensuel
    }
```

### Tables and Keys

| Table | Role | Primary key | Foreign key | Validated rows |
|---|---|---|---|---:|
| `region` | Geographic reference for regions, departments, and communes | `Code_dep_code_commune` | — | 38,919 |
| `contrat` | Home insurance contracts and insured-property characteristics | `Contrat_ID` | `Code_dep_code_commune` → `region.Code_dep_code_commune` | 30,335 |

### Cardinality

- One geographic entry in `region` can be associated with zero, one, or several contracts.
- Each row in `contrat` must reference exactly one existing geographic entry.
- The relationship is therefore **one-to-many (1:N)** from `region` to `contrat`.
- The foreign key prevents the creation of contracts without a matching geographic reference.

## Table Structure

### `region`

The `region` table contains the geographic reference data used to locate each insured property.

| Column | SQL type | Description |
|---|---|---|
| `Code_dep_code_commune` | `VARCHAR(6)` | Unique geographic identifier and primary key |
| `reg_code` | `VARCHAR(2)` | Region code |
| `reg_nom` | `VARCHAR(50)` | Region name |
| `aca_nom` | `VARCHAR(50)` | Academy name |
| `dep_nom` | `VARCHAR(60)` | Department name |
| `com_nom_maj_court` | `VARCHAR(80)` | Short commune name in uppercase |
| `dep_code` | `VARCHAR(3)` | Department code |
| `dep_nom_num` | `VARCHAR(80)` | Department name with its code |

### `contrat`

The `contrat` table contains contract, address, housing, coverage, and pricing information.

| Column | SQL type | Description |
|---|---|---|
| `Contrat_ID` | `INT` | Unique contract identifier and primary key |
| `No_voie` | `VARCHAR(10)` | Street number; nullable because some addresses do not provide one |
| `B_T_Q` | `CHAR(1)` | Address suffix information such as bis, ter, or quater |
| `Type_de_voie` | `VARCHAR(10)` | Street type |
| `Voie` | `VARCHAR(100)` | Street name |
| `Code_dep_code_commune` | `VARCHAR(6)` | Geographic identifier and foreign key to `region` |
| `Code_postal` | `VARCHAR(5)` | Postal code |
| `Surface` | `INT` | Housing surface |
| `Type_local` | `VARCHAR(30)` | Type of insured housing |
| `Occupation` | `VARCHAR(30)` | Occupation status of the housing |
| `Type_contrat` | `VARCHAR(40)` | Contract category |
| `Formule` | `VARCHAR(30)` | Insurance formula |
| `Valeur_declaree_biens` | `VARCHAR(30)` | Declared-value category for insured property |
| `Prix_cotisation_mensuel` | `DECIMAL(10,2)` | Monthly insurance premium |

## Technical Design Choices

- **InnoDB** is used to support foreign keys and transactional integrity.
- **`utf8mb4_unicode_ci`** provides Unicode-compatible storage, comparison, and sorting.
- Geographic and postal codes use `VARCHAR` rather than numeric types so that leading zeros are retained.
- `No_voie` uses `VARCHAR(10)` because street numbers may be missing or contain non-numeric information.
- `Prix_cotisation_mensuel` uses `DECIMAL(10,2)` to store monetary values without floating-point approximation.
- Tables are dropped in child-to-parent order and populated in parent-to-child order to respect the foreign key relationship.
- Encoding normalization is isolated in a dedicated SQL script so that data correction remains separate from database creation, import validation, and business analysis.

## SQL Files

| File | Purpose |
|---|---|
| `01_creation_bdd.sql` | Creates the database, the two tables, and their primary and foreign key constraints |
| `02_normalisation_encodage.sql` | Adds the three missing La Réunion geographic references, repairs corrupted French characters, and standardizes geographic labels |
| `03_verifications_import.sql` | Checks final row counts, validates referential integrity, detects remaining encoding issues, and previews the imported data |
| `04_requetes_analyses.sql` | Contains the 12 required business queries and 3 additional analyses |

## Database Creation and Import

The database is created with the following configuration:

```sql
CREATE DATABASE IF NOT EXISTS oc_assurance_habitation
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

### Execution Order

1. Execute `01_creation_bdd.sql` in MySQL Workbench.
2. Import `Region.csv` into the `region` table.
3. Execute `02_normalisation_encodage.sql` to:
   - verify the initial region row count;
   - insert the three missing La Réunion geographic references;
   - repair corrupted accented characters;
   - standardize the La Réunion geographic values;
   - confirm that no typical encoding artifacts remain.
4. Import `Contrat.csv` into the `contrat` table.
5. Execute `03_verifications_import.sql` to:
   - verify the final row counts;
   - validate referential integrity;
   - confirm the absence of orphan contracts;
   - check that no corrupted geographic labels remain;
   - preview the imported data.
6. Execute the 12 required queries and the 3 additional analyses from `04_requetes_analyses.sql`.

This order is required because `region` is the parent table and `contrat` depends on it through a foreign key.

## Validated Data Volumes

| Table | Number of rows |
|---|---:|
| `region` | 38,919 |
| `contrat` | 30,335 |

`Region.csv` initially contains 38,916 rows. Three missing geographic references related to La Réunion are added before importing `Contrat.csv`, producing a final total of 38,919 rows.

These additional entries ensure that every contract foreign key already exists in the parent table before the contract data is imported.

## Encoding and Geographic Normalization

Some geographic labels were imported with corrupted characters because UTF-8 text was interpreted with an incompatible character encoding.

Typical examples included values such as:

```text
RhÃ´ne
CrÃ©teil
CÃ´te-d'Or
Bourgogne-Franche-ComtÃ©
```

The dedicated `02_normalisation_encodage.sql` script repairs the affected text fields in the `region` table:

- `reg_nom`;
- `aca_nom`;
- `dep_nom`;
- `com_nom_maj_court`;
- `dep_nom_num`.

It also standardizes La Réunion with region code `4` so that its contracts are grouped on a single row in regional analyses.

A final control searches for typical encoding artifacts such as `Ã`, `Â`, and `�`. The expected result is **zero remaining rows**.

## Data Integrity Checks

The primary key constraints enforce row uniqueness in both tables.

The validation queries check:

- the final number of rows in each table;
- the absence of remaining encoding artifacts;
- the existence of every geographic reference used by a contract;
- the absence of contracts without a matching row in `region`;
- the consistency of the one-to-many relationship.

Referential integrity is verified with a `LEFT JOIN`:

```sql
SELECT COUNT(*) AS contracts_without_region
FROM contrat AS c
LEFT JOIN region AS r
    ON r.Code_dep_code_commune = c.Code_dep_code_commune
WHERE r.Code_dep_code_commune IS NULL;
```

Validated result:

```text
Contracts without region: 0
```

This confirms that all 30,335 contracts are linked to an existing geographic entry.

## Business Analyses

The project includes **12 required SQL queries** covering:

- filtering contracts by postal code;
- listing distinct regions;
- counting main-residence contracts;
- identifying the properties with the largest surfaces;
- calculating average monthly insurance premiums;
- grouping contracts by declared property value;
- counting a specific insurance formula within a region;
- filtering houses within a selected department;
- calculating the average housing surface in Paris;
- ranking departments by average monthly premium;
- identifying communes with at least 150 contracts;
- counting contracts by region.

Three additional queries extend the analysis by studying:

- the average premium by housing type;
- the number of contracts by occupation status;
- the communes with the highest contract volumes.

## Example Query

```sql
SELECT
    Contrat_ID,
    Surface
FROM contrat
WHERE Code_postal = '92100'
ORDER BY Contrat_ID;
```

This query lists the contract identifiers and housing surfaces for properties located in postal code `92100`.

## Screenshots

The `screenshots/` folder contains evidence of the SQL queries executed in MySQL Workbench.

Each screenshot displays:

- the executed SQL query;
- the result grid returned by MySQL Workbench;
- the data used to answer the corresponding project question.

The folder documents the successful execution of the **12 required queries** and the **3 additional analyses** after geographic labels were normalized.

## Technologies Used

- MySQL
- MySQL Workbench
- SQL
- SQL Power Architect
- Visual Studio Code
- Git and GitHub

## Skills Demonstrated

- Relational database modeling
- SQL DDL and DML
- Primary and foreign key management
- CSV data import
- Character-encoding diagnosis and correction
- Post-import data normalization
- Referential-integrity validation
- Business-oriented SQL analysis
- Technical documentation
- Git version control

## Author

**Stephane-OC** — Project completed as part of a Data Analyst training path.

---

This project demonstrates the ability to transform source data into a reliable relational database, diagnose and correct character-encoding issues, enforce data integrity, and use SQL to produce clear business insights.
