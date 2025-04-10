-- Vérifie que nb_refusees est toujours >= 0
SELECT *
FROM {{ ref('mart_recos_par_mentor_et_mois') }}
WHERE nb_refusees < 0
