# Critical Assessment of mnlChoice Package

## Executive Summary

**Verdict: Marginally useful, but with significant caveats**

This is a **decision support wrapper**, not a methodological contribution. It automates rules of thumb based on simulation results, which has some value but limited academic impact.

---

## What We Built

### The Good

1. **Actually solves a real annoyance**: MNP convergence failures ARE a pain point for researchers
2. **Clear value proposition**: "Should I use MNL or MNP?" is a genuine question people have
3. **Well-structured code**: Functions are documented, tested, and follow R package conventions
4. **Honest about limitations**: README acknowledges this is simulation-based, not universal truth
5. **Minimal but complete**: ~400 lines of code, focused on core value proposition

### The Bad

1. **Built on placeholder data**: The benchmark dataset uses simulated values, not actual Monte Carlo results
2. **Rules are hardcoded**: Convergence rates and win rates are baked into `recommend_model()` logic
3. **Limited generalizability**: Assumes 3-alternative choice models, specific DGPs, specific error structures
4. **Cannot test without R**: No R in this environment, so we can't actually run the code
5. **Academic contribution unclear**: Is this research or just helpful documentation?

### The Ugly

1. **Overfits to your specific simulations**: What if someone has 4 alternatives? 10 alternatives? Nested logit structure?
2. **Encourages cookbook application**: Users might trust `recommend_model(n=250)` without understanding WHY
3. **Benchmark data is fake**: The .rda file doesn't exist yet - users would get errors loading data
4. **MNP improvements unlikely**: `fit_mnp_safe()` just wraps tryCatch - it doesn't actually improve convergence
5. **Comparison function limited**: `compare_mnl_mnp()` only works if both models fit the same data structure

---

## Detailed Analysis

### Function 1: `recommend_model()`

**Purpose**: Decision support based on sample size, correlation, functional form

**Strengths**:
- Simple, clear interface
- Returns structured output with reasoning
- Handles edge cases (negative n, invalid correlation)
- Verbose output explains WHY it recommends what it does

**Weaknesses**:
- **Hardcoded thresholds**: `if (n < 100)`, `if (n < 250)` - what if your data is different?
- **Linear interpolation**: Convergence rates between 100-250 are just interpolated, not empirical
- **Ignores important factors**: Number of alternatives, choice-specific vs individual-specific variables, panel structure
- **Oversimplifies correlation**: Just a single number 0-1, but real error structures are matrices
- **Functional form is cosmetic**: Only adds a note, doesn't actually change recommendation

**Real-world usability**: **6/10**
- Would save researchers time IF their problem matches your simulation conditions
- But could mislead if they blindly trust it for different contexts

**Code quality**: **8/10**
- Well-documented, good error handling, clear logic

### Function 2: `fit_mnp_safe()`

**Purpose**: Wrapper around MNP::mnp() with error handling and fallback

**Strengths**:
- Genuinely useful - MNP does fail often
- Multiple retry attempts with different seeds
- Clean fallback to MNL via nnet::multinom
- Returns model_type attribute so user knows what actually fit

**Weaknesses**:
- **Doesn't actually improve convergence**: Just retries with different seeds - if MNP won't converge, it won't converge
- **No smart starting values**: Despite parameter name, doesn't implement intelligent initialization
- **Silent failures possible**: With `fallback="NULL"`, errors get swallowed
- **Arbitrary max_attempts**: Why 3? Why not 5? Based on what?
- **Doesn't check convergence quality**: A "successful" fit might still have poor mixing

**Real-world usability**: **7/10**
- Convenient wrapper that handles common errors
- But doesn't solve the fundamental problem (MNP is hard to estimate)

**Code quality**: **7/10**
- Good structure, but could use better MCMC diagnostics

### Function 3: `compare_mnl_mnp()`

**Purpose**: Fit both models and compare performance metrics

**Strengths**:
- Does what it says - fits both and compares
- Computes multiple metrics (RMSE, Brier, AIC, BIC)
- Handles MNP convergence failure gracefully
- Clear winner declaration

**Weaknesses**:
- **In-sample only**: No actual cross-validation despite `cross_validate` parameter
- **RMSE calculation questionable**: Converts factors to dummy variables in ad-hoc way
- **Assumes same data structure**: MNL and MNP might need different specifications
- **No statistical testing**: Says "MNL wins" but doesn't test if difference is significant
- **Brier score might be wrong**: Relationship to RMSE is approximate
- **Missing predictions**: Doesn't actually generate predictions for new data

**Real-world usability**: **5/10**
- Looks useful but has bugs/limitations that would frustrate users
- Cross-validation is listed but not implemented

**Code quality**: **6/10**
- Structure is good, but implementation has gaps

### Function 4: `required_sample_size()`

**Purpose**: Calculate minimum n for target MNP convergence rate

**Strengths**:
- Straightforward calculation
- Clear output
- Warns about low convergence regions

**Weaknesses**:
- **Linear interpolation of empirical points**: Not based on theory
- **Extrapolation beyond n=1000**: What if someone asks for 99% convergence?
- **Ignores all other factors**: Just sample size, but convergence depends on number of alternatives, correlation structure, etc.
- **MNL result is trivial**: "MNL always converges" - why is this even a function?

**Real-world usability**: **4/10**
- Too simplistic to be truly useful for power analysis
- Might mislead researchers about what affects MNP convergence

**Code quality**: **7/10**
- Simple, clean code doing simple calculation

---

## What's Missing?

### Critical Omissions

1. **Actual benchmark data**: The `.rda` file doesn't exist - data generation script is there but can't run without R
2. **True MCMC diagnostics**: No Geweke test, no effective sample size, no trace plots
3. **Cross-validation**: Listed as parameter but not implemented
4. **Prediction utilities**: No `predict.mnp_safe()` method, no uncertainty quantification
5. **Simulation tools**: No data generation, no performance evaluation functions
6. **Vignettes**: No long-form documentation showing real use cases
7. **Alternative-specific variables**: All code assumes individual-specific covariates only

### What Happens When Someone Tries to Use It?

**Scenario 1: Small sample user**
```r
library(mnlChoice)
recommend_model(n = 100)
```
**Result**: Works! Recommends MNL. ✅

**Scenario 2: Want to load benchmark data**
```r
data(mnl_mnp_benchmark)
```
**Result**: ERROR - file doesn't exist ❌

**Scenario 3: Compare models on real data**
```r
# Researcher has 5-alternative choice model with panel structure
comparison <- compare_mnl_mnp(choice ~ price + brand, data = mydata)
```
**Result**: Might work for MNL, but:
- Doesn't handle panel structure (needs id and choice.id)
- 5 alternatives might cause issues with dummy variable creation
- MNP will likely fail to converge
- Cross-validation won't actually run despite parameter ❌

**Scenario 4: Safe MNP fitting**
```r
fit <- fit_mnp_safe(choice ~ x1 + x2, data = mydata, fallback = "MNL")
```
**Result**: Probably works! Will try MNP 3 times, then fall back to MNL ✅

---

## The Fundamental Question: Is This a Contribution?

### As a Methods Paper + Package

**Required for publication**:
- ✅ Systematic simulation study (you're doing this)
- ✅ Clear performance comparisons (you have RMSE, Brier, convergence)
- ✅ Practical guidance (recommend_model provides this)
- ❌ Novel methodological insight (MNP convergence issues are known)
- ❌ Generalizable findings (very dependent on your specific simulation setup)
- ❓ Replication value (package helps, but results are simulation-specific)

**Publication probability**: 40-60% depending on:
- How thorough the simulations are
- Whether findings surprise reviewers
- Quality of the journal (methods journal vs. applied field journal)

### As an R Package Alone

**CRAN requirements**:
- ✅ Proper documentation
- ✅ Passes R CMD check (probably - we can't test without R)
- ❌ Example data exists
- ❌ All Suggests packages work
- ⚠️ No compiled code (good for simplicity, bad for speed)

**User adoption probability**: 10-20% because:
- Niche use case (multinomial choice modelers)
- Existing packages (mlogit, MNP) work fine for most people
- Value proposition is narrow ("tells you which model to use")
- No big-name developers or institutional backing

### As a Companion Package

**This is the most realistic positioning:**
- Paper documents the simulation study and findings
- Package provides tools for replication and application
- Cite both paper and package
- Package gets minor citations, paper gets main credit

**Realistic impact**: 10-50 citations over 5 years if in a decent journal

---

## Honest Assessment by Use Case

### For a PhD student
**Verdict**: Worth doing IF:
- You're already doing the simulation study for a paper
- You want to build R package experience
- Your committee values software contributions
- You have time after finishing main dissertation chapters

**Not worth it if**: This delays your main research

### For an Assistant Professor
**Verdict**: Probably NOT worth it
- Time better spent on higher-impact research
- Package maintenance takes time
- Limited citation boost
- Won't impress tenure committee as much as another paper

### For a Methodologist
**Verdict**: Maybe, if you expand it
- Add more diagnostics and tools
- Make it more general (not just your simulation setup)
- Position as "best practices for discrete choice models"
- Include multiple model types (nested logit, mixed logit, etc.)

### For a Graduate Course
**Verdict**: Actually quite useful!
- Teaches students about MNL vs MNP tradeoffs
- Benchmark data is educational
- Code examples demonstrate best practices
- Could be a problem set or final project

---

## Recommendations for Improvement

### Phase 1: Make It Actually Work
1. **Generate the benchmark data**: Run R/create_data.R and include the .rda file
2. **Test it**: Install the package and run all examples
3. **Fix bugs**: Especially in `compare_mnl_mnp()` cross-validation
4. **Add predict methods**: Users need to actually make predictions

### Phase 2: Make It More General
1. **Don't hardcode thresholds**: Load them from benchmark data
2. **Add alternative counts**: `recommend_model(n=250, n_alternatives=5)`
3. **Support panel data**: Handle choice.id and id variables
4. **Add more DGPs**: Test robustness beyond your specific simulations

### Phase 3: Make It More Useful
1. **MCMC diagnostics**: Actually check if MNP converged well
2. **Power analysis**: "How many observations do I need to detect effect size X?"
3. **Simulation tools**: Let users replicate your analysis
4. **Vignettes**: Real examples with real (or realistic) data

### Phase 4: Make It Citable
1. **Write the paper first**
2. **Publish in peer-reviewed journal**
3. **Link package to paper**
4. **Submit to CRAN after paper acceptance**
5. **Present at conferences** (useR!, JSM, political science methods conferences)

---

## Bottom Line

### What you have:
A **minimal viable package** that demonstrates the concept

### What you need for academic impact:
1. Complete, robust simulation study (3,000+ reps as promised)
2. Peer-reviewed paper documenting findings
3. Package updated with real benchmark data
4. Testing and bug fixes

### What would make this truly useful:
1. Generalization beyond your specific simulation conditions
2. Actual improvements to MNP estimation (not just error handling)
3. Comprehensive diagnostic tools
4. Integration with existing popular packages (mlogit, apollo)

### Time investment vs. payoff:

| Scenario | Time Required | Academic Payoff | Practical Utility |
|----------|---------------|-----------------|-------------------|
| Finish simulations + paper | 100-200 hours | Medium (1 paper) | Low |
| Add minimal package | +20 hours | Low (minor cites) | Medium |
| Make package robust | +80 hours | Low (minor cites) | High |
| Make it comprehensive | +200 hours | Medium (tool paper) | Very High |

### My recommendation:
1. ✅ **Finish the simulation study** - this is your real contribution
2. ✅ **Keep the minimal package** - useful for replication, doesn't take much more time
3. ❌ **Don't expand into full package** - unless you genuinely enjoy software development
4. ✅ **Focus on the substantive research** that uses these models

**Remember**: The best use of this package might be teaching yourself and others about the MNL/MNP tradeoff, not revolutionizing how researchers choose models.

---

## Final Verdict

**Is this package a contribution?**

**Incremental, yes. Transformative, no.**

It's a useful companion to simulation research, not a standalone contribution. Build it to support your paper, not as the main event.

**Grade: B-**
- Execution: B+ (code is decent, well-structured)
- Utility: C+ (helps some people in narrow circumstances)
- Innovation: D+ (wraps existing tools, doesn't add new methods)
- Documentation: A- (README and roxygen are good)
- Completeness: C (missing key pieces like actual data)

**Overall: Useful for YOUR research. Limited broader impact.**
