import pandas as pd
import scipy.io as sio
import h5py
import numpy as np

# Load the CPA data
# cpa_data = pd.read_excel("path/to/CPA.xlsx")
# print("CPA Data:")
# print(cpa_data.head())

# Load the AIS data
try:
    with h5py.File("AIS/AIS.mat", "r") as f:
        print("AIS Data Keys:")
        print(list(f.keys()))
except Exception as e:
    print(f"Error loading AIS/AIS.mat with h5py: {e}")
    # Fallback to scipy.io.loadmat
    try:
        ais_data = sio.loadmat("AIS/AIS.mat")
        print("AIS Data Keys (scipy):")
        print(ais_data.keys())
    except Exception as e2:
        print(f"Error loading AIS/AIS.mat with scipy: {e2}")


# Load the array calibration data
try:
    with h5py.File("SPL_windows/arrays_lat-long.mat", "r") as f:
        print("Array Data Keys:")
        print(list(f.keys()))
except Exception as e:
    print(f"Error loading SPL_windows/arrays_lat-long.mat with h5py: {e}")
    # Fallback to scipy.io.loadmat
    try:
        array_data = sio.loadmat("SPL_windows/arrays_lat-long.mat")
        print("Array Data Keys (scipy):")
        print(array_data.keys())
    except Exception as e2:
        print(f"Error loading SPL_windows/arrays_lat-long.mat with scipy: {e2}")
