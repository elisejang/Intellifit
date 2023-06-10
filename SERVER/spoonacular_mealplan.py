import requests
import argparse

# Spoonacular API credentials
API_KEY = '1165d38b5ebc4dd9be7a29c0b0302c61'

def get_meal_options(target_calories, filters=None):
    url = "https://api.spoonacular.com/mealplanner/generate"

    params = {
        "apiKey": API_KEY,
        "targetCalories": target_calories,
        "timeFrame": "day"
    }

    response = requests.get(url, params=params)

    if response.status_code == 200:
        data = response.json()
        meals = []
        plan_option = {}
        for result in data["meals"]:
            recipe = result['title']
            meals.append(recipe)
        nutrients = data["nutrients"]
        calories = nutrients['calories']
        fat = nutrients['fat']
        protein = nutrients['protein']
        carbs = nutrients['carbohydrates']

        plan_option['name'] = meals
        plan_option['calories'] = calories
        plan_option['fat'] = fat
        plan_option['protein'] = protein
        plan_option['carbs'] = carbs
        return plan_option
    else:
        print(f"Error retrieving meal options. Status code: {response.status_code}")
        return []

if __name__ == "__main__":
    # Parse command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--target_calories", type=str, help="Target number of calories for the day")
    args = parser.parse_args()

    target_calories = float(args.target_calories)

    # Get meal options
    options = []
    for i in range(5):
        option = get_meal_options(target_calories)
        if option:
            options.append(option)

    print(options)


