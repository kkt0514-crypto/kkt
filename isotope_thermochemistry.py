#!/usr/bin/env python3
"""Ideal-gas isotope thermochemistry from ORCA Hessian reanalyses.

Electronic energy cancels for H2 + D2 -> 2 HD on the same Born-Oppenheimer
surface.  This script evaluates the mass-dependent translational,
rotational, and harmonic-vibrational Gibbs corrections at 298.15 K, 1 atm.
Nuclear-spin statistical weights are intentionally not included.
"""

import math
import re
from pathlib import Path

T = 298.15  # K
P = 101_325.0  # Pa (1 atm)
H = 6.626_070_15e-34  # J s
K_B = 1.380_649e-23  # J K^-1
R = 8.314_462_618_153_24  # J mol^-1 K^-1
C_CM_S = 2.997_924_58e10  # cm s^-1
AMU = 1.660_539_066_60e-27  # kg
ANGSTROM = 1e-10  # m

MASS_H = 1.007_825_032_23
MASS_D = 2.014_101_778_12


def stretching_frequency(path: Path) -> float:
    matches = re.findall(r"^\s*5:\s+([0-9]+\.[0-9]+)\s+cm\*\*-1", path.read_text(), re.M)
    if not matches:
        raise RuntimeError(f"Could not find the diatomic stretching frequency in {path}")
    return float(matches[-1])


def optimized_bond_length() -> float:
    coords = []
    for line in Path("h2_optfreq.xyz").read_text().splitlines()[2:]:
        fields = line.split()
        if len(fields) >= 4:
            coords.append(tuple(map(float, fields[1:4])))
    if len(coords) != 2:
        raise RuntimeError("Expected two optimized H2 coordinates")
    return math.dist(coords[0], coords[1])


def gibbs_correction_kj_mol(mass_1_u: float, mass_2_u: float, frequency_cm: float, symmetry_number: int, bond_angstrom: float) -> float:
    total_mass = (mass_1_u + mass_2_u) * AMU
    reduced_mass = mass_1_u * mass_2_u / (mass_1_u + mass_2_u) * AMU
    moment = reduced_mass * (bond_angstrom * ANGSTROM) ** 2
    theta_rot = H * H / (8.0 * math.pi * math.pi * moment * K_B)
    theta_vib = H * C_CM_S * frequency_cm / K_B

    q_trans = (2.0 * math.pi * total_mass * K_B * T / (H * H)) ** 1.5 * (K_B * T / P)
    q_rot = T / (symmetry_number * theta_rot)
    q_vib = math.exp(-theta_vib / (2.0 * T)) / (1.0 - math.exp(-theta_vib / T))
    return -R * T * math.log(q_trans * q_rot * q_vib) / 1000.0


def main() -> None:
    bond = optimized_bond_length()
    systems = {
        "H2": (MASS_H, MASS_H, 2, Path("h2.vib.out")),
        "D2": (MASS_D, MASS_D, 2, Path("d2.vib.out")),
        "HD": (MASS_H, MASS_D, 1, Path("hd.vib.out")),
    }
    corrections = {}
    lines = [
        "H2 + D2 -> 2 HD isotope thermochemistry",
        f"T = {T:.2f} K; p = {P / 101_325.0:.2f} atm; optimized H-H distance = {bond:.6f} A",
        "Electronic energy cancels; nuclear-spin statistical weights are excluded.",
    ]
    for name, (m1, m2, sigma, source) in systems.items():
        frequency = stretching_frequency(source)
        correction = gibbs_correction_kj_mol(m1, m2, frequency, sigma, bond)
        corrections[name] = correction
        lines.append(f"G_corr({name}) = {correction:.6f} kJ/mol; stretch = {frequency:.2f} cm^-1; sigma = {sigma}")

    delta_g = 2.0 * corrections["HD"] - corrections["H2"] - corrections["D2"]
    lines.append(f"DeltaG [2 HD - H2 - D2] = {delta_g:.6f} kJ/mol")
    lines.append(f"DeltaG [2 HD - H2 - D2] = {delta_g / 4.184:.6f} kcal/mol")
    Path("h2_d2_to_2hd_delta_g.txt").write_text("\n".join(lines) + "\n")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
