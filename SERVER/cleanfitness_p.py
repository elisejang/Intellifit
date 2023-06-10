import csv
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--user_id", type=str, help="User identification")
args = parser.parse_args()
user = args.user_id

input_file = str(user) + '_fitness_parameters.csv'
exercise_file = 'modified_workout_data.csv'
output_file = str(user) + '_indexed_workout_data.csv'

# Read the exercise list CSV file
with open(exercise_file, 'r') as file:
    csv_reader = csv.reader(file)
    next(csv_reader)  # Skip the header row
    exercise_list = [row[0].strip('""') for row in csv_reader]

# Read the input CSV file and perform indexing
with open(input_file, 'r') as file:
    csv_reader = csv.reader(file)
    header = next(csv_reader)  # Read the header row

    # Find the indices for exercise activities in the last column
    indexed_rows = []
    for row in csv_reader:
        exercise_set = row[-1]  # Get the Exercise Set column
        activities = exercise_set.split('", "')  # Split on '", "' instead of ', '
        indexed_activities = []
        for activity in activities:
            if activity:
                index = exercise_list.index(activity.strip('""'))
                indexed_activities.append(index)
        indexed_row = row[:-1] + [indexed_activities]
        indexed_rows.append(indexed_row)

# Write the indexed data to a new CSV file
with open(output_file, 'w', newline='') as file:
    csv_writer = csv.writer(file)
    csv_writer.writerow(header)
    csv_writer.writerows(indexed_rows)

print("Indexed workout data has been written to", output_file)
