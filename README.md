# NW: Marine Acoustic Signal Processing and Analysis Toolkit

## Overview

This repository contains a comprehensive MATLAB-based toolkit for marine acoustic signal processing and analysis, with a focus on ship-radiated noise and multi-channel underwater acoustic recordings. The toolkit provides advanced capabilities for processing 48-channel hydrophone array data, calculating sound pressure levels (SPL), and performing detailed spectral analysis of underwater acoustic signatures.

## Main Function: windows_48ch

The core function of this toolkit is `windows_48ch` (located in `SPL_windows/windows_48Ch.mlx`), which serves as the primary analysis engine for processing 48-channel acoustic array data. This function:

- **Processes multi-channel acoustic recordings** from 48-element hydrophone arrays
- **Performs spectral analysis** with configurable time windows and frequency resolution
- **Calculates radiated noise levels** in both broadband and frequency-specific bands
- **Generates comprehensive acoustic signatures** for marine vessel noise analysis
- **Supports various acoustic metrics** including third-octave band analysis and sound pressure level calculations

The function is specifically designed for analyzing ship-radiated underwater noise using data from large-aperture hydrophone arrays, enabling detailed characterization of acoustic signatures from marine vessels.

## Key Features

### Signal Processing Capabilities
- **Multi-channel audio extraction** (`PrePro/extractWavCh.m`, `PrePro/concatWavCh.m`)
- **Sound pressure level calculations** (`calcSPL/spl.m`) with moving window analysis
- **Spectral analysis tools** with customizable frequency resolution and windowing
- **Third-octave band processing** for standardized acoustic measurements

### Analysis and Visualization
- **Comprehensive plotting functions** for acoustic data visualization
- **Geospatial mapping integration** using M_Map toolbox for positioning data
- **AIS (Automatic Identification System) integration** for vessel tracking and correlation
- **Statistical analysis tools** for long-term acoustic monitoring

### Data Processing Pipeline
1. **Raw Data Ingestion**: Import and preprocess 48-channel acoustic recordings
2. **Channel Extraction**: Extract individual channels or channel combinations for analysis
3. **Spectral Processing**: Apply FFT-based analysis with configurable parameters
4. **Noise Level Calculation**: Compute radiated noise levels referenced to standard underwater acoustics units
5. **Visualization and Export**: Generate publication-quality plots and export results

## File Structure

```
├── SPL_windows/          # Main analysis functions including windows_48ch
├── PrePro/               # Data preprocessing utilities
├── calcSPL/              # Sound pressure level calculation functions
├── AIS/                  # Automatic Identification System data processing
├── Bathy/                # Bathymetry and mapping utilities
├── m_map/                # Geographic mapping toolbox
├── TL/                   # Transmission loss modeling
├── Winds/                # Environmental data processing
└── Various analysis scripts and utilities
```

## System Requirements

- MATLAB R2019b or later
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox
- Mapping Toolbox (for geospatial features)

## Usage Example

```matlab
% Basic usage of windows_48ch for acoustic analysis
% (Detailed parameters and configuration available in the live script)

% Set analysis parameters
fs = 48000;  % Sampling frequency
channels = 1:48;  % All 48 channels
windowSize = 1024;  % Analysis window size

% Run main analysis function
% [Results available through the windows_48Ch.mlx live script interface]
```

## Referenced Publication

**Note**: This work is associated with a manuscript that should be referenced as "Thomson_.....pdf". 

> **Missing Document**: The referenced PDF manuscript that provides the theoretical background and methodology for this acoustic analysis toolkit should be added to this repository. This document would contain important details about the signal processing algorithms, validation methods, and scientific applications of the tools provided here.

The manuscript likely covers:
- Theoretical foundations of the multi-channel acoustic processing methods
- Validation studies and performance metrics
- Applications to marine noise monitoring and assessment
- Comparison with established acoustic analysis techniques

**Please add the Thomson et al. manuscript PDF to this repository for complete documentation.**

## Applications

This toolkit has been developed for:
- **Marine vessel noise monitoring** and characterization
- **Underwater acoustic signature analysis** for ships and marine platforms
- **Environmental impact assessment** of maritime activities
- **Long-term acoustic monitoring** in marine environments
- **Research applications** in marine bioacoustics and underwater noise pollution

## Contributing

This is a research toolkit developed for acoustic analysis applications. For questions about methodology or applications, please refer to the associated manuscript documentation (to be added).

## License

Please refer to individual component licenses in the respective directories. Some components (M_Map, etc.) have their own licensing terms.