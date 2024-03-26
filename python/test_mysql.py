#!/usr/bin/env python3

import sys
import mysql.connector

def run_query(query):
# MySQL connection parameters
    db_config = {
        'host': '188.40.173.6',
        'user': 'fenixdev',
        'password': 'hngAK9R5',
        'database': 'fenixdev'
    }

    # Connect to MySQL server
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        # Execute query
        cursor.execute(query)

        # Fetch results
        rows = cursor.fetchall()
        for row in rows:
            print(row)

    except mysql.connector.Error as error:
        print("Error:", error)

    finally:
        # Close connection
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python mysql_query.py 'SQL_QUERY'")
        sys.exit(1)

    query = sys.argv[1]
    run_query(query)
