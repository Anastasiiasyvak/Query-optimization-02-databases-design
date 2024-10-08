import mysql.connector
import uuid
from faker import Faker
from dotenv import load_dotenv
import random
from datetime import datetime, timedelta
import os

# Load environment variables
load_dotenv()

# Connection settings
HOST = os.getenv('host')
USER = os.getenv('user')
PASSWORD = os.getenv('password')
DATABASE = os.getenv('database')


# Connect to the MySQL database
connection = mysql.connector.connect(
    host=HOST,
    user=USER,
    password=PASSWORD,
    database=DATABASE
)

cursor = connection.cursor()
fake = Faker()

# Insert 100,000 rows into restaurant_clients
print("Inserting into restaurant_clients...")
client_insert_query = """
    INSERT INTO restaurant_clients (client_id, name, surname, email, phone, address, status) 
    VALUES (%s, %s, %s, %s, %s, %s, %s)
"""
client_statuses = ['new', 'regular', 'vip']
clients_data = [
    (str(uuid.uuid4()), fake.first_name(), fake.last_name(), fake.email(), fake.phone_number(), fake.address(), random.choice(client_statuses))
    for _ in range(100000)
]
cursor.executemany(client_insert_query, clients_data)
connection.commit()
print("Inserted into restaurant_clients.")

# Insert 10,000 rows into restaurant_tables
print("Inserting into restaurant_tables...")
table_insert_query = """
    INSERT INTO restaurant_tables (table_number, capacity, location, status) 
    VALUES (%s, %s, %s, %s)
"""
table_locations = ['main_hall', 'terrace', 'vip_zone']
table_statuses = ['available', 'reserved']
tables_data = [
    (i + 1, random.randint(1, 20), random.choice(table_locations), random.choice(table_statuses))
    for i in range(10000)
]
cursor.executemany(table_insert_query, tables_data)
connection.commit()
print("Inserted into restaurant_tables.")

# Insert 1,000,000 rows into restaurant_reservations
print("Inserting into restaurant_reservations...")
reservation_insert_query = """
    INSERT INTO restaurant_reservations (reservation_date, reservation_time, client_id, table_id, guests_count, status) 
    VALUES (%s, %s, %s, %s, %s, %s)
"""
reservation_statuses = ['confirmed', 'canceled', 'pending']
reservation_date_start = datetime.now() - timedelta(days=365 * 5)
reservations_data = [
    (reservation_date_start + timedelta(days=random.randint(0, 365 * 5)),
     fake.time(),
     random.choice(clients_data)[0],
     random.randint(1, 10000),
     random.randint(1, 20),
     random.choice(reservation_statuses))
    for _ in range(1000000)
]
# Use chunks to avoid memory issues
chunk_size = 10000
for i in range(0, len(reservations_data), chunk_size):
    cursor.executemany(reservation_insert_query, reservations_data[i:i + chunk_size])
    connection.commit()
    print(f"Inserted {i + chunk_size} rows into restaurant_reservations...")

print("Inserted into restaurant_reservations.")

# Close the cursor and connection
cursor.close()
connection.close()
