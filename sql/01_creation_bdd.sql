-- ============================================================
-- Projet SQL - Assurance habitation
-- Fichier : 01_creation_bdd.sql
-- Objectif : création de la base de données et des tables
-- SGBD : MySQL / MySQL Workbench
-- ============================================================

CREATE DATABASE IF NOT EXISTS oc_assurance_habitation
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE oc_assurance_habitation;

-- On supprime d'abord la table enfant, puis la table parent.
DROP TABLE IF EXISTS contrat;
DROP TABLE IF EXISTS region;

-- ============================================================
-- Table REGION
-- Référentiel géographique des communes / départements / régions
-- ============================================================

CREATE TABLE region (
    Code_dep_code_commune VARCHAR(6) NOT NULL,
    reg_code VARCHAR(2) NOT NULL,
    reg_nom VARCHAR(50) NOT NULL,
    aca_nom VARCHAR(50) NOT NULL,
    dep_nom VARCHAR(60) NOT NULL,
    com_nom_maj_court VARCHAR(80) NOT NULL,
    dep_code VARCHAR(3) NOT NULL,
    dep_nom_num VARCHAR(80) NOT NULL,

    CONSTRAINT pk_region PRIMARY KEY (Code_dep_code_commune)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Table CONTRAT
-- Données des contrats d'assurance habitation
-- ============================================================
-- Remarque importante :
-- No_voie est en VARCHAR(10), et non en INT, car il s'agit d'une
-- donnée d'adresse. Certaines valeurs peuvent être absentes ou
-- difficiles à importer proprement sous forme numérique.
-- ============================================================

CREATE TABLE contrat (
    Contrat_ID INT NOT NULL,
    No_voie VARCHAR(10) NULL,
    B_T_Q CHAR(1) NULL,
    Type_de_voie VARCHAR(10) NULL,
    Voie VARCHAR(100) NOT NULL,
    Code_dep_code_commune VARCHAR(6) NOT NULL,
    Code_postal VARCHAR(5) NOT NULL,
    Surface INT NOT NULL,
    Type_local VARCHAR(30) NOT NULL,
    Occupation VARCHAR(30) NOT NULL,
    Type_contrat VARCHAR(40) NOT NULL,
    Formule VARCHAR(30) NOT NULL,
    Valeur_declaree_biens VARCHAR(30) NOT NULL,
    Prix_cotisation_mensuel DECIMAL(10,2) NOT NULL,

    CONSTRAINT pk_contrat PRIMARY KEY (Contrat_ID),

    CONSTRAINT fk_contrat_region
        FOREIGN KEY (Code_dep_code_commune)
        REFERENCES region(Code_dep_code_commune)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
 
-- ============================================================
-- Étape suivante dans MySQL Workbench :
-- 1. Importer Region.csv dans la table region
-- 2. Exécuter le fichier 02_verifications_import.sql jusqu'au bloc
--    d'ajout des communes techniques de La Réunion
-- 3. Importer Contrat.csv dans la table contrat
-- 4. Exécuter les vérifications finales du fichier 02
-- ============================================================