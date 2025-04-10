{{ config(materialized='view', schema='staging') }}

WITH cleaned AS (

  SELECT
    -- Identifiants nettoyés
    REPLACE(bv_id, ",", "") AS bv_id,
    REPLACE(admin_associe_id, ",", "") AS admin_associe_id,
    REPLACE(utilisateur_id, ",", "") AS utilisateur_id,

    -- Champs texte
    NULLIF(TRIM(genre), '') AS genre,
    NULLIF(TRIM(region), '') AS region,
    {{ normalize_statut('statut') }} AS statut,
    NULLIF(TRIM(b_statut), '') AS b_statut,
    NULLIF(TRIM(type_aide), '') AS type_aide,
    NULLIF(TRIM(experience), '') AS experience,
    NULLIF(TRIM(poste_actuel), '') AS poste_actuel,
    NULLIF(TRIM(status_formation), '') AS status_formation,
    NULLIF(TRIM(profil_linkedin), '') AS profil_linkedin,

    -- Champs numériques
    SAFE_CAST(nb_binomes AS INT64) AS nb_binomes,
    SAFE_CAST(nb_termines AS INT64) AS nb_termines,
    SAFE_CAST(nb_annulations AS INT64) AS nb_annulations,
    SAFE_CAST(nb_propositions AS INT64) AS nb_propositions,
    SAFE_CAST(nb_binome_en_cours AS INT64) AS nb_binome_en_cours,

    -- Champs booléens
    CAST(multibinome IN ('1', 'true', 'TRUE') AS BOOL) AS multibinome,
    CAST(a_ete_mentor IN ('1', 'true', 'TRUE') AS BOOL) AS a_ete_mentor,
    CAST(boursier IN ('1', 'true', 'TRUE') AS BOOL) AS boursier,
    CAST(est_entreprise_partenaire IN ('1', 'true', 'TRUE') AS BOOL) AS est_entreprise_partenaire,
    CAST(consentement_newsletter IN ('1', 'true', 'TRUE') AS BOOL) AS consentement_newsletter,

    -- Dates françaises (avec macros)
    {{ parse_french_datetime('date_maj_statut') }} AS date_maj_statut,
    {{ parse_french_datetime('date_inscription') }} AS date_inscription,
    {{ parse_french_date('date_de_naissance') }} AS date_de_naissance,

    -- Champs semi-structurés (JSON, tableaux)
    passions,
    connu_par,

    -- Métadonnées Airbyte
    _airbyte_extracted_at

  FROM {{ ref('raw_benevoles') }}
  WHERE _ab_cdc_deleted_at IS NULL

),

deduplicated AS (
  SELECT *
  FROM (
    SELECT *,
      ROW_NUMBER() OVER (
        PARTITION BY bv_id
        ORDER BY _airbyte_extracted_at DESC
      ) AS row_num
    FROM cleaned
  )
  WHERE row_num = 1
)

SELECT * EXCEPT(row_num)
FROM deduplicated
