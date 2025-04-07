# Test Technique Data Engineer / ML - Article 1

## Contexte

Ce projet a été réalisé dans le cadre du test technique proposé par l'association Article 1, pour le programme DEMA1N.org. Il vise à évaluer la capacité à construire un pipeline de traitement de données complet dans un environnement cloud (GCP), avec une logique de type ELT, des transformations analytiques, un système d'orchestration, et un module de recommandation basique.

L’objectif de ce pipeline est d’optimiser le suivi et la mise en relation entre mentors et mentorés à partir de données collectées via la plateforme.

## Architecture du pipeline

Le pipeline repose sur les composants suivants :

- PostgreSQL pour simuler une source transactionnelle
- Airbyte pour l'ingestion automatisée vers BigQuery
- BigQuery comme entrepôt de données (datalake / data warehouse)
- dbt pour la transformation modulaire (Bronze, Silver, Gold)
- Airflow pour l'orchestration des flux
- Metabase et Looker Studio pour la visualisation des indicateurs
- Un module de recommandation (en bonus) basé sur les données Gold

Le schéma ci-dessous illustre cette architecture :

![data-pipeline-architecture-article1  drawio](https://github.com/user-attachments/assets/9680f0bd-e15c-42ee-a4ce-67e432774a29)


## Structure du projet

