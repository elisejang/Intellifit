import csv
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader
import numpy as np
from torchsummary import summary
import ast
import torch.nn.functional as F
import argparse

# Define the model
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
        x = torch.sigmoid(self.fc3(x))  # Apply sigmoid activation
        return x

# Define a custom dataset
class CalorieDataset(Dataset):
    def __init__(self, data, targets):
        self.data = data
        self.targets = targets

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        input_data = self.data[idx]
        target_data = self.targets[idx]
        return input_data, target_data
    
parser = argparse.ArgumentParser()
parser.add_argument("--user_id", type=str, help="User identification")
args = parser.parse_args()
user = args.user_id

# Read the data from the CSV file
data = []
targets = []
with open(str(user) + '_indexed_workout_data.csv', 'r') as file:
    reader = csv.reader(file)
    next(reader)  # Skip the header row
    for row in reader:
        # Convert the day of the week to numeric information
        days_of_week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        day_of_week = row[0]
        numeric_day = [float(days_of_week.index(day_of_week))]

        # Convert the weather (season) to numeric information using one-hot encoding
        weather_types = ["Spring", "Summer", "Autumn", "Winter"]
        weather = row[1]
        numeric_weather = [float(weather_types.index(weather))]

        # Convert the rest of the row to float values
        numeric_row = numeric_day + numeric_weather + [float(val) if val else float(0) for val in row[2:7]]
        # trg = ast.literal_eval(row[7])
        workout_index = ast.literal_eval(row[7])
        target = np.zeros(249)  # Assuming there are 249 workouts
        target[workout_index] = 1
        targets.append(target)
        # print(numeric_row)
        print(target)
        # Append the numeric row to the data list
        data.append(numeric_row)

# Convert the data to a numpy array
data = np.array(data)
targets = np.array(targets)
# Split the data into inputs and targets
# print(data)
inputs = data
targets = targets
# print(inputs)

# Create a custom dataset
dataset = CalorieDataset(data, targets)

# Convert the numpy arrays to PyTorch tensors
inputs = torch.FloatTensor(inputs)
targets = torch.FloatTensor(targets)  # Convert targets to float32


# Create a data loader
batch_size = 16
dataloader = DataLoader(dataset, batch_size=batch_size, shuffle=True)

# Instantiate the model
# input_size = inputs.shape[1]
model = FitnessRecModel(7)

# summary(model, (input_size,))

# Define the loss function and optimizer
criterion = nn.BCELoss()
optimizer = optim.Adam(model.parameters(), lr=0.01)

# Train the model
num_epochs = 1000
for epoch in range(num_epochs):
    for inputs_batch, targets_batch in dataloader:

        # Forward pass
        outputs = model(inputs_batch)
        # print(outputs)
        loss = criterion(outputs.float(), targets_batch.float())

        # Backward pass and optimization
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

    # Print the loss for every epoch
    print(f"Epoch {epoch+1}/{num_epochs}, Loss: {loss.item()}")

torch.save(model.state_dict(), str(user) + "_fitness_model.pth")
print("Model saved successfully.")       

