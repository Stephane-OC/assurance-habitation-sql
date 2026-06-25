-- ============================================================
-- Projet SQL - Assurance habitation
-- Fichier : 03_requetes_analyses.sql
-- Objectif : requêtes d'analyse SQL demandées dans le projet
-- SGBD : MySQL / MySQL Workbench
-- ============================================================

USE oc_assurance_habitation;

-- ============================================================
-- REQUÊTES 1 À 3
-- Intitulés repris depuis la trame de travail OpenClassrooms
-- ============================================================

-- Requête 1 :
-- Lister les numéros de contrats (Contrat_ID) avec leur surface
-- pour le code postal 92100.

SELECT
    Contrat_ID,
    Surface
FROM contrat
WHERE Code_postal = '92100'
ORDER BY Contrat_ID;

-- Requête 2 :
-- Lister le nom des régions de France

SELECT DISTINCT
    reg_nom
FROM region
ORDER BY reg_nom;

-- Requête 3 :
-- Combien existe-t-il de contrats sur les résidences principales ?

SELECT
    COUNT(*) AS nombre_contrats_residence_principale
FROM contrat
WHERE Type_contrat = 'Residence principale';

-- ============================================================
-- REQUÊTES 4 À 12
-- Intitulés repris depuis les consignes du projet
-- ============================================================

-- Requête 4 :
-- Quels sont les 5 contrats qui ont les surfaces les plus élevées ?

SELECT
    Contrat_ID,
    Surface,
    Type_local,
    Occupation,
    Type_contrat,
    Formule,
    Prix_cotisation_mensuel
FROM contrat
ORDER BY Surface DESC
LIMIT 5;

-- Requête 5 :
-- Quel est le prix moyen de la cotisation mensuelle ?

SELECT
    ROUND(AVG(Prix_cotisation_mensuel), 2) AS prix_moyen_cotisation_mensuelle
FROM contrat;

-- Requête 6 :
-- Quel est le nombre de contrats pour chaque catégorie de prix
-- de la valeur déclarée des biens ?

SELECT
    Valeur_declaree_biens,
    COUNT(*) AS nombre_contrats
FROM contrat
GROUP BY Valeur_declaree_biens
ORDER BY
    CASE Valeur_declaree_biens
        WHEN '0-25000' THEN 1
        WHEN '25000-50000' THEN 2
        WHEN '50000-100000' THEN 3
        WHEN '100000-150000' THEN 4
        WHEN '150000-200000' THEN 5
        ELSE 99
    END;

-- Requête 7 :
-- Quel est le nombre de formules "Integral" sur la région Pays de la Loire ?

SELECT
    r.reg_nom AS region,
    c.Formule,
    COUNT(*) AS nombre_formules_integral
FROM contrat c
INNER JOIN region r
    ON c.Code_dep_code_commune = r.Code_dep_code_commune
WHERE c.Formule = 'Integral'
  AND r.reg_nom = 'Pays de la Loire'
GROUP BY r.reg_nom, c.Formule;

-- Requête 8 :
-- Lister les numéros de contrats avec le type de contrat et leur formule
-- pour les maisons du département 71.

SELECT
    c.Contrat_ID,
    c.Type_contrat,
    c.Formule,
    c.Type_local,
    r.dep_code,
    r.dep_nom
FROM contrat c
INNER JOIN region r
    ON c.Code_dep_code_commune = r.Code_dep_code_commune
WHERE c.Type_local = 'Maison'
  AND r.dep_code = '71'
ORDER BY c.Contrat_ID;

-- Requête 9 :
-- Quelle est la surface moyenne des contrats à Paris ?
-- Ici, Paris est identifié par la commune "PARIS".

SELECT
    r.com_nom_maj_court AS commune,
    ROUND(AVG(c.Surface), 2) AS surface_moyenne
FROM contrat c
INNER JOIN region r
    ON c.Code_dep_code_commune = r.Code_dep_code_commune
WHERE r.com_nom_maj_court = 'PARIS'
GROUP BY r.com_nom_maj_court;

-- Requête 10 :
-- Classement des 10 départements où le prix moyen de la cotisation
-- est le plus élevé.

SELECT
    r.dep_code,
    r.dep_nom,
    COUNT(*) AS nombre_contrats,
    ROUND(AVG(c.Prix_cotisation_mensuel), 2) AS prix_moyen_cotisation
FROM contrat c
INNER JOIN region r
    ON c.Code_dep_code_commune = r.Code_dep_code_commune
GROUP BY r.dep_code, r.dep_nom
ORDER BY prix_moyen_cotisation DESC
LIMIT 10;

-- Requête 11 :
-- Liste des communes ayant eu au moins 150 contrats.

SELECT
    r.Code_dep_code_commune,
    r.com_nom_maj_court AS commune,
    r.dep_code,
    r.dep_nom,
    COUNT(*) AS nombre_contrats
FROM contrat c
INNER JOIN region r
    ON c.Code_dep_code_commune = r.Code_dep_code_commune
GROUP BY
    r.Code_dep_code_commune,
    r.com_nom_maj_court,
    r.dep_code,
    r.dep_nom
HAVING COUNT(*) >= 150
ORDER BY nombre_contrats DESC;

-- Requête 12 :
-- Quel est le nombre de contrats pour chaque région ?

SELECT
    r.reg_code,
    r.reg_nom,
    COUNT(*) AS nombre_contrats
FROM contrat c
INNER JOIN region r
    ON c.Code_dep_code_commune = r.Code_dep_code_commune
GROUP BY r.reg_code, r.reg_nom
ORDER BY nombre_contrats DESC;

-- ============================================================
-- REQUÊTES BONUS (facultatives)
-- Pour montrer une analyse un peu plus poussée
-- ============================================================

-- Requête bonus 13 :
-- Quel est le prix moyen de la cotisation par type de logement ?

SELECT
    Type_local,
    ROUND(AVG(Prix_cotisation_mensuel), 2) AS prix_moyen_cotisation
FROM contrat
GROUP BY Type_local
ORDER BY prix_moyen_cotisation DESC;

-- Requête bonus 14 :
-- Quel est le nombre de contrats par statut d’occupation ?

SELECT
    Occupation,
    COUNT(*) AS nombre_contrats
FROM contrat
GROUP BY Occupation
ORDER BY nombre_contrats DESC;

-- Requête bonus 15 :
-- Quelles sont les 10 communes qui ont le plus de contrats ?

SELECT
    r.com_nom_maj_court AS commune,
    r.dep_nom AS departement,
    r.reg_nom AS region,
    COUNT(*) AS nombre_contrats
FROM contrat c
INNER JOIN region r
    ON c.Code_dep_code_commune = r.Code_dep_code_commune
GROUP BY
    r.com_nom_maj_court,
    r.dep_nom,
    r.reg_nom
ORDER BY nombre_contrats DESC
LIMIT 10;