# Orchestration du pipeline de données avec Apache Airflow

## Objectif

Mettre en place un orchestrateur de workflow permettant d'automatiser les étapes d’ingestion et de transformation de données. Dans ce projet, **Apache Airflow en local** a été utilisé pour piloter l'exécution des traitements réalisés avec **dbt** et alimentés par **Airbyte**.

---

## Architecture

- **Airbyte** (externe) : ingère les données quotidiennement via CDC vers PostgreSQL.
- **Airflow** : orchestre les tâches de transformation.
- **dbt** : exécute les transformations SQL sur BigQuery.
- **Docker** : conteneurise l’ensemble de la stack.
- **BigQuery** : entrepôt cible des modèles dbt.

---

## DAG : `article1_pipeline_dbt`

### Tâches définies

- `dbt_run` : exécute les transformations définies dans le projet dbt.
- `dbt_test` : déclenche les tests de qualité définis dans `schema.yml`.

### Planification

```python
schedule_interval="0 3 * * *"  # Exécution quotidienne à 03:00 (heure serveur)
```

### Arborescence

![alt text](image.png)
