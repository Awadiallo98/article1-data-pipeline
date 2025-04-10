{{ config(materialized='view', schema='staging') }}

WITH cleaned AS (
  SELECT
    -- Identifiants nettoyés
    REPLACE(b_id, ",", "") AS b_id,
    REPLACE(bv_id, ",", "") AS bv_id,
    REPLACE(j_id, ",", "") AS j_id,
    REPLACE(admin_id, ",", "") AS admin_id,

    -- Statut
    {{ normalize_statut('statut') }} AS statut,


    -- Champs booléens
    CAST(est_lance IN ('1', 'true', 'TRUE') AS BOOL) AS est_lance,
    CAST(est_en_cours IN ('1', 'true', 'TRUE') AS BOOL) AS est_en_cours,
    CAST(matching_auto IN ('1', 'true', 'TRUE') AS BOOL) AS matching_auto,

    -- Dates (en français)
    {{ parse_french_datetime('date_proposition') }} AS date_proposition,
    {{ parse_french_datetime('date_creation') }} AS date_creation,
    {{ parse_french_datetime('date_maj_statut') }} AS date_maj_statut,
    {{ parse_french_date('jour_dernier_cp') }} AS jour_dernier_cp,
    {{ parse_french_date('date_prochain_cp') }} AS date_prochain_cp,
    {{ parse_french_date('_rappel_48h') }} AS rappel_48h,

    -- Champs textuels
    NULLIF(TRIM(raison_annulation), '') AS raison_annulation,
    NULLIF(TRIM(commentaire), '') AS commentaire,
    NULLIF(TRIM(annee_scolaire), '') AS annee_scolaire,
    NULLIF(TRIM(duree_binome), '') AS duree_binome,

    -- Numérique
    SAFE_CAST(delai_acceptation_minutes AS INT64) AS delai_acceptation_minutes,

    -- Métadonnées
    _airbyte_extracted_at

  FROM {{ ref('raw_binomes') }}
  WHERE _ab_cdc_deleted_at IS NULL
),

deduplicated AS (
  SELECT *
  FROM (
    SELECT *,
      ROW_NUMBER() OVER (
        PARTITION BY b_id
        ORDER BY _airbyte_extracted_at DESC
      ) AS row_num
    FROM cleaned
  )
  WHERE row_num = 1
)

SELECT * EXCEPT(row_num)
FROM deduplicated
