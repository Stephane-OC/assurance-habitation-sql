-- ============================================================
-- Projet SQL - Assurance habitation
-- Fichier : 02_verifications_import.sql
-- Objectif : contrôles après import des CSV
-- SGBD : MySQL / MySQL Workbench
-- ============================================================

USE oc_assurance_habitation;

-- ============================================================
-- 1. Vérification après import de Region.csv
-- Résultat attendu après import seul du CSV : 38916 lignes
-- ============================================================

SELECT COUNT(*) AS nombre_lignes_region
FROM region;

-- ============================================================
-- 2. Ajout des 3 codes géographiques absents du référentiel
-- À exécuter APRÈS l'import de Region.csv
-- et AVANT l'import de Contrat.csv.
--
-- INSERT IGNORE permet d'éviter une erreur si la requête est rejouée
-- ============================================================

INSERT IGNORE INTO region (
    Code_dep_code_commune,
    reg_code,
    reg_nom,
    aca_nom,
    dep_nom,
    com_nom_maj_court,
    dep_code,
    dep_nom_num
)
VALUES
('97434', '04', 'La Réunion', 'La Réunion', 'La Réunion', 'COMMUNE NON RENSEIGNEE', '974', 'La Réunion (974)'),
('97460', '04', 'La Réunion', 'La Réunion', 'La Réunion', 'COMMUNE NON RENSEIGNEE', '974', 'La Réunion (974)'),
('97470', '04', 'La Réunion', 'La Réunion', 'La Réunion', 'COMMUNE NON RENSEIGNEE', '974', 'La Réunion (974)');

-- Résultat attendu après ajout des 3 lignes techniques : 38919 lignes

SELECT COUNT(*) AS nombre_lignes_region_apres_ajout
FROM region;

-- ============================================================
-- 3. Vérification après import de Contrat.csv
-- Résultat attendu : 30335 lignes
-- ============================================================

SELECT COUNT(*) AS nombre_lignes_contrat
FROM contrat;

-- ============================================================
-- 4. Vérification globale du nombre de lignes
-- Résultat attendu :
-- region  = 38919
-- contrat = 30335
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM region) AS lignes_region,
    (SELECT COUNT(*) FROM contrat) AS lignes_contrat;

-- ============================================================
-- 5. Vérification de l'intégrité référentielle
-- Résultat attendu : 0
-- Cela signifie que chaque contrat possède une correspondance
-- dans la table region.
-- ============================================================

SELECT COUNT(*) AS contrats_sans_region
FROM contrat c
LEFT JOIN region r
    ON c.Code_dep_code_commune = r.Code_dep_code_commune
WHERE r.Code_dep_code_commune IS NULL;

-- ============================================================
-- 6. Aperçu rapide des données importées
-- ============================================================

SELECT *
FROM region
LIMIT 10;

SELECT *
FROM contrat
LIMIT 10;
