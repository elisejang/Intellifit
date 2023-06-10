from flask import Flask, request, jsonify
import torch
import pickle
import subprocess
import torch.nn as nn
from torch.utils.data import Dataset
import csv
import json
import onnxruntime
import numpy as np
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, timedelta

cred = credentials.Certificate('/Users/ryansmacbookpro/Downloads/SERVER/intellifit-firestore-firebase-adminsdk-bgckr-3209b6618d.json')
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
    month = current_date.month
    season = ""

    if (month == 12 and day >= 21) or (month <= 3 and day < 21):
        season = "Winter"
    elif month >= 3 and month < 6:
        season = "Spring"
    elif month >= 6 and month < 9:
        season =  "Summer"
    elif month >= 9 and month < 12:
        season = "Fall"

    # # Calculate the dates, starting from 3 weeks ago to yesterday
    # dates = [current_date - timedelta(weeks=i) for i in range(3, 0, -1)]
    # # Include yesterday's date
    # dates.append(current_date - timedelta(days=1))
    dates = [current_date - timedelta(days=i) for i in [21, 14, 7, 1]]

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
    current_exercise_data = [ex for ex in all_exercises_list if ex != {} and ex['date'].startswith(current_date_str)]

    print(f"DATA BEFORE APPENDING SEASON: {data}")
    current_season = season
    data.append(current_season)

    print(f"DATA AFTER APPENDING SEASON: {data}")
    
        

    # For each date, find the corresponding exercise entry and get the calories burnt
    for date in dates:
        # Format the date as a string
        date_str = date.strftime("%Y-%m-%d")

        # Filter all exercises for this date
        exercise_data = [ex for ex in all_exercises_list if ex != {} and ex['date'].startswith(date_str)]
        print(f"EXERCISE DATA: {exercise_data}")
        if exercise_data:
            sum = 0
            for ex in exercise_data:
                sum += ex['calories_burnt']
            
            print(sum)
            
            if sum != 0:
                data.append(sum)
            else:
                data.append(0)
        else:
            data.append(0)

    print(f"COMPLETE DATA: {data}")
    return [data, user_id]

# def get_calories_burnt2(user_id, date_string):
#     # Parse the date string to a datetime object
#     current_date = datetime.strptime(date_string, "%Y-%m-%d")

#     # Calculate the dates, starting from 3 weeks ago to yesterday
#     dates = [current_date - timedelta(weeks=i) for i in range(3, 0, -1)]
#     # Include yesterday's date
#     dates.append(current_date - timedelta(days=1))

#     # Fetch the user's data
#     _, user_ref = get_user_data(user_id)

#     # Fetch the user's exercise entries
#     exercises_ref = user_ref.collection(u'ExerciseEntries')

#     # Get all exercise entries
#     all_exercises = exercises_ref.stream()

#     # Convert to list of dictionaries
#     all_exercises_list = [ex.to_dict() for ex in all_exercises]

#     # Initialize the data list with the current date
#     data = [date_string]

#     # Retrieve and add the season of the current date to data
#     current_date_str = current_date.strftime("%Y-%m-%d")
#     current_exercise_data = [ex for ex in all_exercises_list if ex['date'].startswith(current_date_str)]
#     if current_exercise_data:
#         current_season = current_exercise_data[0]['season']
#         data.append(current_season)
#     else:
#         data.append(None)  # No exercise entry for the current date

#     # Initialize total calories burnt
#     total_calories_burnt = 0

#     # For each date, find the corresponding exercise entry and get the calories burnt
#     for date in dates:
#         # Format the date as a string
#         date_str = date.strftime("%Y-%m-%d")

#         # Filter all exercises for this date
#         exercise_data = [ex for ex in all_exercises_list if ex['date'].startswith(date_str)]

#         if exercise_data:
#             # Get the calories burnt
#             calories_burnt = exercise_data[0]['calories_burnt']
#             total_calories_burnt += calories_burnt
#             data.append(calories_burnt)
#         else:
#             data.append(None)  # No exercise entry for this date

#     # Add total calories burnt to data
#     data.append(total_calories_burnt)

#     return [data, user_id]

def get_calories_burnt2(user_id, date_string):
    # Parse the date string to a datetime object
    current_date = datetime.strptime(date_string, "%Y-%m-%d")
    month = current_date.month
    season = ""

    if (month == 12 and day >= 21) or (month <= 3 and day < 21):
        season = "Winter"
    elif month >= 3 and month < 6:
        season = "Spring"
    elif month >= 6 and month < 9:
        season =  "Summer"
    elif month >= 9 and month < 12:
        season = "Fall"

    # Calculate the dates, starting from 3 weeks ago to yesterday
    dates = [current_date - timedelta(weeks=i) for i in range(3, 0, -1)]
    # Include yesterday's date
    dates.append(current_date - timedelta(days=1))

    # Fetch the user's data
    _, user_ref = get_user_data(user_id)

    # Fetch the user's exercise entries
    exercises_ref = user_ref.collection(u'ExerciseEntries')

    prediction_ref = user_ref.collection(u'Predictions')

    # Get all exercise entries
    all_exercises = exercises_ref.stream()

    cal_pred = prediction_ref.stream()

    pred_list = [ex.to_dict() for ex in cal_pred]


    # Convert to list of dictionaries
    all_exercises_list = [ex.to_dict() for ex in all_exercises]
    total_calories_burnt = 0
    # Initialize the data list with the current date
    data = [date_string]

    # Retrieve and add the season of the current date to data
    current_date_str = current_date.strftime("%Y-%m-%d")
    current_exercise_data = [ex for ex in all_exercises_list if ex != {} and ex['date'].startswith(current_date_str)]
    
    data.append(season)
    pred_data = [ex for ex in pred_list if ex != {} and ex['date'].startswith(current_date_str)]
    if pred_data:
        total_calories_burnt = pred_data[0]['calorie_burn']
    # Initialize total calories burnt

    # For each date, find the corresponding exercise entry and get the calories burnt
    for date in dates:
        # Format the date as a string
        date_str = date.strftime("%Y-%m-%d")

        # Filter all exercises for this date
        exercise_data = [ex for ex in all_exercises_list if ex != {} and ex['date'].startswith(date_str)]
        print(f"EXERCISE DATA: {exercise_data}")
        if exercise_data:
            sum = 0
            for ex in exercise_data:
                sum += ex['calories_burnt']
            
            if sum != 0:
                data.append(sum)
            else:
                data.append(0)
        else:
            data.append(0)  # No exercise entry for this date

    # Add total calories burnt to data
    data.append(float(total_calories_burnt))

    return [data, user_id]

# def get_calories_burnt3(user_id, date_string):
#     # Parse the date string to a datetime object
#     current_date = datetime.strptime(date_string, "%Y-%m-%d")
#     month = current_date.month

#     season = ""

#     if (month == 12 and day >= 21) or (month <= 3 and day < 21):
#         season = "Winter"
#     elif month >= 3 and month < 6:
#         season = "Spring"
#     elif month >= 6 and month < 9:
#         season =  "Summer"
#     elif month >= 9 and month < 12:
#         season = "Fall"
    
    
#     # Calculate the dates, starting from 3 weeks ago to yesterday
#     dates = [current_date - timedelta(weeks=i) for i in range(3, 0, -1)]
#     # Include yesterday's date
#     dates.append(current_date - timedelta(days=1))

#     # Fetch the user's data
#     _, user_ref = get_user_data(user_id)

#     # Fetch the user's exercise entries
#     exercises_ref = user_ref.collection(u'ExerciseEntries')

#     # Get all exercise entries
#     all_exercises = exercises_ref.stream()

#     # Convert to list of dictionaries
#     all_exercises_list = [ex.to_dict() for ex in all_exercises]

#     # Initialize the data list with the current date
#     data = [date_string]

#     # Retrieve and add the season of the current date to data
#     current_date_str = current_date.strftime("%Y-%m-%d")

#     print(current_date_str)

#     current_exercise_data = [ex for ex in all_exercises_list if ex != {} and ex['date'].startswith(current_date_str)]
   
#     if current_exercise_data:
#         # current_season = current_exercise_data[0]['season']
#         current_season = season
        
#         data.append(current_season)
#     else:
#         data.append(None)  # No exercise entry for the current date

#     print(current_exercise_data)

#     # Initialize total calories burnt
#     total_calories_burnt = 0

#     # For each date, find the corresponding exercise entry and get the calories burnt
#     for date in dates:
#         # Format the date as a string
#         date_str = date.strftime("%Y-%m-%d")

#         # Filter all exercises for this date
#         exercise_data = [ex for ex in all_exercises_list if ex != {} and ex['date'].startswith(date_str)]
#         print(f"EXERCISE DATA: {exercise_data}")
#         if exercise_data:
#             # Get the calories burnt
#             calories_burnt = exercise_data[0]['calories_burnt']
#             total_calories_burnt += calories_burnt
#             data.append(calories_burnt)
#         else:
#             data.append(None)  # No exercise entry for this date

#     # Add total calories burnt to data
#     data.append(total_calories_burnt)

#     return [data, user_id]

def get_calories_burnt3(user_id, date_string):
    # Parse the date string to a datetime object
    current_date = datetime.strptime(date_string, "%Y-%m-%d")
    month = current_date.month

    season = ""

    if (month == 12 and day >= 21) or (month <= 3 and day < 21):
        season = "Winter"
    elif month >= 3 and month < 6:
        season = "Spring"
    elif month >= 6 and month < 9:
        season =  "Summer"
    elif month >= 9 and month < 12:
        season = "Fall"
    
    
    # Calculate the dates for exactly 21, 14, 7 and 1 day(s) ago
    dates = [current_date - timedelta(days=i) for i in [21, 14, 7, 1]]

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

    print(current_date_str)

    current_exercise_data = [ex for ex in all_exercises_list if ex != {} and ex['date'].startswith(current_date_str)]
   
    if current_exercise_data:
        current_season = season
        data.append(current_season)
    else:
        data.append(0)  # No exercise entry for the current date
    
    currCalorieSum = 0

    for ex in current_exercise_data:
        currCalorieSum += float(ex['calories_burnt'])


    print(current_exercise_data)

    # Initialize total calories burnt
    total_calories_burnt = 0

    # For each date, find the corresponding exercise entry and get the calories burnt
    for date in dates:
        # Format the date as a string
        date_str = date.strftime("%Y-%m-%d")

        # Filter all exercises for this date
        exercise_data = [ex for ex in all_exercises_list if ex != {} and ex['date'].startswith(date_str)]
        print(f"EXERCISE DATA: {exercise_data}")
        if exercise_data:
            sum = 0
            for ex in exercise_data:
                sum += ex['calories_burnt']
            
            if sum != 0:
                data.append(sum)
            else:
                data.append(0)
        else:
            data.append(0)  # No exercise entry for this date

    # Add total calories burnt to data
    data.append(currCalorieSum)

    print(data)
    
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
        print(ex)

        if (ex != {}):
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

app = Flask(__name__)

exercise_file = 'modified_workout_data.csv'
exercise_list = []

with open(exercise_file, 'r') as file:
    csv_reader = csv.reader(file)
    next(csv_reader)  # Skip the header row
    exercise_list = [row[0].strip('""') for row in csv_reader]

class CaloriePredictionModel(nn.Module):
    def __init__(self, input_size):
        super(CaloriePredictionModel, self).__init__()
        self.fc1 = nn.Linear(input_size, 64)
        self.fc2 = nn.Linear(64, 32)
        self.fc3 = nn.Linear(32, 1)

    def forward(self, x):
        x = x.to(torch.float32)  # Convert input to Float data type
        x = torch.relu(self.fc1(x))
        x = torch.relu(self.fc2(x))
        x = self.fc3(x)
        return x

class FitnessRecModel(nn.Module):
    def __init__(self, input_size):
        super(FitnessRecModel, self).__init__()
        self.fc1 = nn.Linear(input_size, 64)
        self.fc2 = nn.Linear(64, 32)
        self.fc3 = nn.Linear(32, 249)  # Assuming 249 workouts

    def forward(self, x):
        x = x.to(torch.float32)  # Convert input to Float data type
        x = torch.relu(self.fc1(x))
        x = torch.relu(self.fc2(x))
        x = self.fc3(x)
        return x
    
# custom dataset (if needed)
class CalorieDataset(Dataset):
    def __init__(self, data):
        self.data = data

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        return self.data[idx]




# Load the ONNX model
onnx_model_path = 'random_forest_model.onnx'
sess = onnxruntime.InferenceSession(onnx_model_path)

# # Example route for using ML model 1
# @app.route('/predictSleep', methods=['POST'])
# def predict1():
#     data = request.json

#     #DATA = CALORIE BURN PREDICTION

#     # Run inference on a single input
#     input_name = sess.get_inputs()[0].name
#     output_name = sess.get_outputs()[0].name

#     # Prepare the input data
#     input_data = {input_name: np.array([[float(data)]]).astype(np.float32)}

#     # Run the model to get predictions
#     prediction = sess.run([output_name], input_data)

#     response = {'Sleep Prediction': str(prediction)}

#     return jsonify(response)

@app.route('/predictSleep', methods=['POST'])
def predict1():
    data = request.json

    user = data['userId']
    date = data['date']

    user_data = get_calories_burnt3(str(user),  str(date))
    calories = float(user_data[0][6])
    print(f"USER DATA: {user_data}")
    print(calories)
    #DATA = CALORIE BURN PREDICTION

    # Run inference on a single input
    input_name = sess.get_inputs()[0].name
    output_name = sess.get_outputs()[0].name

    # Prepare the input data
    input_data = {input_name: np.array([[float(calories) + 1800]]).astype(np.float32)}

    # Run the model to get predictions
    prediction = sess.run([output_name], input_data)

    response = {'Sleep Prediction': str(prediction[0][0][0])}
    print(response)

    return jsonify(response)

@app.route('/predictActivity', methods=['POST'])
def predict2():
    data = request.json


   # data = [userid, date]
    print(f"DATA: {data}")
    user = data['userId']
    date = data['date']
    mdl_data = get_calories_burnt(str(user), str(date))
    activityModel = CaloriePredictionModel(6)
    activityModel.load_state_dict(torch.load(str(user) + '_calorie_model.pth'))
    activityModel.eval()

    model_data = mdl_data[0]
    print(f"MODEL DATA: {model_data}")


    date_obj = datetime.strptime(str(model_data[0]), "%Y-%m-%d")
    day_of_week = date_obj.strftime("%A")
    days_of_week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    weather_types = ["Spring", "Summer", "Autumn", "Winter"]
    numeric_day = [float(days_of_week.index(day_of_week))]
    numeric_weather = [float(weather_types.index(model_data[1]))]
    true_input = [numeric_day + numeric_weather + model_data[2:6]]
    user_input = torch.FloatTensor(true_input)
    prediction = activityModel(user_input)
    value = float(prediction.item())

    response = {'Calorie Burn Prediction': str(value)}
    print(response)

    return jsonify(response)

@app.route('/predictFitness', methods=['POST'])
def predict3():
    data = request.json

    # data = [userid, date]
    user = data['userId']
    date = data['date']
    mdl_data = get_calories_burnt2(str(user),  str(date))
    fitnessModel = FitnessRecModel(7)
    fitnessModel.load_state_dict(torch.load(str(user) + "_fitness_model.pth"))
    fitnessModel.eval()
    model_data = mdl_data[0]
    print(model_data)
    date_obj = datetime.strptime(str(model_data[0]), "%Y-%m-%d")
    day_of_week = date_obj.strftime("%A")
    days_of_week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    weather_types = ["Spring", "Summer", "Autumn", "Winter"]
    numeric_day = [float(days_of_week.index(day_of_week))]
    numeric_weather = [float(weather_types.index(model_data[1]))]
    true_input = [numeric_day + numeric_weather + model_data[2:7]]

    user_input = torch.FloatTensor(true_input)
    prediction = fitnessModel(user_input)
    predicted_index = torch.argmax(prediction)  
    probabilities = torch.softmax(prediction, dim=1)
    top_5_probs, top_5_indices = torch.topk(probabilities, k=5)

    # Get the names of the top 5 predicted workouts
    workout_names = [exercise_list[index] for index in top_5_indices.squeeze()] 
    response = {}
    for i, (name, prob) in enumerate(zip(workout_names, top_5_probs.squeeze()), 1):
        response[str(name)] = str(prob.item())

    print(f"JSONIFIED RESPONSE: {jsonify(response)}")
    print(f"REGULAR RESPONSE {response}")

    return jsonify(response)

# @app.route('/mealRecommendation', methods=['POST'])
# def script1():
#     data = request.json


#     # data = target_calories


#     command = ['python', 'spoonacular_mealplan.py', '--target_calories', str(data)]
#     outputs = subprocess.check_output(command, universal_newlines=True)

#     dct = eval(outputs)

#     response = {}
#     for option in dct:  
#         nutrients = [option['calories']] + [option['fat']] + [option['protein']] + [option['carbs']]
#         response[str(option['name'])] = str(nutrients)


#     return jsonify(response)

@app.route('/mealRecommendation', methods=['POST'])
def script1():
    data = request.json

    user = data['userId']
    date = data['date']
    goal = data['goal']
    # data = target_calories

    user_data = get_calories_burnt3(str(user),  str(date))
    print(user_data)
    calories = float(user_data[0][6])
    print(f"CALORIES: {calories}")


    if goal == "Gain Weight":
        calories = calories + 1800 + 200
    else:
        calories = calories + 1800 - 200

    command = ['python', 'spoonacular_mealplan.py', '--target_calories', str(calories)]
    outputs = subprocess.check_output(command, universal_newlines=True)

    dct = eval(outputs)

    response = {}
    for option in dct:
        nutrients = [option['calories']] + [option['fat']] + [option['protein']] + [option['carbs']]
        response[str(option['name'])] = str(nutrients)

    print(response)
    return jsonify(response)

@app.route('/cleanFit', methods=['POST'])
def script2():
    data = request.json
    print(data)

    #data = userid
    user = data['userId']
    print(user)
    cal_data = get_exercise_entries(str(user))
    personalData = str(user) + "_sample.csv"
    with open(personalData, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerows(cal_data)

    fit_param= ['python', 'calculate_fitness.py','--personal_data', str(personalData), '--user_id', str(user)]
    subprocess.run(fit_param)

    clean_fit = ['python', 'cleanfitness_p.py', '--user_id', str(user)]
    subprocess.run(clean_fit)

    act_param= ['python', 'calculate_parameters.py', '--personal_data', str(personalData),'--user_id', str(user)]
    subprocess.run(act_param)

    trn_fit = ['python', 'ft_rec_model.py', '--user_id', str(user)]
    subprocess.run(trn_fit)

    act_fit = ['python', 'ft_model.py', '--user_id', str(user)]
    subprocess.run(act_fit)

    response = {'message': 'MODELS ALL TRAINED'}

    return jsonify(response)

@app.route('/calorieBurn', methods=['POST'])
def calBurn():
    data = request.json
    print(data)
    #data = [Workout Name, Num Hours, User Weight]

    workout_name = data["exerciseName"]
    hrs = data['duration']
    user_weight = data['weight']
    cal_burn = 0

    with open(exercise_file, 'r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)  # Skip the header row
        for row in csv_reader:
            cur_workout = str(row[0])
            print(cur_workout)
            print(workout_name)
            if cur_workout == str(workout_name):
                cal_kg = float(row[5])
                kilograms_to_pounds = 2.20462
                cal_lb = cal_kg * (1 / kilograms_to_pounds)
                cal_burn = cal_lb * float(user_weight) * float(hrs)
                break

    response = {'Calories Burned from Workout': str(cal_burn)}

    return jsonify(response)

if __name__ == '__main__':
    app.run()
