# Youth Employment Tracker

A comprehensive ETL pipeline for tracking and analyzing youth employment programs, built with automated data processing and visualization capabilities.

## 🚀 Features

- **Automated ETL Pipeline**: Python + Pandas + SQLAlchemy for data processing
- **Scheduled Processing**: Airflow DAG for daily ETL automation
- **Data Warehouse**: PostgreSQL with optimized star schema design
- **Ready-to-Use Views**: Pre-built SQL views for instant dashboard creation
- **Multiple BI Support**: Works with Power BI, Metabase, Tableau, and other tools
- **Containerized Setup**: Full Docker-based deployment for easy setup

## 📁 Project Structure

```
youth-employment-tracker/
├── dags/                   # Airflow DAGs & ETL scripts
│   └── etl.py
├── data/                   # Sample CSV data
│   ├── candidates.csv
│   ├── programs.csv
│   ├── attendance.csv
│   └── placements.csv
├── sql/                    # SQL scripts for schema & views
│   ├── ddl_star_schema.sql
│   └── views.sql
├── docs/
├── requirements.txt
├── docker-compose.yml
├── .env
└── README.md
```

## 🛠️ Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & Docker Compose
- [Git](https://git-scm.com/downloads)
- Optional: Power BI or preferred BI tool

## ⚡ Quick Setup

### 1. Clone the Repository
```bash
git clone https://github.com/Thabo-Tshabalala/youth-employment-tracker
cd capaciti-etl-poc
```

### 2. Configure Environment
Create a `.env` file in the root directory: ?? No need, Exposed it for ya🥲
```env
DB_URI=postgresql://postgres:postgres@localhost:5432/capaciti
```

### 3. Start Services
```bash
docker compose up -d
```

This will start three containers:
- **capaciti-postgres** → PostgreSQL database
- **capaciti-airflow** → Airflow scheduler/webserver
- **capaciti-metabase** → Metabase dashboard

### 4. Initialize Database
The database schema and views are automatically created on startup. To verify:

```bash
docker exec -it capaciti-postgres psql -U postgres -d capaciti
```

```sql
\dt    -- Check tables
\dv    -- Check views
```

### 5. Load Sample Data (Optional)
```bash
docker exec -it capaciti-airflow bash
python /opt/airflow/dags/etl.py
```

## 📊 Services & Access

### Airflow (ETL Orchestration)
- **URL**: http://localhost:8080
- **Username**: admin  
- **Password**: Check logs for generated password
  ```bash
  docker compose logs airflow | grep password
  ```
- **DAG**: `capaciti_etl_daily` - Runs automatically daily, can be triggered manually

### Metabase (Built-in Dashboards)
- **URL**: http://localhost:3000
- **Database Connection**:
  - Host: `postgres`
  - Port: `5432`
  - Database: `capaciti`
  - Username: `postgres`
  - Password: `postgres`

### PostgreSQL Database
- **Host**: localhost:5432
- **Database**: capaciti
- **Credentials**: postgres/postgres

## 📈 Dashboard & Analytics

### Pre-built Views
The system includes ready-to-use SQL views for common analytics:

- **Placement Rates by Province**
- **Attendance Tracking & Averages**  
- **Cohort Performance Metrics**
- **Program Effectiveness Analysis**

### BI Tool Integration
Connect any BI tool using the PostgreSQL credentials above:

**Power BI Setup:**
1. Get Data → PostgreSQL database
2. Server: localhost:5432
3. Database: capaciti
4. Load views from `sql/views.sql`

**Other Tools:** Tableau, Looker, etc. can connect the same way.

## 🔍 Data Verification

Check that your data loaded correctly:

```sql
-- Sample queries to verify data
SELECT * FROM dim_candidates LIMIT 5;
SELECT * FROM fact_attendance LIMIT 5;
SELECT * FROM fact_placements LIMIT 5;

-- Quick analytics
SELECT 
  province,
  COUNT(*) as total_candidates,
  AVG(CASE WHEN placement_status = 'Placed' THEN 1.0 ELSE 0.0 END) as placement_rate
FROM dim_candidates c
JOIN fact_placements p ON c.candidate_id = p.candidate_id
GROUP BY province;
```

## 🔧 Customization

### Adding New Data Sources
1. Add CSV files to the `data/` directory
2. Update `dags/etl.py` to include new data processing
3. Modify `sql/ddl_star_schema.sql` if schema changes are needed

### Custom Views
Edit `sql/views.sql` to add your own analytical views:

```sql
-- Example: Custom view for monthly placement trends
CREATE VIEW monthly_placement_trends AS
SELECT 
  DATE_TRUNC('month', placement_date) as month,
  COUNT(*) as placements,
  AVG(salary) as avg_salary
FROM fact_placements
WHERE placement_status = 'Placed'
GROUP BY DATE_TRUNC('month', placement_date)
ORDER BY month;
```

## 🚨 Troubleshooting

### Services Not Starting
```bash
# Check service status
docker compose ps

# View logs
docker compose logs [service-name]
```

exec -it capaciti-postgres psql -U postgres -d capaciti -c "SELECT 1;"
```

### ETL Failures
```bash
# Check Airflow logs
docker compose logs airflow

# Manual ETL run for debugging
docker exec -it capaciti-airflow python /opt/airflow/dags/etl.py
```

-- Btw Power BI can also use these views directly

