import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, timedelta

# Use a service account
cred = credentials.Certificate('E:\intelliFit\SERVER\intellifit-firestore-firebase-adminsdk-bgckr-3209b6618d.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

def get_user_data(user_id):
    user_ref = db.collection(u'Users').document(user_id)
    user_doc = user_ref.get()
    user_data = user_doc.to_dict()
    return user_data, user_ref

# this function returns data = [Workout Name, Num Hours, User Weight] for ALL exercises in a user's ExerciseEntries subcollection
def get_data1(user_id):
    user_data, user_ref = get_user_data(user_id)
    user_weight = user_data['weight']
    
    # Fetch the user's exercise entries
    exercises_ref = user_ref.collection(u'ExerciseEntries')
    exercises_docs = exercises_ref.stream()

    # Prepare data as per the requested format
    data1 = []

    for doc in exercises_docs:
        exercise_data = doc.to_dict()
        workout_name = exercise_data['exercise']
        num_hours = exercise_data['hours']
        data1.append([workout_name, num_hours, user_weight])
    
    return data1

# this function returns all the exercise entries; here is an example and feel free to run the code; there are already test print statements made: [[{'calories_burnt': 225.3, 'date': '2023-06-07, Wednesday', 'hours': 2, 'exercise': '"Weight lifting, body building, vigorous"', 'season': 'Spring'}]]
def get_data2(user_id):
    user_data, user_ref = get_user_data(user_id)

    # Fetch the user's exercise entries
    exercises_ref = user_ref.collection(u'ExerciseEntries')
    exercises_docs = exercises_ref.stream()

    # Prepare data as per the requested format
    data2 = []

    for doc in exercises_docs:
        exercise_data = doc.to_dict()
        data2.append(exercise_data)
    
    return [data2, user_id]

# this function returns data = [['Day of the week', 'Season', 'cb 3 wk ago', 'cb 2 wk ago', 'cb 1 wk ago', 'cb yesterday'], 'user_id']
def get_calories_burnt(user_id, date_string):
    # Parse the date string to a datetime object
    current_date = datetime.strptime(date_string, "%Y-%m-%d")

    # Calculate the dates, starting from 3 weeks ago to yesterday
    dates = [current_date - timedelta(weeks=i) for i in range(3, 0, -1)]
    # Include yesterday's date
    dates.append(current_date - timedelta(days=1))

    # Fetch the user's data
    _, user_ref = get_user_data(user_id)

    # Fetch the user's exercise entries
    exercises_ref = user_ref.collection(u'ExerciseEntries')

    # Get all exercise entries
    all_exercises = exercises_ref.stream()

    # Convert to list of dictionaries
    all_exercises_list = [ex.to_dict() for ex in all_exercises]

    # Initialize the data list with the current date
    data = [date_string]

    # Retrieve and add the season of the current date to data
    current_date_str = current_date.strftime("%Y-%m-%d")
    current_exercise_data = [ex for ex in all_exercises_list if ex['date'].startswith(current_date_str)]
    if current_exercise_data:
        current_season = current_exercise_data[0]['season']
        data.append(current_season)
    else:
        data.append(None)  # No exercise entry for the current date

    # For each date, find the corresponding exercise entry and get the calories burnt
    for date in dates:
        # Format the date as a string
        date_str = date.strftime("%Y-%m-%d")

        # Filter all exercises for this date
        exercise_data = [ex for ex in all_exercises_list if ex['date'].startswith(date_str)]

        if exercise_data:
            # Get the calories burnt
            calories_burnt = exercise_data[0]['calories_burnt']
            data.append(calories_burnt)
        else:
            data.append(None)  # No exercise entry for this date

    return [data, user_id]

def get_calories_burnt2(user_id, date_string):
    # Parse the date string to a datetime object
    current_date = datetime.strptime(date_string, "%Y-%m-%d")

    # Calculate the dates, starting from 3 weeks ago to yesterday
    dates = [current_date - timedelta(weeks=i) for i in range(3, 0, -1)]
    # Include yesterday's date
    dates.append(current_date - timedelta(days=1))

    # Fetch the user's data
    _, user_ref = get_user_data(user_id)

    # Fetch the user's exercise entries
    exercises_ref = user_ref.collection(u'ExerciseEntries')

    # Get all exercise entries
    all_exercises = exercises_ref.stream()

    # Convert to list of dictionaries
    all_exercises_list = [ex.to_dict() for ex in all_exercises]

    # Initialize the data list with the current date
    data = [date_string]

    # Retrieve and add the season of the current date to data
    current_date_str = current_date.strftime("%Y-%m-%d")
    current_exercise_data = [ex for ex in all_exercises_list if ex['date'].startswith(current_date_str)]
    if current_exercise_data:
        current_season = current_exercise_data[0]['season']
        data.append(current_season)
    else:
        data.append(None)  # No exercise entry for the current date

    # Initialize total calories burnt
    total_calories_burnt = 0

    # For each date, find the corresponding exercise entry and get the calories burnt
    for date in dates:
        # Format the date as a string
        date_str = date.strftime("%Y-%m-%d")

        # Filter all exercises for this date
        exercise_data = [ex for ex in all_exercises_list if ex['date'].startswith(date_str)]

        if exercise_data:
            # Get the calories burnt
            calories_burnt = exercise_data[0]['calories_burnt']
            total_calories_burnt += calories_burnt
            data.append(calories_burnt)
        else:
            data.append(None)  # No exercise entry for this date

    # Add total calories burnt to data
    data.append(total_calories_burnt)

    return [data, user_id]



def get_exercise_entries(user_id):
    # Fetch the user's data
    _, user_ref = get_user_data(user_id)

    # Fetch the user's exercise entries
    exercises_ref = user_ref.collection(u'ExerciseEntries')

    # Get all exercise entries
    all_exercises = exercises_ref.stream()

    # Convert to list of dictionaries
    all_exercises_list = [ex.to_dict() for ex in all_exercises]

    # Prepare the final list of entries
    entries = []

    for ex in all_exercises_list:
        # Convert the 'date' string to a datetime object
        date_object = datetime.strptime(ex['date'].split(",")[0], "%Y-%m-%d")
        # Format the date string
        date_string = date_object.strftime("%Y-%m-%d")
        # Get the day of the week
        day_of_week = date_object.strftime("%A")
        # Get the exercise
        exercise = ex['exercise']
        # Get the calories burnt
        calories_burnt = ex['calories_burnt']

        # Add the entry to the list
        entries.append([date_string, day_of_week, exercise, calories_burnt])
    
    # Add the header list at the beginning of entries
    entries.insert(0, ["Date", "Day of the Week", "Exercises", "Calories Burned"])

    return entries





# Get user's ID, replace '23o4kH2VsmkuFK6crobE' with the actual user ID
user_id = '23o4kH2VsmkuFK6crobE' 

# Print the data
print('Data 1:', get_data1(user_id))
print('Data 2:', get_data2(user_id))
print('Data 3:', get_calories_burnt(user_id, "2023-06-08"))
print('Data 4:', get_calories_burnt2(user_id, "2023-06-08"))
print('Data 5:', get_exercise_entries(user_id))



