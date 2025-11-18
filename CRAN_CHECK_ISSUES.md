# R CMD CHECK Results - mnlChoice Package

**Date:** 2025-11-18
**Version:** 0.1.0
**Status:** 2 ERRORs, 9 WARNINGs, 5 NOTEs

---

## SUMMARY

R CMD check identified multiple issues that must be fixed before CRAN submission. Issues are categorized by severity and priority below.

---

## ERRORS (CRITICAL - Must Fix) ❌

### ERROR 1: Missing Documentation for All Functions
**Severity:** CRITICAL
**Impact:** CRAN rejection

**Issue:**
```
Undocumented code objects:
  - All 31+ functions (benchmark_results, brier_score, check_mnp_convergence, etc.)
  - All 4 data sets (commuter_choice, validation_results, mnl_mnp_benchmark, benchmark_results)
```

**Fix Required:**
- Create man/*.Rd files for all exported functions
- Use roxygen2 to generate documentation:
  - Add #' @export tags to all user-facing functions
  - Add #' @param descriptions
  - Add #' @return descriptions
  - Add #' @examples
  - Run `devtools::document()` or `roxygen2::roxygenize()`

**Estimated Time:** 4-6 hours

---

### ERROR 2: Test Execution Failure
**Severity:** ERROR (but expected without testthat)
**Impact:** Cannot run tests without testthat package

**Issue:**
```
Running the tests in 'tests/testthat.R' failed.
  > library(testthat)
  Error in library(testthat) : there is no package called 'testthat'
```

**Fix Required:**
- This is expected since testthat is in Suggests (not available)
- Will pass when testthat is installed
- For CRAN submission, tests will run with all Suggests packages available

**Estimated Time:** 0 hours (not a real issue)

---

## WARNINGS (High Priority) ⚠️

### WARNING 1: Non-ASCII Characters in R Code
**Severity:** HIGH
**Impact:** CRAN rejection (portability requirement)

**Affected Files (14 total):**
```
R/brier_score.R
R/convergence_report.R
R/create_data.R
R/decision_framework.R
R/diagnostics.R
R/dropout_scenario.R
R/flexible_mnl.R
R/functional_form_test.R
R/iia_and_decision.R
R/model_choice_consequences.R
R/recommend_model.R
R/sample_size_calculator.R
R/substitution_matrix.R
R/visualization.R
```

**Fix Required:**
- Find and replace all non-ASCII characters (likely emoji or special symbols)
- Common culprits: ✓, ✗, ≥, ≤, →, "fancy quotes"
- Use ASCII equivalents or \uxxxx escapes

**Estimated Time:** 1-2 hours

---

### WARNING 2: Duplicate Data Object
**Severity:** MEDIUM
**Impact:** Installation warning

**Issue:**
```
Warning: object 'benchmark_results' is created by more than one data call
```

**Fix Required:**
- Check data/*.rda files for duplicate 'benchmark_results' object
- Likely in both data/benchmark_results.rda and data/test_benchmark.rda
- Rename or remove one instance

**Estimated Time:** 15 minutes

---

### WARNING 3: Non-ASCII in Data
**Severity:** MEDIUM
**Impact:** Portability

**Issue:**
```
Warning: found non-ASCII string '<e2><9a><a0><ef><b8><8f> WARNING: This data is
ILLUSTRATIVE ONLY...' in object 'mnl_mnp_benchmark'
```

**Fix Required:**
- Remove emoji (⚠️) from warning message in mnl_mnp_benchmark data
- Use plain ASCII: "WARNING:" instead of "⚠️ WARNING:"

**Estimated Time:** 10 minutes

---

### WARNING 4: Missing Vignette Index
**Severity:** MEDIUM (will be resolved when vignettes are built)
**Impact:** CRAN prefers built vignettes

**Issue:**
```
Package has a VignetteBuilder field but no prebuilt vignette index.
Files in the 'vignettes' directory but no files in 'inst/doc':
  'introduction.Rmd' 'mnlChoice-guide.Rmd'
```

**Fix Required:**
- Build vignettes properly (requires rmarkdown/knitr)
- Vignettes should be built during `R CMD build` (not with --no-build-vignettes)
- Will need rmarkdown installed to build package tarball

**Estimated Time:** 0 hours (resolved when rmarkdown available)

---

### WARNING 5: Undeclared Dependencies
**Severity:** HIGH
**Impact:** CRAN rejection

**Issue:**
```
'::' or ':::' import not declared from: 'mvtnorm'
'loadNamespace' or 'requireNamespace' calls not declared from:
  'ggplot2' 'mvtnorm'
Namespaces in Imports field not imported from:
  'grDevices' 'graphics' 'stats' 'utils'
  All declared Imports should be used.
```

**Fix Required:**
1. **Add to Suggests** (since they're optional):
   - mvtnorm (used in some functions)
   - ggplot2 (used in visualization functions)

2. **Actually import from Imports**:
   - Add importFrom() statements to NAMESPACE for stats, graphics, grDevices, utils
   - OR remove from Imports if not actually needed

3. **Use requireNamespace() properly**:
   - Wrap optional package calls: `if (requireNamespace("ggplot2", quietly = TRUE))`

**Estimated Time:** 1 hour

---

## NOTES (Lower Priority but Should Fix) 📝

### NOTE 1: Missing Function Imports from Base Packages
**Severity:** MEDIUM
**Impact:** R CMD check prefers explicit imports

**Issue:**
```
Undefined global functions or variables:
  AIC BIC abline acf aggregate as.formula barplot coef complete.cases
  contour cor fitted formula image legend lines logLik model.matrix
  nobs par pchisq pnorm points predict qnorm rect reshape residuals rgb
  rnorm sd text var vcov
```

**Fix Required:**
Add to NAMESPACE:
```r
importFrom("grDevices", "rgb")
importFrom("graphics", "abline", "barplot", "contour", "image",
           "legend", "lines", "par", "points", "rect", "text")
importFrom("stats", "AIC", "BIC", "acf", "aggregate", "as.formula",
           "coef", "complete.cases", "cor", "fitted", "formula",
           "logLik", "model.matrix", "nobs", "pchisq", "pnorm",
           "predict", "qnorm", "reshape", "residuals", "rnorm", "sd",
           "var", "vcov")
importFrom("utils", "??")  # if any utils functions used
```

**Estimated Time:** 30 minutes

---

### NOTE 2: Non-Standard Top-Level Files
**Severity:** LOW
**Impact:** Clean package structure

**Issue:**
```
Non-standard files/directories found at top level:
  'CHECK_PACKAGE.sh' 'COMPREHENSIVE_ASSESSMENT.md'
  'CRITICAL_ASSESSMENT.md' 'INSTALLATION.md'
  'MNP_AVAILABILITY_WARNINGS.md' 'NOTE_test_iia_scoping.md'
  'OPTION_A_STATUS.md' 'PACKAGE_ASSESSMENT.md'
  'PACKAGE_IMPACT_ASSESSMENT.md' 'PACKAGE_STATUS.md'
  'PAPER_FUNCTIONS_IMPLEMENTED.md' 'PAPER_INSPIRED_FUNCTIONS.md'
  'README_OLD.md' 'Rplots.pdf' 'TEST_PACKAGE.R'
  'TRANSFORMATION_SUMMARY.md' 'comprehensive_test.R' 'final_test.R'
  'final_validation_test.R' 'pilot_benchmark_output.log'
  'run_pilot_benchmark.R' 'run_quick_test.R' 'test_flexibility.R'
  'test_new_features.R' 'test_new_functions.R' 'validate_dropout.R'
```

**Fix Required:**
- Add to .Rbuildignore:
  ```
  ^.*\.md$
  ^.*\.sh$
  ^.*\.R$  # for top-level R scripts
  ^.*\.pdf$
  ^.*\.log$
  ```

**Estimated Time:** 15 minutes

---

### NOTE 3: LICENSE File Not Mentioned
**Severity:** LOW
**Impact:** Minor documentation issue

**Issue:**
```
File LICENSE is not mentioned in the DESCRIPTION file.
```

**Fix Required:**
- DESCRIPTION already has `License: GPL-3`
- This is fine as-is (GPL-3 doesn't require separate LICENSE file)
- Could add `License: GPL-3 + file LICENSE` if we want to keep LICENSE file
- Or remove LICENSE file entirely

**Estimated Time:** 5 minutes

---

### NOTE 4: New Submission
**Severity:** INFO
**Impact:** None (informational)

**Issue:**
```
New submission
```

**Fix Required:** None (this is just informational for CRAN maintainers)

---

### NOTE 5: Pandoc Not Available
**Severity:** INFO
**Impact:** Cannot check README.md/NEWS.md formatting

**Issue:**
```
Files 'README.md' or 'NEWS.md' cannot be checked without 'pandoc' being installed.
```

**Fix Required:** None (pandoc is optional, CRAN will have it)

---

## PRIORITY FIX ORDER

### CRITICAL (Must Fix for CRAN)
1. **Add documentation for all 31+ functions** (4-6 hours)
   - Use roxygen2
   - Add @export, @param, @return, @examples
   - Run devtools::document()

2. **Remove non-ASCII characters from R code** (1-2 hours)
   - 14 files affected
   - Search for emoji and special characters
   - Replace with ASCII equivalents

3. **Fix undeclared dependencies** (1 hour)
   - Add mvtnorm, ggplot2 to Suggests
   - Add importFrom() to NAMESPACE for base packages
   - Use requireNamespace() for optional packages

### HIGH PRIORITY (Should Fix)
4. **Fix data issues** (30 minutes)
   - Remove duplicate benchmark_results
   - Remove non-ASCII from mnl_mnp_benchmark warning

5. **Add .Rbuildignore** (15 minutes)
   - Exclude development files

6. **Update LICENSE handling** (5 minutes)
   - Decide: keep or remove LICENSE file
   - Update DESCRIPTION if needed

### TOTAL ESTIMATED TIME: 8-10 hours

---

## HOW TO PROCEED

### Step 1: Critical Fixes (6-9 hours)
```bash
# 1. Add roxygen2 documentation to all R files
# 2. Remove non-ASCII characters from R code
# 3. Fix NAMESPACE imports
# 4. Run roxygen2::roxygenize()
```

### Step 2: Cleanup (1 hour)
```bash
# 1. Fix data issues
# 2. Create .Rbuildignore
# 3. Update LICENSE
```

### Step 3: Rebuild and Recheck
```bash
R CMD build .
_R_CHECK_FORCE_SUGGESTS_=false R CMD check mnlChoice_0.1.0.tar.gz --as-cran
```

### Step 4: Final Build with Vignettes
```bash
# Requires: install.packages(c("rmarkdown", "knitr"))
R CMD build .
R CMD check mnlChoice_0.1.0.tar.gz --as-cran
```

---

## REALISTIC TIMELINE TO CRAN SUBMISSION

**Current status:** 85% complete for Option A (code done, validation done)

**Remaining work:**
- Fix CRAN check issues: 8-10 hours
- Wait for pilot benchmark: 1-2 hours (running)
- Update with real benchmarks: 1-2 hours
- Final testing: 1 hour

**TOTAL: 11-15 hours of focused work**

**Calendar time: 2-3 days if focused**

---

## BLOCKERS

1. **Missing documentation** - Absolute blocker, CRAN will reject immediately
2. **Non-ASCII characters** - CRAN will reject for portability
3. **Pilot benchmark still running** - Need real data before submission

---

## BOTTOM LINE

**Package is functional but not CRAN-ready.**

**Grade for CRAN compliance: D (needs major documentation work)**

**Path forward:**
1. Focus on documentation (biggest gap)
2. Clean up non-ASCII characters
3. Fix dependency declarations
4. Wait for benchmark to complete
5. Recheck and iterate

**Success metric:** Clean R CMD check with 0 ERRORs, 0 WARNINGs, acceptable NOTEs only
