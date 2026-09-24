# General Transfers

This folder contains the MATLAB implementation of the first two transfer strategies analyzed in the associated paper: the direct strategy based on plane change, apsidal-line rotation, and a bitangent transfer, and the bi-elliptic bitangent strategy with the plane change performed near the transfer-orbit apocenter.

## Main scripts

- `strategia_base.m`: executes the first transfer strategy.
- `strategia_biellittica_bitangente.m`: executes the bi-elliptic bitangent strategy.
- `strategia_biellittica_bitangente_ottimizzata.m`: evaluates the optimized bi-elliptic configuration.

## Supporting files

- Transfer maneuvers: `changeOrbitalPlane.m`, `changePericenterArg.m`, `bitangentTransfer.m`, and `bielliptic_bitangentTransfer.m`.
- Orbital parameters and conversions: `calcolo_parametri.m`, `car2par.m`, and `par2car.m`.
- Time-of-flight calculations: `TOF.m` and `TOF_diretto.m`.
- Numerical solvers: `bisez.m`, `biseznewton.m`, and `newton.m`.
- Orbit comparison and visualization: `confronto_orbite.m`, `confronto_orbite_cambiopiano.m`, `plotOrbit.m`, `plot_manovre_indicazioni.m`, `earth_sphere.m`, and `hitcallback.m`.

## Usage

Open this folder in MATLAB, or add it to the MATLAB path, and run the main script corresponding to the desired strategy. Keep all supporting functions in the same accessible path. Distances are expressed in kilometers, velocities in kilometers per second, angles in radians unless otherwise stated, and times in seconds.

For the complete methodology, assumptions, and results, refer to the paper and to the main repository `README.md`.
