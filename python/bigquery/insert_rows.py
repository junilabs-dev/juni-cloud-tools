from google.cloud import bigquery

def insert_rows(table_id):
    # table_id = "your-project.your_dataset.your_table"
    client = bigquery.Client()

    rows_to_insert = [
        {"full_name": "Phred Phlyntstone", "age": 32},
        {"full_name": "Wylma Phlyntstone", "age": 29},
    ]

    errors = client.insert_rows_json(table_id, rows_to_insert)  
    if errors == []:
        print("New rows have been added.")
    else:
        print(f"Encountered errors while inserting rows: {errors}")

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python insert_rows.py <table_id>")
    else:
        insert_rows(sys.argv[1])
