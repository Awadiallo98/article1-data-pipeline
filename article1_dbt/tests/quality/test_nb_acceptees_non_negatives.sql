-- Vérifie que nb_acceptees est toujours >= 0
SELECT *
FROM {{ ref('mart_recos_par_mentor_et_mois') }}
WHERE nb_acceptees < 0

