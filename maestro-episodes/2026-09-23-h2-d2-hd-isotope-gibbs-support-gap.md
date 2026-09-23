---
task: unsupported
engine: none
error_class: support_gap
outcome: support_gap
---
Symptom: The requested H2 + D2 -> 2 HD reaction Gibbs free energy requires deuterium isotope masses in thermochemistry. ThermoTask rejected XYZ atom label D during charge suggestion (detail: 'D').

Attempts: Queried MAESTRO capabilities for free energy, thermochemistry, isotope, mass, and deuterium. ThermoTask produces Gibbs free energy for a single supported QM system. IsotopeShiftTask supports harmonic frequencies after isotopic substitution, but its declared output is isotope_frequencies rather than Gibbs free energy.

Result: No supported MAESTRO task composes isotope-aware thermochemistry into the requested reaction free energy. A direct ORCA isotope-mass thermochemistry workflow is required.

Context: User requested H2 + D2 -> 2 HD Gibbs energy at standard thermochemical conditions, using one idle GPU through Slurm.
