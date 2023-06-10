import csv
from datetime import datetime, timedelta
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--personal_data", type=str, help="personal data file name")
parser.add_argument("--user_id", type=str, help="user ID")
args = parser.parse_args()
user_id = str(args.user_id)
personal_data = str(args.personal_data)
# Read the data from the CSV file
with open(personal_data, "r") as file:
    reader = csv.DictReader(file)
    data = list(reader)

# Create the parameters for each day
parameters = []
for i in range(len(data)):
    row = data[i]
    date = datetime.strptime(row["Date"], "%Y-%m-%d")
    day_of_week = row["Day of the Week"]
    weather = "Spring"  # You can update this based on the actual weather information for each day
    
    exercise_previous_day = None
    exercise_one_week_before = None
    exercise_two_weeks_before = None
    exercise_three_weeks_before = None
    
    # Get the exercise on the day before
    if i > 0:
        exercise_previous_day = data[i - 1]["Calories Burned"]
    
    # Get the exercise one week before (if possible)
    if i >= 7:
        exercise_one_week_before = data[i - 7]["Calories Burned"]
    
    # Get the exercise two weeks before (if possible)
    if i >= 14:
        exercise_two_weeks_before = data[i - 14]["Calories Burned"]
    
    # Get the exercise three weeks before (if possible)
    if i >= 21:
        exercise_three_weeks_before = data[i - 21]["Calories Burned"]
    
    # Calculate the output (calories burned)
    calories_burned = float(row["Calories Burned"])
    
    # Create the parameter dictionary for the current day
    parameter = {
        "Day of the Week": day_of_week,
        "Weather": weather,
        "Exercise Previous Day": exercise_previous_day,
        "Exercise One Week Before": exercise_one_week_before,
        "Exercise Two Weeks Before": exercise_two_weeks_before,
        "Exercise Three Weeks Before": exercise_three_weeks_before,
        "Calories Burned": calories_burned,
        "Exercise Set": row["Exercises"]
    }
    
    parameters.append(parameter)

# Write the parameters to a new CSV file
fieldnames = ["Day of the Week", "Weather", "Exercise Previous Day", "Exercise One Week Before",
              "Exercise Two Weeks Before", "Exercise Three Weeks Before", "Calories Burned", "Exercise Set"]

with open(str(user_id) + "_fitness_parameters.csv", "w", newline="") as file:
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(parameters)

print("Parameters saved to parameters.csv file.")
