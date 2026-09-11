"""Runs SQL-files and batc-loads"""

from pathlib import Path


def run_sql_file(conn, file_path: str):
    path = Path(file_path)
    sql_script = path.read_text()

    # Kör varje SQL-statement separat
    cursor = conn.cursor()
    try:
        for statement in sql_script.split(";"):
            stmt = statement.strip()
            if stmt:
                cursor.execute(stmt)
    finally:
        cursor.close()


def load_staging_data(conn, transactions: list[tuple]):
    cursor = conn.cursor()
    try:
        cursor.execute("USE DATABASE retail_vault;")
        cursor.execute("""
            CREATE OR REPLACE TEMPORARY TABLE stage_transactions (
                order_id VARCHAR(50),
                product_id VARCHAR(50),
                quantity INT,
                price NUMBER(10,2)
            );
        """)
        cursor.executemany(
            "INSERT INTO stage_transactions VALUES (%s, %s, %s, %s);", transactions
        )
    finally:
        cursor.close()
