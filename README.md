# NW: Marine Acoustic Signal Processing and Analysis Toolkit

## Overview

This repository contains a comprehensive MATLAB-based toolkit for marine acoustic signal processing and analysis, implementing the methodologies developed for the Northern Watch Project and published in Thomson & Barclay (2025). The toolkit specializes in ship-radiated noise directionality analysis using multi-channel underwater acoustic recordings from 48-element hydrophone arrays.

Originally developed for Arctic marine surveillance applications in the Canadian Arctic Archipelago, this toolkit provides advanced capabilities for characterizing the horizontal radiation patterns of vessel-generated underwater noise, with particular focus on both broadband and tonal acoustic components.

## Main Function: windows_48ch

The core function of this toolkit is `windows_48ch` (located in `SPL_windows/windows_48Ch.mlx`), which implements the signal processing methodology described in Thomson & Barclay (2025). This function serves as the primary analysis engine for processing 48-channel acoustic array data and:

- **Processes multi-channel acoustic recordings** from 48-element bottom-mounted hydrophone arrays
- **Performs high-resolution spectral analysis** with 0.5-Hz frequency resolution using 2048-point FFT
- **Calculates source level directivity patterns** with 3-second time averaging for both broadband (10-600 Hz) and narrowband tonal components
- **Implements tonal tracking algorithms** for engine harmonics, propeller blade rates, and auxiliary machinery signatures
- **Integrates AIS positioning data** for precise vessel bearing and range calculations during closest point of approach (CPA) events
- **Applies propagation loss corrections** using geometric spreading models validated against full-wave acoustic modeling
- **Generates probability density estimates** of source levels as a function of ship aspect angle

The function is specifically designed for analyzing ship-radiated underwater noise directionality using large-aperture hydrophone arrays, providing unprecedented spatial resolution for characterizing acoustic signatures from marine vessels in both Arctic and temperate environments.

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

The methodology follows the approach described in Thomson & Barclay (2025):

1. **Raw Data Ingestion**: Import 48-channel acoustic recordings from bottom-mounted hydrophone arrays
2. **AIS Data Integration**: Correlate vessel positioning and heading data with acoustic recordings
3. **Vessel Detection**: Identify ship passes within 3 km with received levels >10 dB above background
4. **Spectral Processing**: Apply 2048-point FFT analysis achieving 0.5-Hz frequency resolution
5. **Tonal Identification**: Algorithmic detection and tracking of discrete frequency components
6. **Propagation Loss Correction**: Apply geometric spreading model with 20log(R) distance correction
7. **Directivity Analysis**: Calculate source level probability densities as function of ship aspect angle
8. **Statistical Analysis**: Generate directivity patterns for broadband and narrowband components

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
% Ship noise directionality analysis using windows_48ch
% Based on methodology in Thomson & Barclay (2025)

% Set analysis parameters for Arctic array configuration
fs = 48000;           % Sampling frequency (48 kHz)
channels = 1:48;      % All 48 hydrophone channels
fft_length = 2048;    % FFT length for 0.5-Hz resolution
time_avg = 3;         % 3-second time averaging window
freq_band = [10 600]; % Broadband analysis range (Hz)

% Define frequency bands for tonal analysis
% Engine harmonics: CFR multiples (cylinder firing rate)
% Propeller harmonics: SR multiples (shaft rate)

% Example tonal frequencies from published results:
% Ocean Endeavour: 380, 505, 545 Hz
% Roald Amundsen: 475 Hz (C79), propeller harmonics

% Run main analysis through windows_48Ch.mlx live script
% Results include:
% - Source level directivity patterns
% - Probability density functions by aspect angle  
% - Broadband and tonal component separation
% - AIS-correlated vessel positioning
```

## Referenced Publication

This toolkit implements the methodologies described in:

**Thomson, D. J. M., & Barclay, D. R. (2025). Directionality of Tonal Components of Ship Noise Using Arctic Hydrophone Array Elements. IEEE Journal of Oceanic Engineering.** 

📄 [IEEE_Thomson_et_al_Directionality_of_Tonal_Components_of_Ship_Noise_Using_Arctic_Hydrophone_Array_Elements_2025.pdf](https://github.com/dugaldthomson/NW/blob/Main/IEEE_Thomson_et_al_Directionality_of_Tonal_Components_of_Ship_Noise_Using_Arctic_Hydrophone_Array_Elements_2025.pdf)

### Key Research Findings

The manuscript documents a comprehensive study conducted in the Canadian Arctic Archipelago using two 48-element bottom-mounted hydrophone arrays to estimate the horizontal directionality of ship-radiated noise. Key findings include:

- **Directivity Patterns**: Ship noise directionality varies significantly with vessel aspect angle, particularly for tonal components
- **Frequency Analysis**: Time-averaged received levels calculated in 3-s increments for broadband (10–600 Hz) and narrowband tonal sources
- **Source Level Estimates**: Broadband source levels ranged from 148 to 181 dB re 1 µPa² m² for the four ships of opportunity studied
- **Tonal Component Tracking**: Algorithmic identification and tracking of engine-related tonals, propeller harmonics, and auxiliary machinery signatures
- **Arctic Application**: Validation of methods in pristine Arctic acoustic environments with minimal background noise

### Methodology Overview

The research methodology implemented in this toolkit includes:

1. **Multi-Array Processing**: Simultaneous analysis using 96 total hydrophone elements (2×48-element arrays)
2. **AIS Integration**: Automatic Identification System data for precise vessel positioning and bearing estimation
3. **Spectral Analysis**: High-resolution FFT analysis with 0.5-Hz frequency resolution for tonal identification
4. **Propagation Modeling**: Geometric spreading loss model with validation against full-wave acoustic modeling
5. **Statistical Analysis**: Probability density estimation of source levels as a function of ship aspect angle

### Study Vessels

The manuscript presents detailed analysis of two research vessels:
- **Ocean Endeavour**: Cruise ship with traditional diesel propulsion showing consistent tonal signatures
- **Roald Amundsen**: Diesel-electric hybrid vessel demonstrating speed-dependent acoustic characteristics

## Applications

This toolkit has been developed and validated for:

### Primary Research Applications
- **Arctic Marine Monitoring**: Developed as part of the Northern Watch Project for Canadian Arctic surveillance
- **Ship Noise Directionality Analysis**: Quantifying horizontal radiation patterns of vessel-generated underwater noise
- **Tonal Component Characterization**: Identifying and tracking engine harmonics, propeller signatures, and auxiliary machinery tonals
- **Multi-vessel Acoustic Signatures**: Comparative analysis of different propulsion systems (diesel vs. diesel-electric hybrid)

### Operational Applications  
- **Marine vessel noise monitoring** and characterization in Arctic and temperate waters
- **Environmental impact assessment** of maritime activities on marine ecosystems
- **Long-term acoustic monitoring** in marine protected areas and shipping corridors
- **Research applications** in marine bioacoustics and underwater noise pollution studies
- **Naval and maritime security** applications for vessel detection and classification

### Technical Capabilities
- **Multi-array processing** for enhanced spatial resolution and noise source localization
- **Real-time acoustic monitoring** with AIS integration for vessel tracking correlation
- **Statistical analysis** of noise exposure patterns for environmental impact studies

## Contributing

This is a research toolkit developed for acoustic analysis applications. For questions about methodology or applications, please refer to the associated manuscript documentation (to be added).

## License

Please refer to individual component licenses in the respective directories. Some components (M_Map, etc.) have their own licensing terms.