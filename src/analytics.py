import pandas as pd


def get_market_basket_results(conn) -> pd.DataFrame:
    query = "SELECT * FROM retail_vault.information_mart.vw_market_basket_pairs ORDER BY co_occurrence_count DESC;"
    cursor = conn.cursor()
    try:
        cursor.execute(query)
        # Snowflake Connector's native zero-copy Arrow conversion:
        return cursor.fetch_pandas_all()
    finally:
        cursor.close()
