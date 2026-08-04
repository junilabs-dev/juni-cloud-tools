import pandas as pd
import random
import uuid

# Define Technicians
technicians = [
    ["Name", "Email", "Phone", "Region"],
    ["Rahul Sharma", "rahul.sharma@examplebank.com", "9876543210", "North"],
    ["Priya Singh", "priya.singh@examplebank.com", "9876543211", "South"],
    ["Amit Patel", "amit.patel@examplebank.com", "9876543212", "East"],
    ["Sarah Connor", "sarah.connor@examplebank.com", "9876543213", "West"],
    ["John Doe", "john.doe@examplebank.com", "9876543214", "Central"]
]
tech_names = [t[0] for t in technicians[1:]]

# Define Symptoms and Categories mapping
symptoms_mapping = [
    ("ATM screen frozen", "Hardware Failure"),
    ("Card reader swallowed card", "Hardware Failure"),
    ("Cash dispenser not dispensing", "Dispenser Issues"),
    ("Dispensed incorrect amount", "Dispenser Issues"),
    ("Network timeout", "Connectivity"),
    ("Cannot connect to server", "Connectivity"),
    ("Receipt printer jammed", "Printing"),
    ("Receipt paper out", "Printing"),
    ("Keypad unresponsive", "General Issues")
]

# Create Symptoms list
symptoms_data = [["Symptom", "Category"]]
for s, c in symptoms_mapping:
    symptoms_data.append([s, c])

# Generate mock Tickets
tickets_data = [["Issue ID", "First Name", "Last Name", "ATM ID", "Email", "Symptom", "Photo", "Description", "Category", "Assigned To"]]

customers = [
    ("Aarav", "Kumar"), ("Vikram", "Singh"), ("Neha", "Gupta"), ("Rohan", "Mehta"),
    ("Kavya", "Joshi"), ("Michael", "Smith"), ("Emma", "Johnson"), ("Oliver", "Brown"),
    ("Sophia", "Davis"), ("Lucas", "Miller")
]

for _ in range(12):
    issue_id = uuid.uuid4().hex[:10]
    first, last = random.choice(customers)
    email = f"{first.lower()}.{last.lower()}@mockcustomer.com"
    atm_id = str(random.randint(10000, 99999))
    
    # Pick a random symptom
    symptom, category = random.choice(symptoms_mapping)
    desc = f"Customer reported {symptom.lower()} at branch."
    assigned = random.choice(tech_names)
    
    tickets_data.append([issue_id, first, last, atm_id, email, symptom, "", desc, category, assigned])

# Also add the qwiklabs student email as required by some lab steps for testing
tickets_data.append([
    uuid.uuid4().hex[:10], "quick", "lab", "ABC123", "student-01-mock@qwiklabs.net", 
    "Receipt paper out", "", "Lab testing ticket", "Printing", "Priya Singh"
])

df_tickets = pd.DataFrame(tickets_data[1:], columns=tickets_data[0])
df_technicians = pd.DataFrame(technicians[1:], columns=technicians[0])
df_symptoms = pd.DataFrame(symptoms_data[1:], columns=symptoms_data[0])

with pd.ExcelWriter('GSP1146.xlsx') as writer:
    df_tickets.to_excel(writer, sheet_name='Tickets', index=False)
    df_technicians.to_excel(writer, sheet_name='Technicians', index=False)
    df_symptoms.to_excel(writer, sheet_name='Symptoms', index=False)

print("Fresh GSP1146.xlsx created successfully with new mock data!")
