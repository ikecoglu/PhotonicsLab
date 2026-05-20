# PhotonicsLab

MATLAB scripts for Raman spectroscopy acquisition, calibration, preprocessing, mapping, and optical tweezer calibration.

## Repository contents

- `standa_control` - stage-control and acquisition scripts for raster scanning with a spectrometer and Standa/XIMC motion hardware
- `ScanningRegion` - scan-region discovery plus guided acquisition for 2D sample scans
- `Calibration` - wavelength-to-Raman-shift conversion and calibration routines that save calibrated `.mat` files
- `BaseCorrection_Normalization` - baseline correction, automatic background removal, and normalization workflows
- `Map_MapBasedElimination` - map generation and map-based filtering/elimination utilities for processed spectral datasets
- `Tweezer_Calibration` - optical tweezer calibration utilities based on PSD/Lorentzian fitting

## Typical workflow

1. Acquire spectra with the hardware-control scripts in `standa_control` or `ScanningRegion`.
2. Convert raw spectra to calibrated Raman-shift data with scripts in `Calibration`.
3. Apply background correction and normalization with scripts in `BaseCorrection_Normalization`.
4. Generate maps or perform map-based cleanup with scripts in `Map_MapBasedElimination`.
5. Use `Tweezer_Calibration` independently for optical tweezer analysis.

## Requirements

- MATLAB (no minimum version is pinned in the repository; use a release compatible with your installed OmniDriver and toolbox setup)
- Parallel Computing Toolbox for scripts that call `parpool`
- Ocean Optics OmniDriver support for spectrometer access (`com.oceanoptics.omnidriver.api.wrapper.Wrapper`)
- Standa XIMC libraries for stage control (`libximc`, headers, and wrapper files are bundled here for Windows-focused workflows)

## Notes

- Most scripts are interactive and prompt for files or folders with `uigetfile`, `uigetdir`, or `uiputfile`.
- Several workflows assume local experimental hardware is connected and configured before running.
- Processed data is commonly saved as `.mat` files containing variables such as `Calx`, `CalInt`, `BCInt`, `NormInt`, `RawData`, and `wl`.
- There is currently no automated build or test configuration in this repository; validation is typically done by running the relevant MATLAB workflow on experiment data.

## Getting started

1. Open the repository in MATLAB.
2. Add the relevant subfolder to the MATLAB path.
3. Open the main script for the workflow you need, adjust the user parameters at the top of the file, and run it.

Representative entry points:

- `standa_control/standa_control.m`
- `ScanningRegion/ScanningRegion.m`
- `Calibration/Calibration_matlab.m`
- `Calibration/Calibration_ScanRegion.m`
- `BaseCorrection_Normalization/Analysis.m`
- `BaseCorrection_Normalization/AutoBackgroundCorrection.m`
- `Map_MapBasedElimination/Map.m`
- `Tweezer_Calibration/Tweezer_Calibration.m`
