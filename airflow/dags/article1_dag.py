from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago
from datetime import timedelta

default_args = {
    'owner': 'awadi',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id='article1_pipeline_dbt',
    default_args=default_args,
    description='Pipeline Airflow pour ingestion + transformation avec dbt',
    schedule_interval="0 3 * * *",  # tous les jours à 3h du matin
    start_date=days_ago(1),
    catchup=False,
    tags=['dbt', 'article1'],
) as dag:

    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command='cd /opt/airflow/dbt && dbt run --profiles-dir .',
    )

    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command='cd /opt/airflow/dbt && dbt test --profiles-dir .',
    )

    dbt_run >> dbt_test
