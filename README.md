# Optimization of Transfers Between Non-Coplanar Geocentric Orbits Using Bi-Elliptic Bitangent Maneuvers and Lambert's Problem

[![Paper DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22928190.svg)](https://doi.org/10.5281/zenodo.22928190)
[![Supplementary Videos DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22927742.svg)](https://doi.org/10.5281/zenodo.22927742)

This repository contains the MATLAB codes developed for the academic project *Optimization of Transfers Between Non-Coplanar Geocentric Orbits Using Bi-Elliptic Bitangent Maneuvers and Lambert's Problem*, carried out at Politecnico di Milano.

The project investigates impulsive orbital transfers between two assigned positions located on distinct, non-coplanar geocentric elliptical orbits. The initial and final Cartesian state vectors are converted into classical orbital elements to characterize the geometry, size, shape, energy, and spatial orientation of the two orbits.

Three transfer strategies are analyzed and compared:

1. a first strategy combining a plane-change maneuver, an apsidal-line rotation, and a bitangent transfer;
2. a bi-elliptic bitangent transfer in which the plane change is performed near the transfer-orbit apocenter, where the spacecraft velocity is lower;
3. a set of two-impulse transfers obtained through Lambert's problem for different departure points, arrival points, and times of flight.

The numerical scripts support the orbital characterization, propagation, maneuver calculations, trajectory visualization, and comparison of the total velocity increment and elapsed time associated with each strategy. The variable names and symbols used in the scripts follow, wherever possible, the notation adopted in the paper, and the code is commented to facilitate verification and reproducibility.

## Numerical model

The analysis is based on the following assumptions:

- Earth-centered Keplerian two-body motion;
- instantaneous impulsive maneuvers;
- absence of atmospheric drag, oblateness, third-body effects, and other orbital perturbations;
- fixed gravitational parameter and Earth radius;
- target phasing consistent with the departure and arrival conditions imposed in the Lambert analysis.

The results therefore provide a preliminary theoretical comparison and do not constitute a complete operational mission design.

## Main results

| Transfer strategy | Total delta-v (km/s) | Total elapsed time (s) |
|---|---:|---:|
| First strategy | 8.4912 | 22,814.3 |
| Bi-elliptic strategy | 6.7935 | 61,455.4 |
| Lambert transfer - Case 1 | 16.9858 | 14,159.47 |
| Lambert transfer - Case 2 | 18.6863 | 14,159.37 |
| Lambert transfer - Case 3 | **6.7679** | **10,616.4** |

Among the solutions examined, Lambert Case 3 provides the lowest calculated total velocity increment and the most favorable compromise between maneuver cost and elapsed time, subject to satisfaction of the required target-phasing condition.

## Repository structure

The MATLAB implementation is divided into two main folders:

```text
.
|-- general_transfers/
|   `-- First and second transfer strategies, numerical solvers,
|       orbital conversions, time-of-flight routines, and plotting tools
`-- chase_maneuver/
    `-- Lambert-based chase maneuver, Kepler propagation,
        state conversion routines, and the investigated Lambert cases
```

- [`general_transfers`](general_transfers/) contains the 21 scripts and functions used to characterize the assigned orbits and implement the first strategy, the bi-elliptic bitangent strategy, its optimized configuration, and the associated numerical and graphical analyses.
- [`chase_maneuver`](chase_maneuver/) contains the 12 scripts and functions used for the Lambert-based third strategy, including the input definition, Lambert solver, Kepler propagation, time-of-flight calculation, and Cartesian/orbital-element conversions.

Each folder contains a dedicated `README.md` identifying its main scripts and supporting functions.

## Software requirements

- MATLAB

Any additional toolbox requirements should be stated in the header of the relevant script, where applicable.

## Usage

Download or clone the repository and preserve the two-folder structure. In MATLAB, open the folder associated with the desired analysis or add it to the MATLAB path:

- use `general_transfer` for the first and second strategies;
- use `chase_maneuver` for the Lambert-based third strategy.

Run one of the main scripts indicated in the corresponding folder README. Supporting functions must remain accessible from the same MATLAB path.

Before modifying an input case, verify that the units are consistent with those adopted in the paper: distances are expressed in kilometers, velocities in kilometers per second, angles in radians unless otherwise stated, and times in seconds.

## Supplementary animations

The MP4 animations illustrating the orbital-transfer strategies are archived separately on Zenodo:

**DOI:** [10.5281/zenodo.22927742](https://doi.org/10.5281/zenodo.22928190)

## Citation

If you use the codes or results contained in this repository, please cite the associated paper:

> M. Vrapi, A. Perego, and A. Riva, "Optimization of Transfers Between Non-Coplanar Geocentric Orbits Using Bi-Elliptic Bitangent Maneuvers and Lambert's Problem," Zenodo, 2026. DOI: PAPER_DOI.

Replace `PAPER_DOI` with the DOI assigned to the paper after its publication on Zenodo.

## License

The source code in this repository is distributed under the MIT License. See the `LICENSE` file for the complete terms. The paper and supplementary animations are licensed separately under the terms specified in their respective Zenodo records.

## Authors

- Michelle Vrapi ([ORCID](https://orcid.org/0009-0007-3304-8042))
- Andrea Perego
- Alessia Riva

Politecnico di Milano, Department of Aerospace Science and Technology (DAER).

## Project context

This repository is associated with an academic aerospace engineering project and is not an official publication of Politecnico di Milano. The codes are shared for documentation, reproducibility, and portfolio purposes.

