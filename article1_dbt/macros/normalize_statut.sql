{% macro normalize_statut(input) %}
    CASE
        WHEN LOWER({{ input }}) IN ('actif', 'active') THEN 'ACTIF'
        WHEN LOWER({{ input }}) IN ('annule', 'annulé') THEN 'ANNULE'
        WHEN LOWER({{ input }}) IN ('non disponible', 'non_disponible') THEN 'NON_DISPONIBLE'
        WHEN LOWER({{ input }}) IN ('en attente activation', 'en_attente_activation') THEN 'EN_ATTENTE_ACTIVATION'
        WHEN LOWER({{ input }}) IN ('en cours inscription', 'en_cours_inscription') THEN 'EN_COURS_INSCRIPTION'
        WHEN LOWER({{ input }}) IN ('approuve', 'approuvé') THEN 'APPROUVE'
        WHEN LOWER({{ input }}) IN ('en attente validation', 'en_attente_validation') THEN 'EN_ATTENTE_VALIDATION'
        WHEN LOWER({{ input }}) IN ('refuse', 'refusé', 'refusé(e)') THEN 'REFUSE'
        WHEN LOWER({{ input }}) = 'associe parcours' THEN 'ASSOCIE PARCOURS'
        WHEN LOWER({{ input }}) = 'en attente parent' THEN 'EN ATTENTE PARENT'
        WHEN LOWER({{ input }}) = 'hors programme' THEN 'HORS PROGRAMME'
        WHEN LOWER({{ input }}) = 'matche' THEN 'MATCHE'
        WHEN LOWER({{ input }}) IN ('non renseigné', 'non renseigne', 'non_renseigné') THEN 'NON RENSEIGNÉ'
        WHEN LOWER({{ input }}) = 'sorti' THEN 'SORTI'
        ELSE UPPER({{ input }}) -- fallback
    END
{% endmacro %}
