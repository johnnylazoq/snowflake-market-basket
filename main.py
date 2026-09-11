from src.db import get_connection
from src.loader import run_sql_file, load_staging_data
from src.analytics import get_market_basket_results

sample_data = [
    ("ORD-101", "PROD-APPLE", 2, 12.50),
    ("ORD-101", "PROD-BANANA", 1, 8.00),
    ("ORD-101", "PROD-MILK", 1, 15.00),
    ("ORD-102", "PROD-APPLE", 4, 12.50),
    ("ORD-102", "PROD-BANANA", 2, 8.00),
    ("ORD-103", "PROD-MILK", 1, 15.00),
    ("ORD-103", "PROD-APPLE", 1, 12.50),
]


def main():
    conn = get_connection()
    try:
        print("1/4 Sätter upp scheman...")
        run_sql_file(conn, "sql/01_setup_schemas.sql")

        print("2/4 Bygger DDL för Raw Vault...")
        run_sql_file(conn, "sql/02_raw_vault_ddl.sql")

        print("3/4 Laddar staging och populär Vault...")
        load_staging_data(conn, sample_data)
        run_sql_file(conn, "sql/04_load_raw_vault.sql")
        run_sql_file(conn, "sql/05_information_mart.sql")

        print("4/4 Hämtar analysresultat:\n")
        df = get_market_basket_results(conn)
        print(df.to_markdown(index=False))

    finally:
        conn.close()


if __name__ == "__main__":
    main()
