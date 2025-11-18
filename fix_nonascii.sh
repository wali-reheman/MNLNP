#!/bin/bash
# Fix non-ASCII characters in R files

cd /home/user/MNLNP/R

for file in brier_score.R convergence_report.R create_data.R decision_framework.R diagnostics.R dropout_scenario.R flexible_mnl.R functional_form_test.R iia_and_decision.R model_choice_consequences.R recommend_model.R sample_size_calculator.R substitution_matrix.R visualization.R; do
  echo "Processing: $file"

  # Replace non-ASCII characters
  sed -i 's/⚠️/WARNING:/g' "$file"
  sed -i 's/⚠/WARNING:/g' "$file"
  sed -i 's/✓/[OK]/g' "$file"
  sed -i 's/✔/[OK]/g' "$file"
  sed -i 's/✗/[X]/g' "$file"
  sed -i 's/→/->/g' "$file"
  sed -i 's/←/<-/g' "$file"
  sed -i 's/≥/>=/g' "$file"
  sed -i 's/≤/<=/g' "$file"
  sed -i 's/±/+\\/-/g' "$file"
  sed -i 's/≈/~=/g' "$file"
  sed -i 's/×/x/g' "$file"
  sed -i 's/•/*/g' "$file"
  sed -i 's/–/-/g' "$file"
  sed -i 's/—/--/g' "$file"
done

echo "Done! Checking for remaining non-ASCII..."
cd /home/user/MNLNP/R
grep -P '[^\x00-\x7F]' *.R | wc -l
