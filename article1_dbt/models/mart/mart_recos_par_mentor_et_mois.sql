{{ config(materialized='table', schema='mart') }}

WITH base AS (
    SELECT
        bv_id,
        DATE_TRUNC(date_proposition, MONTH) AS mois_recommandation,
        statut
    FROM {{ ref('stg_binomes') }}
    WHERE date_proposition IS NOT NULL AND statut IS NOT NULL
),

agg AS (
    SELECT
        bv_id,
        mois_recommandation,
        COUNTIF(statut = 'TERMINE') AS nb_acceptees,
        COUNTIF(statut = 'REFUSE') AS nb_refusees
    FROM base
    GROUP BY bv_id, mois_recommandation
)

SELECT *
FROM agg
ORDER BY bv_id, mois_recommandation
