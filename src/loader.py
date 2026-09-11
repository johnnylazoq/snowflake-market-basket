from pathlib import Path
from io import StringIO


def run_sql_file(conn, file_path: str):
    path = Path(file_path)
    sql_script = path.read_text()

    cursor = conn.cursor()
    try:
        # execute_stream cleanly runs multi-statement scripts in Snowflake
        for cur in conn.execute_stream(StringIO(sql_script)):
            for _ in cur:
                pass
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
