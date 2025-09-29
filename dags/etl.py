import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os

load_dotenv()
db_uri = os.getenv("DB_URI")
engine = create_engine(db_uri)

def transform_candidates(df):
    df['province'] = df['province'].replace({
        'KZN': 'KwaZulu-Natal',
        'GP': 'Gauteng',
        'WC': 'Western Cape'
    })
    df['cohort'] = df['cohort'].fillna(0)
    df['enrollment_date'] = pd.to_datetime(df['enrollment_date'], errors='coerce')
    return df

def transform_attendance(df):
    df['attendance_category'] = pd.cut(
        df['attendance_pct'],
        bins=[0, 70, 90, 100],
        labels=['Low', 'Medium', 'High']
    )
    return df

def transform_placements(df):
    df['placement_date'] = pd.to_datetime(df['placement_date'], errors='coerce')
    df['placement_flag'] = df['status'].apply(lambda x: 1 if x.lower() == 'placed' else 0)
    return df

def load_csv_to_db(file_path, table_name):
    df = pd.read_csv(file_path)
    if table_name == "dim_candidates":
        df = transform_candidates(df)
    elif table_name == "fact_attendance":
        df = transform_attendance(df)
    elif table_name == "fact_placements":
        df = transform_placements(df)
    df.to_sql(table_name, engine, if_exists='replace', index=False)
    print(f"✅ Loaded {file_path} → {table_name} with {len(df)} rows")

def main():
    load_csv_to_db("data/candidates.csv", "dim_candidates")
    load_csv_to_db("data/programs.csv", "dim_programs")
    load_csv_to_db("data/attendance.csv", "fact_attendance")
    load_csv_to_db("data/placements.csv", "fact_placements")

if __name__ == "__main__":
    main()
