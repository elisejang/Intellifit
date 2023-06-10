import csv
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader
import numpy as np
import argparse

# Define a custom activation function to limit the range
class RangeLimitedActivation(nn.Module):
    def __init__(self, min_val, max_val):
        super(RangeLimitedActivation, self).__init__()
        self.min_val = min_val
        self.max_val = max_val

    def forward(self, x):
        return torch.clamp(x, self.min_val, self.max_val)

# Define the model
class CaloriePredictionModel(nn.Module):
    def __init__(self, input_size):
        super(CaloriePredictionModel, self).__init__()
        self.fc1 = nn.Linear(input_size, 64)
        self.fc2 = nn.Linear(64, 32)
        self.fc3 = nn.Linear(32, 1)
        self.activation = RangeLimitedActivation(200, 1000)  # Set the desired range

    def forward(self, x):
        x = x.to(torch.float32)  # Convert input to Float data type
        x = torch.relu(self.fc1(x))
        x = torch.relu(self.fc2(x))
        x = self.fc3(x)
        x = self.activation(x)
        return x

# Define a custom dataset
class CalorieDataset(Dataset):
    def __init__(self, data):
        self.data = data

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        return self.data[idx]

# Read the data from the CSV file

parser = argparse.ArgumentParser()
parser.add_argument("--user_id", type=str, help="User identification")
args = parser.parse_args()
user = args.user_id

data = []
with open(str(user) + '_parameters.csv', 'r') as file:
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
        numeric_row = numeric_day + numeric_weather + [float(val) if val else float(0) for val in row[2::]]
        # print(numeric_row)

        # Append the numeric row to the data list
        data.append(numeric_row)

# Convert the data to numpy array
data = np.array(data)

# Split the data into inputs and targets
inputs = data[:, :-1]
print(inputs)
targets = data[:, -1:]

# Convert the numpy arrays to PyTorch tensors
inputs = torch.FloatTensor(inputs)
targets = torch.FloatTensor(targets)

# Create a custom dataset
dataset = CalorieDataset(data)

# Create a data loader
batch_size = 16
dataloader = DataLoader(dataset, batch_size=batch_size, shuffle=True)

# Instantiate the model
input_size = inputs.shape[1]
model = CaloriePredictionModel(input_size)

# Define the loss function and optimizer
criterion = nn.MSELoss()
optimizer = optim.Adam(model.parameters(), lr=0.01)

# Train the model
num_epochs = 10000
for epoch in range(num_epochs):
    for batch in dataloader:
        inputs_batch = batch[:, :-1].float()
        targets_batch = batch[:, -1:].float()

        # Forward pass
        outputs = model(inputs_batch)
        loss = criterion(outputs, targets_batch)

        # Backward pass and optimization
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

    # Print the loss for every epoch
    print(f"Epoch {epoch+1}/{num_epochs}, Loss: {loss.item()}")

transformed_outputs = torch.clamp(outputs, 200, 1000)

torch.save(model.state_dict(), str(user) + "_calorie_model.pth")
print("Model saved successfully.")
