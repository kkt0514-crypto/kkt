#!/usr/bin/env bash
# maestro: raw
#SBATCH --job-name=h2d2hd-thermo-corr
#SBATCH --partition=32core_partition
#SBATCH --nodelist=node4
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=00:10:00
#SBATCH --output=h2d2hd-thermo-corr-%j.out
#SBATCH --error=h2d2hd-thermo-corr-%j.err

set -euo pipefail
python3 isotope_thermochemistry.py
