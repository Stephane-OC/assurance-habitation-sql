-- ============================================================
-- Projet SQL - Assurance habitation
-- Fichier : 02_normalisation_encodage.sql
-- Objectif : préparation et normalisation du référentiel REGION
-- SGBD : MySQL / MySQL Workbench
-- ============================================================
--
-- À exécuter :
--   APRÈS l'import de Region.csv
--   et AVANT l'import de Contrat.csv.
--
-- Ce fichier :
--   1. vérifie le volume initial de Region.csv ;
--   2. ajoute les 3 références géographiques manquantes ;
--   3. répare les caractères UTF-8 mal décodés à l'import ;
--   4. harmonise les informations de La Réunion ;
--   5. contrôle le résultat de la normalisation.
-- ============================================================

USE oc_assurance_habitation;

-- ============================================================
-- 1. Vérification de l'import initial de Region.csv
-- Résultat attendu : 38916 lignes
-- ============================================================

SELECT COUNT(*) AS nombre_lignes_region_avant_normalisation
FROM region;


-- ============================================================
-- 2. Ajout des 3 codes géographiques absents du référentiel
--
-- Ces codes sont utilisés par Contrat.csv mais absents de
-- Region.csv. Ils doivent donc être ajoutés avant l'import
-- de la table contrat afin de respecter la clé étrangère.
--
-- INSERT IGNORE permet de rejouer le fichier sans créer de
-- doublon ni provoquer d'erreur sur la clé primaire.
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


-- ============================================================
-- 3. Réparation globale des caractères mal encodés
--
-- Lors de l'import, certaines chaînes UTF-8 ont été interprétées
-- comme du latin1 / Windows-1252, par exemple :
--   RhÃ´ne       -> Rhône
--   CrÃ©teil     -> Créteil
--   CÃ´te-d'Or   -> Côte-d'Or
--
-- La correction est appliquée uniquement aux valeurs contenant
-- les marqueurs caractéristiques "Ã" ou "Â".
-- ============================================================

SET @ancien_sql_safe_updates = @@SQL_SAFE_UPDATES;
SET SQL_SAFE_UPDATES = 0;

START TRANSACTION;

UPDATE region
SET
    reg_nom = CASE
        WHEN reg_nom REGEXP 'Ã|Â'
        THEN CONVERT(
            CAST(CONVERT(reg_nom USING latin1) AS BINARY)
            USING utf8mb4
        )
        ELSE reg_nom
    END,

    aca_nom = CASE
        WHEN aca_nom REGEXP 'Ã|Â'
        THEN CONVERT(
            CAST(CONVERT(aca_nom USING latin1) AS BINARY)
            USING utf8mb4
        )
        ELSE aca_nom
    END,

    dep_nom = CASE
        WHEN dep_nom REGEXP 'Ã|Â'
        THEN CONVERT(
            CAST(CONVERT(dep_nom USING latin1) AS BINARY)
            USING utf8mb4
        )
        ELSE dep_nom
    END,

    com_nom_maj_court = CASE
        WHEN com_nom_maj_court REGEXP 'Ã|Â'
        THEN CONVERT(
            CAST(CONVERT(com_nom_maj_court USING latin1) AS BINARY)
            USING utf8mb4
        )
        ELSE com_nom_maj_court
    END,

    dep_nom_num = CASE
        WHEN dep_nom_num REGEXP 'Ã|Â'
        THEN CONVERT(
            CAST(CONVERT(dep_nom_num USING latin1) AS BINARY)
            USING utf8mb4
        )
        ELSE dep_nom_num
    END
WHERE CONCAT_WS(
    ' ',
    reg_nom,
    aca_nom,
    dep_nom,
    com_nom_maj_court,
    dep_nom_num
) REGEXP 'Ã|Â';


-- ============================================================
-- 4. Harmonisation spécifique de La Réunion
--
-- Cette étape garantit un seul code et un seul libellé pour
-- l'ensemble des lignes du département 974.
-- ============================================================

UPDATE region
SET
    reg_code = '4',
    reg_nom = 'La Réunion',
    aca_nom = 'La Réunion',
    dep_nom = 'La Réunion',
    dep_nom_num = 'La Réunion (974)'
WHERE dep_code = '974';

COMMIT;

SET SQL_SAFE_UPDATES = @ancien_sql_safe_updates;


-- ============================================================
-- 5. Contrôles après normalisation
-- ============================================================

-- Résultat attendu après ajout des 3 références : 38919 lignes.
SELECT COUNT(*) AS nombre_lignes_region_apres_normalisation
FROM region;

-- Résultat attendu : 0 ligne.
-- Une ligne retournée doit être contrôlée manuellement car le
-- caractère de remplacement "�" indique parfois une perte
-- d'information impossible à reconstruire automatiquement.
SELECT DISTINCT
    reg_code,
    reg_nom,
    aca_nom,
    dep_code,
    dep_nom,
    dep_nom_num
FROM region
WHERE CONCAT_WS(
    ' ',
    reg_nom,
    aca_nom,
    dep_nom,
    com_nom_maj_court,
    dep_nom_num
) REGEXP 'Ã|Â|�'
ORDER BY dep_code;

-- Résultat attendu : une seule ligne pour La Réunion.
SELECT DISTINCT
    reg_code,
    reg_nom,
    dep_code,
    dep_nom
FROM region
WHERE dep_code = '974';

-- Quelques contrôles ciblés sur des libellés accentués.
SELECT DISTINCT
    dep_code,
    dep_nom,
    dep_nom_num
FROM region
WHERE dep_code IN ('13', '21', '25', '69', '71', '79', '85')
ORDER BY dep_code;

-- ============================================================
-- Étape suivante : importer Contrat.csv dans la table contrat,
-- puis exécuter 03_verifications_import.sql.
-- ============================================================
