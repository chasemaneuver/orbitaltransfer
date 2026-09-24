# Lambert-Based Chase Maneuver

This folder contains the MATLAB implementation of the third transfer strategy analyzed in the associated paper. The strategy solves Lambert's problem for selected departure and arrival conditions and evaluates the corresponding two-impulse chase maneuver, including the required orbital propagation and time-of-flight calculations.

## Main scripts

- `main.m`: main execution script for the Lambert-transfer analysis.
- `main2.m`: alternative main execution script for the additional investigated configuration.
- `user_inputs.m`: definition of the input data used by the analysis.
- `strategia_chase.m`: implementation of the chase-maneuver strategy.

## Supporting files

- Lambert solver: `Lambert.m`.
- Kepler propagation and timing: `kepler_equation.m` and `TOF.m`.
- Orbital parameters and coordinate conversions: `calcolo_parametri.m`, `car2par.m`, `par2car.m`, `oe_from_sv.m`, and `sv_from_oe.m`.

## Usage

Open this folder in MATLAB, or add it to the MATLAB path, check the values defined in `user_inputs.m`, and run `main.m` or `main2.m` for the desired case. Keep all supporting functions in the same accessible path. Distances are expressed in kilometers, velocities in kilometers per second, angles in radians unless otherwise stated, and times in seconds.

The Lambert results depend on the selected transfer direction, time of flight, departure point, arrival point, and target-phasing condition. For the complete methodology and interpretation of the investigated cases, refer to the paper and to the main repository `README.md`.
