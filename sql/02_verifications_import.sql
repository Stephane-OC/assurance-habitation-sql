-- ============================================================
-- Projet SQL - Assurance habitation
-- Fichier : 02_verifications_import.sql
-- Objectif : contrôles et corrections après import des CSV
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
--
-- À exécuter APRÈS l'import de Region.csv
-- et AVANT l'import de Contrat.csv.
--
-- INSERT IGNORE évite une erreur si cette requête est rejouée
-- et que les trois codes existent déjà.
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
(
    '97434',
    '4',
    'La Réunion',
    'La Réunion',
    'La Réunion',
    'COMMUNE NON RENSEIGNEE',
    '974',
    'La Réunion (974)'
),
(
    '97460',
    '4',
    'La Réunion',
    'La Réunion',
    'La Réunion',
    'COMMUNE NON RENSEIGNEE',
    '974',
    'La Réunion (974)'
),
(
    '97470',
    '4',
    'La Réunion',
    'La Réunion',
    'La Réunion',
    'COMMUNE NON RENSEIGNEE',
    '974',
    'La Réunion (974)'
);

-- Résultat attendu après ajout des 3 lignes techniques :
-- 38919 lignes.

SELECT COUNT(*) AS nombre_lignes_region_apres_ajout
FROM region;


-- ============================================================
-- 3. Harmonisation de certains noms de régions mal encodés
--
-- Ces corrections garantissent des libellés propres et
-- cohérents dans les résultats des requêtes d'analyse.
--
-- SQL_SAFE_UPDATES est temporairement désactivé car reg_code
-- n'est pas la clé primaire de la table region.
-- ============================================================

SET SQL_SAFE_UPDATES = 0;

UPDATE region
SET reg_nom = 'Provence-Alpes-Côte d''Azur'
WHERE reg_code = '93';

UPDATE region
SET reg_nom = 'Auvergne-Rhône-Alpes'
WHERE reg_code = '84';

UPDATE region
SET reg_nom = 'Bourgogne-Franche-Comté'
WHERE reg_code = '27';

UPDATE region
SET
    reg_code = '4',
    reg_nom = 'La Réunion',
    aca_nom = 'La Réunion',
    dep_nom = 'La Réunion',
    dep_nom_num = 'La Réunion (974)'
WHERE dep_code = '974';

SET SQL_SAFE_UPDATES = 1;


-- ============================================================
-- 4. Vérification des libellés géographiques corrigés
--
-- Résultats attendus :
-- Provence-Alpes-Côte d'Azur
-- Auvergne-Rhône-Alpes
-- Bourgogne-Franche-Comté
-- La Réunion
-- ============================================================

SELECT DISTINCT
    reg_code,
    reg_nom
FROM region
WHERE reg_code IN ('93', '84', '27', '4')
ORDER BY reg_code;


-- ============================================================
-- 5. Vérification après import de Contrat.csv
--
-- Cette partie doit être exécutée APRÈS l'import de Contrat.csv.
-- Résultat attendu : 30335 lignes.
-- ============================================================

SELECT COUNT(*) AS nombre_lignes_contrat
FROM contrat;


-- ============================================================
-- 6. Vérification globale du nombre de lignes
--
-- Résultats attendus :
-- region  = 38919
-- contrat = 30335
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM region) AS lignes_region,
    (SELECT COUNT(*) FROM contrat) AS lignes_contrat;


-- ============================================================
-- 7. Vérification de l'intégrité référentielle
--
-- Résultat attendu : 0.
--
-- Cela signifie que chaque contrat possède une correspondance
-- dans la table region.
-- ============================================================

SELECT COUNT(*) AS contrats_sans_region
FROM contrat c
LEFT JOIN region r
    ON c.Code_dep_code_commune = r.Code_dep_code_commune
WHERE r.Code_dep_code_commune IS NULL;


-- ============================================================
-- 8. Vérification spécifique de La Réunion
--
-- Le résultat doit montrer une seule ligne pour La Réunion.
-- Les contrats concernés seront comptés dans la requête
-- d'analyse numéro 12.
-- ============================================================

SELECT DISTINCT
    reg_code,
    reg_nom,
    dep_code,
    dep_nom
FROM region
WHERE dep_code = '974';


-- ============================================================
-- 9. Aperçu rapide des données importées 
-- ============================================================

SELECT *
FROM region
LIMIT 10;

SELECT *
FROM contrat
LIMIT 10;