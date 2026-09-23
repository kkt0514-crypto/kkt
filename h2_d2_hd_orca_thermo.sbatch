#!/usr/bin/env bash
# maestro: raw
# H2 + D2 -> 2 HD standard-state Gibbs free energy, 298.15 K and 1 atm.
# MAESTRO has no isotope-aware thermochemistry task; ORCA's Hessian workflow is used.
#SBATCH --job-name=h2d2hd-thermo
#SBATCH --partition=32core_partition
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --output=h2d2hd-thermo-%j.out
#SBATCH --error=h2d2hd-thermo-%j.err

set -euo pipefail
module load orca/v6.0.1

# The electronic Hessian is isotope-independent.  Calculate it once for H2,
# then substitute nuclear masses in independent copies for H2, D2, and HD.
orca h2_optfreq.inp > h2_optfreq.out

make_isotopologue_hess() {
  local output=$1
  local mass1=$2
  local mass2=$3
  awk -v m1="$mass1" -v m2="$mass2" '
    BEGIN { atoms=0; atom=0 }
    /^\$atoms$/ { atoms=1; print; next }
    atoms && /^[[:space:]]*[0-9]+[[:space:]]*$/ { print; next }
    atoms && atom < 2 && /^[[:space:]]*H[[:space:]]/ {
      atom++
      $2 = (atom == 1 ? m1 : m2)
      print
      if (atom == 2) atoms=0
      next
    }
    { print }
  ' h2_optfreq.hess > "$output"
}

# Atomic masses in u: 1H = 1.00782503223; 2H (D) = 2.01410177812.
make_isotopologue_hess h2.hess 1.00782503223 1.00782503223
make_isotopologue_hess d2.hess 2.01410177812 2.01410177812
make_isotopologue_hess hd.hess 1.00782503223 2.01410177812

orca_vib h2.hess > h2.vib.out
orca_vib d2.hess > d2.vib.out
orca_vib hd.hess > hd.vib.out

for species in h2 d2 hd; do
  awk '/Final Gibbs free energy/ {print $0}' "${species}.vib.out" > "${species}.gibbs.txt"
done

extract_gibbs() {
  awk '
    /Final Gibbs free energy/ {
      for (i = 1; i <= NF; i++) {
        if ($i ~ /^-?[0-9]+\.[0-9]+$/) value = $i
      }
    }
    END {
      if (value == "") exit 1
      print value
    }
  ' "$1"
}

g_h2=$(extract_gibbs h2.vib.out)
g_d2=$(extract_gibbs d2.vib.out)
g_hd=$(extract_gibbs hd.vib.out)
delta_g_eh=$(awk -v h2="$g_h2" -v d2="$g_d2" -v hd="$g_hd" 'BEGIN {printf "%.12f", 2*hd-h2-d2}')
delta_g_kj_mol=$(awk -v dg="$delta_g_eh" 'BEGIN {printf "%.6f", dg*2625.49962}')
delta_g_kcal_mol=$(awk -v dg="$delta_g_eh" 'BEGIN {printf "%.6f", dg*627.509474}')

{
  echo "G(H2) = ${g_h2} Eh"
  echo "G(D2) = ${g_d2} Eh"
  echo "G(HD) = ${g_hd} Eh"
  echo "DeltaG [2 HD - H2 - D2] = ${delta_g_eh} Eh"
  echo "DeltaG = ${delta_g_kj_mol} kJ/mol"
  echo "DeltaG = ${delta_g_kcal_mol} kcal/mol"
} | tee h2_d2_to_2hd_delta_g.txt
