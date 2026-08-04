-- ============================================================
-- Projet SQL - Assurance habitation
-- Fichier : 03_verifications_import.sql
-- Objectif : contrôles finaux après import des deux fichiers CSV
-- SGBD : MySQL / MySQL Workbench
-- ============================================================
--
-- À exécuter APRÈS :
--   1. l'import de Region.csv ;
--   2. l'exécution de 02_normalisation_encodage.sql ;
--   3. l'import de Contrat.csv
-- ============================================================

USE oc_assurance_habitation;

-- ============================================================
-- 1. Vérification du nombre de lignes de la table REGION
-- Résultat attendu : 38919 lignes
-- ============================================================

SELECT COUNT(*) AS nombre_lignes_region
FROM region;


-- ============================================================
-- 2. Vérification du nombre de lignes de la table CONTRAT
-- Résultat attendu : 30335 lignes
-- ============================================================

SELECT COUNT(*) AS nombre_lignes_contrat
FROM contrat;


-- ============================================================
-- 3. Vérification globale des volumes importés
-- Résultats attendus :
--   region  = 38919
--   contrat = 30335
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM region) AS lignes_region,
    (SELECT COUNT(*) FROM contrat) AS lignes_contrat;


-- ============================================================
-- 4. Vérification de l'intégrité référentielle
--
-- Résultat attendu : 0
-- Cela signifie que chaque contrat possède une correspondance
-- dans la table region
-- ============================================================

SELECT COUNT(*) AS contrats_sans_region
FROM contrat c
LEFT JOIN region r
    ON c.Code_dep_code_commune = r.Code_dep_code_commune
WHERE r.Code_dep_code_commune IS NULL;


-- ============================================================
-- 5. Vérification résiduelle de l'encodage
--
-- Résultat attendu : 0
-- Si le résultat est supérieur à 0, relancer ou contrôler le
-- fichier 02_normalisation_encodage.sql avant les analyses
-- ============================================================

SELECT COUNT(*) AS lignes_avec_encodage_incorrect
FROM region
WHERE CONCAT_WS(
    ' ',
    reg_nom,
    aca_nom,
    dep_nom,
    com_nom_maj_court,
    dep_nom_num
) REGEXP 'Ã|Â|�';


-- ============================================================
-- 6. Vérification spécifique de La Réunion
--
-- Résultat attendu : une seule ligne, avec le code région 4
-- ============================================================

SELECT DISTINCT
    reg_code,
    reg_nom,
    dep_code,
    dep_nom
FROM region
WHERE dep_code = '974';


-- ============================================================
-- 7. Aperçu rapide des données importées
-- ============================================================

SELECT *
FROM region
LIMIT 10;

SELECT *
FROM contrat
LIMIT 10;

-- ============================================================
-- Étape suivante : exécuter 04_requetes_analyses.sql
-- ============================================================