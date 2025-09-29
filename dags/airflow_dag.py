from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'capaciti-team',
    'depends_on_past': False,
    'email_on_failure': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    dag_id='capaciti_etl_daily',
    default_args=default_args,
    description='ETL pipeline for CAPACITI data warehouse',
    schedule_interval='@daily',
    start_date=datetime(2025, 1, 1),
    catchup=False
) as dag:

    run_etl = BashOperator(
        task_id='run_etl_script',
        bash_command='python /opt/airflow/dags/etl.py'
    )
