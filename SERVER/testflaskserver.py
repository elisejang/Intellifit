import requests

# Set the base URL of the server
base_url = 'http://127.0.0.1:5000'  # Replace with the appropriate IP address and port number

user = '23o4kH2VsmkuFK6crobE' 

# Make a request to the mealRecommendation endpoint
target_calories = 2000  # Example input data
meal_endpoint = '/mealRecommendation'
meal_url = base_url + meal_endpoint
meal_payload = target_calories

meal_response = requests.post(meal_url, json=meal_payload)

# Process the response
if meal_response.status_code == 200:
    meal_recommendations = meal_response.json()
    print(meal_recommendations)
    # print('Meal Recommendations:')
    # for meal, nutrients in meal_recommendations.items():
    #     print(f'{meal}: {nutrients}')
else:
    print('Error occurred while making a request to mealRecommendation endpoint')

# Make a request to the cleanFit endpoint
# personal_data = [['Monday', 'Winter', 100, 120, 110, 105, 115, 125]]  # Example input data  # Example user ID
# clean_fit_endpoint = '/cleanFit'
# clean_fit_url = base_url + clean_fit_endpoint
# clean_fit_payload = str(user)

# clean_fit_response = requests.post(clean_fit_url, json=clean_fit_payload)

# # Process the response
# if clean_fit_response.status_code == 200:
#     print('Models trained successfully')
# else:
#     print('Error occurred while making a request to cleanFit endpoint')

# Make a request to the predictSleep endpoint
# sleep_data = 893  # Example input data
# sleep_endpoint = '/predictSleep'
# sleep_url = base_url + sleep_endpoint
# sleep_payload = sleep_data

# sleep_response = requests.post(sleep_url, json=sleep_payload)

# Process the response
# if sleep_response.status_code == 200:
#     sleep_prediction = sleep_response.json()['Sleep Prediction']
#     print(f'Sleep Prediction: {sleep_prediction}')
# else:
#     print('Error occurred while making a request to predictSleep endpoint')

# # Make a request to the predictActivity endpoint
# activity_data = [['Monday', 'Winter', 100, 120, 110, 105], '155lb_random']  # Example input data
# activity_endpoint = '/predictActivity'
# activity_url = base_url + activity_endpoint
# activity_payload = [str(user), "2023-06-08"]

# activity_response = requests.post(activity_url, json=activity_payload)

# # Process the response
# if activity_response.status_code == 200:
#     calorie_prediction = activity_response.json()['Calorie Burn Prediction']
#     print(f'Calorie Burn Prediction: {calorie_prediction}')
# else:
#     print('Error occurred while making a request to predictActivity endpoint')

# Make a request to the predictFitness endpoint
# fitness_data = [['Monday', 'Winter', 100, 120, 110, 105, 115], '155lb_random']  # Example input data
# fitness_endpoint = '/predictFitness'
# fitness_url = base_url + fitness_endpoint
# fitness_payload = [str(user), "2023-06-08"]

# fitness_response = requests.post(fitness_url, json=fitness_payload)

# # Process the response
# if fitness_response.status_code == 200:
#     workout_predictions = fitness_response.json()
#     print('Top 5 Predicted Workouts:')
#     for workout, probability in workout_predictions.items():
#         print(f'{workout}: {probability}')
# else:
#     print('Error occurred while making a request to predictFitness endpoint')

# cb_endpoint = '/calorieBurn'
# cb_url = base_url+ cb_endpoint
# cb_payload = ['"Weight lifting, body building, vigorous"', '2', '190']

# cb_response = requests.post(cb_url, json=cb_payload)

# Process the response
# if cb_response.status_code == 200:
#     cb_prediction = cb_response.json()
#     print('Calorie Burn from Workout:')
#     print(cb_prediction)
# else:
#     print('Error occurred while making a request to predictFitness endpoint')