import pandas as pd
import os

data_tickets = [
    ["Issue ID", "First Name", "Last Name", "ATM ID", "Email", "Symptom", "Photo", "Description", "Category", "Assigned To"],
    ["0d5ff8cd8d", "Fredrick", "Thompson", "33562", "fredrick.thompson@fakeitcompany.com", "ATM wont turn on", "", "ATM screen is black", "General Issues", "Shelley Gomez"],
    ["d9c1547599", "Patsy", "Sheehan", "66722", "patsy.sheehan@fakeitcompany.com", "Card reader not working", "", "The ATM is not recognizing cards", "General Issues", "Justin Sato"],
    ["e0cb653f42", "Jon", "Snow", "3351", "jon.snow@fakeitcompany.com", "Broken keypad", "", "The 2 on the keypad isn't working", "General Issues", "Shelley Gomez"],
    ["94803beda8", "Alexander", "Ramos", "37490", "alexander.ramos@fakeitcompany.com", "Low cash supply", "", "ATM dispensed 2 $10 bills, instead of 1 $20 bill", "Cash Dispenser", "Miles Barnes"],
    ["da18217bc3", "Verna", "Moore", "77827", "verna.moore@fakeitcompany.com", "Cash dispenser jam", "", "Cash is stuck", "Cash Dispenser", "Miles Barnes"],
    ["d146f1ccc1", "Megan", "Iverson", "51428", "megan.iverson@fakeitcompany.com", "Connection error", "", "Cannot connect to bank's network", "Connection error", "Nia Jones"],
    ["045dbe3b7b", "Paul", "Edson", "16252", "paul.edson@fakeitcompany.com", "Not listed", "", "ATM is not recognizing a correct PIN", "General Issues", "Justin Sato"],
    ["d9d1df320a", "Danielle", "West", "98308", "danielle.west@fakeitcompany.com", "Receipt printer out of paper", "", "Receipt didn't print", "Receipts", "Jean Clark"],
    ["JTXhApOb", "Alexander", "Ramos", "37490", "alexander.ramos@fakeitcompany.com", "Receipt printer out of ink", "", "Receipt printed blank", "Receipts", "Jean Clark"],
    ["23a5558b", "quick", "lab", "ABC123", "student-01-41527e028127@qwiklabs.net", "Card reader not working", "", "", "General Issues", "Shelley Gomez"],
    ["ac7aa33f", "Freeda", "", "Freeda123", "", "Receipt printer out of ink", "", "", "Receipts", "Jean Clark"]
]

data_technicians = [
    ["Name", "Email", "Phone", "Region"],
    ["Shelley Gomez", "shelley.gomez@fakeitcompany.com", "555-0101", "North"],
    ["Justin Sato", "justin.sato@fakeitcompany.com", "555-0102", "South"],
    ["Miles Barnes", "miles.barnes@fakeitcompany.com", "555-0103", "East"],
    ["Nia Jones", "nia.jones@fakeitcompany.com", "555-0104", "West"],
    ["Jean Clark", "jean.clark@fakeitcompany.com", "555-0105", "Central"]
]

data_symptoms = [
    ["Symptom", "Category"],
    ["ATM wont turn on", "General Issues"],
    ["Card reader not working", "General Issues"],
    ["Broken keypad", "General Issues"],
    ["Low cash supply", "Cash Dispenser"],
    ["Cash dispenser jam", "Cash Dispenser"],
    ["Connection error", "Connection error"],
    ["Not listed", "General Issues"],
    ["Receipt printer out of paper", "Receipts"],
    ["Receipt printer out of ink", "Receipts"]
]

df_tickets = pd.DataFrame(data_tickets[1:], columns=data_tickets[0])
df_technicians = pd.DataFrame(data_technicians[1:], columns=data_technicians[0])
df_symptoms = pd.DataFrame(data_symptoms[1:], columns=data_symptoms[0])

with pd.ExcelWriter('GSP1146.xlsx') as writer:
    df_tickets.to_excel(writer, sheet_name='Tickets', index=False)
    df_technicians.to_excel(writer, sheet_name='Technicians', index=False)
    df_symptoms.to_excel(writer, sheet_name='Symptoms', index=False)

print("GSP1146.xlsx reverted to exact screenshot copy successfully!")
