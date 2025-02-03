import os
import psycopg2
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Database connection parameters from environment variables
DB_PARAMS = {
    'dbname': os.getenv('DB_NAME'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

def execute_queries():
    # List of queries with descriptive labels
    queries = [
        {
            'label': 'Citizens with land area > 1.00',
            'query': """
                SELECT c.name
                FROM citizens AS c
                JOIN land_records AS l ON c.citizen_id = l.citizen_id
                WHERE l.land_area > 1.00;
            """
        },
        {
            'label': 'Female students from low-income households',
            'query': """
                SELECT c1.name
                FROM citizens AS c1                                         
                JOIN households AS h ON c1.household_id = h.household_id
                WHERE c1.gender = 'Female'
                AND c1.is_student = TRUE
                AND                
                ( SELECT SUM(c2.income)
                FROM citizens AS c2
                WHERE c2.household_id = h.household_id
                )                      
                < 100000;
            """
        },
        {
            'label': 'Total rice cultivation area',
            'query': """
                SELECT SUM(land_area)
                FROM land_records
                WHERE crop_type ILIKE 'rice';
            """
        },
        {
            'label': 'Young citizens with 10th education',
            'query': """
                SELECT COUNT(*)
                FROM citizens
                WHERE dob > '2000-01-01'
                AND education ILIKE '10th';
            """
        },
        {
            'label': 'Panchayat employees with land > 1.00',
            'query': """
                SELECT c.name
                FROM citizens AS c
                JOIN panchayat_employees AS p ON c.citizen_id = p.citizen_id
                JOIN land_records AS l ON p.citizen_id = l.citizen_id
                WHERE l.land_area > 1.00;
            """
        },
        {
            'label': 'Household members of Pradhans',
            'query': """
                SELECT c1.name        
                FROM citizens AS c1
                JOIN households AS h ON h.household_id = c1.household_id
                JOIN citizens AS c2 ON c2.household_id = h.household_id
                JOIN panchayat_employees AS p ON p.citizen_id = c2.citizen_id
                WHERE p.role ILIKE 'Pradhan';
            """
        },
        {
            'label': 'Street lights in Phulera installed in 2024',
            'query': """
                SELECT COUNT(*)
                FROM assets
                WHERE type ILIKE 'Street Light'
                AND location ILIKE 'Phulera'
                AND EXTRACT(YEAR FROM installation_date) = 2024;
            """
        },
        {
            'label': 'Vaccinations in 2024 for children of 10th pass parents',
            'query': """
                SELECT COUNT(*)
                FROM vaccinations AS v
                JOIN citizens as c1 ON v.citizen_id = c1.citizen_id
                JOIN citizens AS c2 ON c1.parent_id = c2.citizen_id
                WHERE EXTRACT(YEAR FROM v.date_administered) = 2024
                AND c2.education ILIKE '10th';
            """
        },
        {
            'label': 'Male births in 2024',
            'query': """
                SELECT COUNT(*) from citizens
                WHERE gender = 'Male'
                AND EXTRACT(YEAR FROM dob) = 2024;
            """
        },
        {
            'label': 'Unique citizens in households with panchayat employees',
            'query': """
                SELECT COUNT(DISTINCT c1.citizen_id)        
                FROM citizens AS c1
                JOIN households AS h ON h.household_id = c1.household_id
                JOIN citizens AS c2 ON c2.household_id = h.household_id
                JOIN panchayat_employees AS p ON p.citizen_id = c2.citizen_id;
            """
        }
    ]

    try:
        # Establish database connection
        conn = psycopg2.connect(**DB_PARAMS)
        cur = conn.cursor()
        
        # Execute each query and print results
        for query_info in queries:
            print(f"\n=== {query_info['label']} ===")
            cur.execute(query_info['query'])
            results = cur.fetchall()
            
            # Print results in a formatted way
            if results:
                if len(results[0]) == 1:  # Single column result
                    if len(results) == 1:  # Single row
                        print(f"Result: {results[0][0]}")
                    else:
                        for row in results:
                            print(row[0])
                else:  # Multiple columns
                    for row in results:
                        print(row)
            else:
                print("No results found")
                
    except psycopg2.Error as e:
        print(f"Database error: {e}")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if 'cur' in locals():
            cur.close()
        if 'conn' in locals():
            conn.close()

if __name__ == "__main__":
    execute_queries()