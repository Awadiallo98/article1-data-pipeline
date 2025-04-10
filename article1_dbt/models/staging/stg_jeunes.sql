{{ config(materialized='view', schema='staging') }}

WITH cleaned AS (

  SELECT
    -- Identifiants
    REPLACE(j_id, ",", "") AS j_id,
    REPLACE(admin_associe_id, ",", "") AS admin_associe_id,

    -- Champs numériques
    SAFE_CAST(age AS INT64) AS age,
    SAFE_CAST(nb_propositions AS INT64) AS nb_propositions,
    SAFE_CAST(niveau_construction_projet AS INT64) AS niveau_construction_projet,

    -- Statut normalisé
    {{ normalize_statut('statut') }} AS statut,
    NULLIF(TRIM(raison_non_dispo), '') AS raison_non_dispo,
    NULLIF(TRIM(projection_etude), '') AS projection_etude,

    -- Champs ARRAY transformés en string
    CASE
      WHEN REGEXP_CONTAINS(besoins, r'^\[.*\]$')
        THEN ARRAY_TO_STRING(SPLIT(REPLACE(REPLACE(REPLACE(besoins, '[', ''), ']', ''), '"', ''), ','), ', ')
      ELSE besoins
    END AS besoins,

    CASE
      WHEN REGEXP_CONTAINS(passions, r'^\[.*\]$')
        THEN ARRAY_TO_STRING(SPLIT(REPLACE(REPLACE(REPLACE(passions, '[', ''), ']', ''), '"', ''), ','), ', ')
      ELSE passions
    END AS passions,

    -- Champs booléens
    CAST(est_boursier IN ('1', 'true', 'TRUE', 'OUI') AS BOOL) AS est_boursier,
    CAST(habitant_qpv IN ('1', 'true', 'TRUE', 'OUI') AS BOOL) AS habitant_qpv,
    CAST(habitant_zrr IN ('1', 'true', 'TRUE', 'OUI') AS BOOL) AS habitant_zrr,
    CAST(a_ete_mentore IN ('1', 'true', 'TRUE', 'OUI') AS BOOL) AS a_ete_mentore,
    CAST(etudiant_etranger IN ('1', 'true', 'TRUE', 'OUI') AS BOOL) AS etudiant_etranger,
    CAST(sms_activation_envoye IN ('1', 'true', 'TRUE') AS BOOL) AS sms_activation_envoye,
    CAST(mail_activation_renvoye IN ('1', 'true', 'TRUE') AS BOOL) AS mail_activation_renvoye,
    CAST(consentement_newsletter IN ('1', 'true', 'TRUE') AS BOOL) AS consentement_newsletter,

    -- Dates (français)
    {{ parse_french_datetime('date_inscription') }} AS date_inscription,
    {{ parse_french_datetime('date_inscription_bam') }} AS date_inscription_bam,
    {{ parse_french_datetime('date_maj_statut') }} AS date_maj_statut,

    -- Autres champs utiles
    genre,
    ville,
    region,
    academie,
    departement_etude,
    b_annee_scolaire,
    niveau_etude,
    cursus,
    type,
    source,
    b_statut,
    cursus_autre,
    programme,
    filiere_1,
    filiere_2,
    secteur_1,
    secteur_2,
    objectifs_annuels,
    situation_familiale,
    etat_d_esprit,

    -- Technique
    _airbyte_extracted_at

  FROM {{ ref('raw_jeunes') }}
  WHERE _ab_cdc_deleted_at IS NULL
),

deduplicated AS (
  SELECT *
  FROM (
    SELECT *,
      ROW_NUMBER() OVER (
        PARTITION BY j_id
        ORDER BY _airbyte_extracted_at DESC
      ) AS row_num
    FROM cleaned
  )
  WHERE row_num = 1
)

SELECT * EXCEPT(row_num)
FROM deduplicated
