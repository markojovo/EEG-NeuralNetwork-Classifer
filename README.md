# EEG Neural Network Classifier

## Overview
This project implements a neural network classifier for EEG (Electroencephalogram) data, specifically designed to work with the Physionet EEG Motor Movement/Imagery Dataset. The classifier is capable of distinguishing between different motor movements and imagery based on EEG signals.

## Features
- Processes EEG data from the Physionet dataset
- Implements a multi-layer neural network for classification
- Extracts features from EEG signals including RMS, MAV, MAVSQ, and VAR
- Supports classification of multiple movement types: Left Fist, Right Fist, Both Fists, Both Feet
- Includes data preprocessing using EEGLAB
- Implements backpropagation for neural network training

## Requirements
- MATLAB
- EEGLAB toolbox
- Physionet EEG Motor Imagery Dataset: https://physionet.org/content/eegmmidb/1.0.0/

## Usage
1. Ensure the Physionet dataset is in a folder named "EEGdatasets" in the project directory
2. Adjust the EEGLAB path in the main script
3. Run the main script (ProjNNCode1.m) to train and evaluate the classifier

## File Description
- ProjNNCode1.m: Main script for data processing, feature extraction, and neural network training
- Eventread.m: Function to read event information from EEG EDF files
- NNbackProp2.m: Manually coded implementation of backpropagation for neural network training 

## Author
Marko Jovanovic

## Last Updated
February 18, 2021

## Note
This project requires the Physionet EEG dataset and EEGLAB toolbox to function properly. Ensure all dependencies are correctly set up before running the scripts.
