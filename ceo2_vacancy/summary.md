# CeO2 bridged Ce4 cluster: vacancy single points

## Status and method

All values below use unrelaxed structures cut from fluorite CeO2 with
`a = 5.41 Å`, PBE0-D3BJ/def2-SVP with def2-ECP on Ce, RIJCOSX, UKS, and
`TightSCF`. The current local calculations use four ORCA ranks at `nice 19`
and run one at a time. Energies are electronic single-point energies.

| System | Status | Final energy (Eh) | `<S**2>` |
| --- | --- | ---: | ---: |
| O2 triplet | Normal termination | -150.052631982160 | — |
| Ce4O8 clean singlet | Normal termination; stability tested | -2501.226973028752 | 1.467556 |
| Ce4O7, bridge-O vacancy | Normal termination | -2426.112494218323 | 3.021888 |
| Ce4O7, center-O vacancy (V4) | SCF stopped; NoIter GBW post-processing completed | -2426.09532 (last SCF) | not printed by NoIter |
| Ce4O7, terminal-O vacancy | Not run | — | — |

The O2 geometry supplied to the SVP single point has an O–O separation of
1.192804 Å.

The center-O SCF was stopped at TRAH macroiteration 79 because its energy had
remained within `1e-5 Eh` near `-2426.09532 Eh`, although it did not meet the
`TightSCF` gradient criterion. A subsequent `MORead NoIter` calculation read
the final GBW with matching geometry and produced atomic populations, but it
does not form a Fock matrix or compute the electronic total energy; its printed
`-0.016802829740 Eh` is the D3 dispersion correction only. It also does not
print `<S**2>`.

## Clean-cluster stability analysis

The initial UKS solution was unstable: the first three stability eigenvalues
were negative (`-0.06920070`, `-0.05377139`, and `-0.05359108 Eh`). ORCA
transformed the orbitals and reconverged the UHF/UKS wavefunction, as requested
by `STABRestartUHFifUnstable true`. The final stability eigenvalues were
positive (`0.00137769`, `0.00144750`, and `0.00317862 Eh`), so ORCA reports the
final wavefunction as stable. The clean singlet has appreciable formal UHF
spin contamination (`<S**2> = 1.467556`); this should be treated as a
cluster-model limitation.

| Atom | Site type | Mulliken spin | Loewdin spin |
| --- | --- | ---: | ---: |
| Ce0 | Ce | -0.131075 | -0.105427 |
| Ce1 | Ce | -0.787327 | -0.765344 |
| Ce2 | Ce | -0.919429 | -0.905309 |
| Ce3 | Ce | -0.066593 | -0.066774 |
| O4 | center O | 0.089789 | 0.083496 |
| O5 | bridge O (+z) | 0.459735 | 0.439559 |
| O6 | bridge O (+y) | 0.060047 | 0.057158 |
| O7 | bridge O (+x) | 0.026988 | 0.025514 |
| O8 | bridge O (-z) | 0.029254 | 0.027852 |
| O9 | bridge O (-y) | 0.048202 | 0.045812 |
| O10 | bridge O (-x) | 0.124826 | 0.119002 |
| O11 | terminal O | 1.065583 | 1.044460 |

In the clean cluster, Ce1 and Ce2 have the largest Ce spin magnitudes
(`|spin| > 0.5`); Ce2 is largest (`-0.919429` Mulliken, `-0.905309` Loewdin).

## Bridge-O vacancy result

`E_vac = E(Ce4O7) + 1/2 E(O2) - E(Ce4O8)`.

| Vacancy site | Removed-O coordination | E_vac (Eh) | E_vac (eV) | E_vac (kJ/mol) |
| --- | ---: | ---: | ---: | ---: |
| Bridge O at (1/4, 1/4, 3/4) | 2 Ce (Ce1, Ce2) | 0.088162819349 | 2.399033 | 231.471 |

### Full atomic spin populations for bridge-O vacancy

| Atom | Site type | Mulliken spin | Loewdin spin |
| --- | --- | ---: | ---: |
| Ce0 | Ce | 0.090729 | 0.071849 |
| Ce1 | Ce; adjacent to removed O | 1.063677 | 1.060017 |
| Ce2 | Ce; adjacent to removed O | 1.063678 | 1.060018 |
| Ce3 | Ce | 1.028413 | 1.017970 |
| O4 | center O | -0.027327 | -0.023993 |
| O5 | bridge O (+y) | -0.038715 | -0.035440 |
| O6 | bridge O (+x) | -0.038716 | -0.035441 |
| O7 | bridge O (-z) | -0.037754 | -0.035096 |
| O8 | bridge O (-y) | -0.028313 | -0.026495 |
| O9 | bridge O (-x) | -0.028313 | -0.026495 |
| O10 | terminal O | -1.047359 | -1.026893 |

The missing bridge O was coordinated to Ce1 and Ce2. The triplet spin density
is not confined to only those two Ce sites: Ce1/Ce2 carry about `1.06` each,
and Ce3 also carries about `1.02` in either population analysis. The remaining
O atoms sum to approximately `-2` spin population, giving the reported total
atomic spin population of `2`.

The terminal O (O10 in the vacancy output; O11 in the clean-cluster output) is
the only O with spin population below `-0.5`: `-1.047359` Mulliken and
`-1.026893` Loewdin. No clean-cluster O has a spin population below `-0.5`.

## Center-O vacancy (V4, approximate)

| Vacancy site | Removed-O coordination | E_vac (eV) | E_vac (kJ/mol) | SCF status |
| --- | ---: | ---: | ---: | --- |
| Center O (V4) | 4 Ce | 2.87 | 276.6 | SCF energy stable within `1e-5 Eh`; `TightSCF` gradient criterion not met |

### NoIter frozen-orbital populations for center-O vacancy

| Atom | Site type | Mulliken spin | Loewdin spin |
| --- | --- | ---: | ---: |
| Ce0 | Ce; adjacent to removed O | 0.141890 | 0.124360 |
| Ce1 | Ce; adjacent to removed O | 1.058125 | 1.043959 |
| Ce2 | Ce; adjacent to removed O | 1.060820 | 1.046640 |
| Ce3 | Ce; adjacent to removed O | 1.071383 | 1.076537 |
| O4 | bridge O (+z) | -0.058057 | -0.053550 |
| O5 | bridge O (+y) | -0.046614 | -0.043128 |
| O6 | bridge O (+x) | -0.049942 | -0.045842 |
| O7 | bridge O (-z) | -0.031929 | -0.030005 |
| O8 | bridge O (-y) | -0.043290 | -0.040338 |
| O9 | bridge O (-x) | -0.045707 | -0.042765 |
| O10 | terminal O | -1.056678 | -1.035868 |

These populations are from the stored last-SCF orbitals and sum to total atomic
spin population `2.000000`. They are diagnostic only because the NoIter job
performs no SCF energy evaluation.

## Notes

- Earlier, malformed non-bridged Ce4 structures were excluded from these results.
- These are small, unrelaxed cluster single points; edge termination and the
  absence of a periodic slab can strongly affect vacancy energetics.
- PBE0 localization is not quantitatively interchangeable with PBE+U slab
  calculations. A periodic PBE+U(5 eV) CeO2(111) slab remains the preferred
  comparison when VASP becomes available.
