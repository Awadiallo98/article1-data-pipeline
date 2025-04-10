# Projet dbt – Recommandations de mentors

Ce projet dbt a été développé dans le cadre de l’analyse des recommandations de mentors, à partir de données brutes de bénévoles, jeunes et binômes.

## Objectifs

- Nettoyer et structurer les données brutes en tables prêtes pour l’analyse.
- Créer une vue analytique des recommandations acceptées/refusées par mentor et par mois.
- Mettre en place des tests de qualité pour garantir la fiabilité des données.
- Gérer les cas de mentors sans recommandations ou les données incomplètes.

---

## Structure du projet

### `models/`

Organisation en 3 couches :

- `raw/` : ingestion brute des fichiers CSV (pas de transformation, colonnes en `TEXT`)
- `staging/` : nettoyage, typage, parse de dates, suppression des doublons
- `mart/` : agrégations analytiques pour les recommandations

### `tests/quality/`

Tests personnalisés SQL pour vérifier des règles métier spécifiques (ex. : recommandations négatives).

---

## Modèles principaux

### `stg_benevoles`, `stg_jeunes`, `stg_binomes`

Modèles de préparation de données :

- Dé-duplication avec `ROW_NUMBER()`
- Conversion des types (`SAFE_CAST`, `CAST(...) AS BOOL`)
- Nettoyage de dates au format français via `SAFE.PARSE_DATE(DATETIME)`
- Colonnes complexes comme les tableaux ou JSON laissées prêtes pour traitement futur

### `mart_recos_par_mentor_et_mois`

Vue agrégée simple qui contient :

- Le nombre de recommandations acceptées et refusées
- Groupées par `bv_id` (mentor) et par mois (`DATE_TRUNC(date_proposition, MONTH)`)

Mentors sans recommandation ne sont **pas inclus** ici.

### `mart_recos_par_mentor_et_mois_complet`

Même logique que ci-dessus, mais :

- Inclut **tous les mentors**, même ceux sans reco
- Jointure entre tous les mentors et les mois actifs de recommandations
- Utilisation de `COALESCE(..., 0)` pour retourner 0 si aucune donnée

---

## Tests de qualité

### Déclarés dans `schema.yml`

- `not_null` sur les colonnes critiques
- `unique` sur les identifiants (bv_id, b_id, j_id)
- `dbt_utils.expression_is_true` pour vérifier que les compteurs (`nb_acceptees`, `nb_refusees`) sont toujours >= 0

### Tests SQL custom (dans `tests/quality/`)

```sql
-- test_nb_recos_non_negatives.sql
SELECT * FROM {{ ref('mart_recos_par_mentor_et_mois') }} WHERE nb_acceptees < 0;
SELECT * FROM {{ ref('mart_recos_par_mentor_et_mois') }} WHERE nb_refusees < 0;
```
