# Algaroba
An eager solver for algebraic data types

## Install Dependencies
```sh
opam install -y --deps-only .
```

## Install
```sh
dune build
dune install
```

## Test
```sh
dune test
```

## Format
```sh
dune build @fmt --auto-promote
```

## Usage
```
algaroba <query> [options]
  -o Write to an output file
  -t Set a timeout for solving (in milliseconds)
  --dont-depth-based-acyclicality-pause Normally, we do unrolling at half of the average depth. If set to true we don't do this
  --acyclicality-pause Point in depth to pause and check
  --measure Measure time spent in each step
  --z3-simplifier Use a Z3 simplifier
  --global-z3-parameter Use a Z3 global parameter
  --set-z3-solver-flag Set a Z3 solver flag to true
  --clear-z3-solver-flag Set a Z3 solver flag to false
  --assert-conjunctions Rewrite top-level conjunctions to assertions (default: false)
  --simplify-ite Rewrite if-then-else statements to use normal boolean operations  (default: false)
  --constant-prop Does propogation for variables set to symbolic constants  (default: false)
  --inline-constants Decides whether to inline constants (WARNING: choosing true is not sound as currently implemented) (default: false)
  --use-enum-test-axioms Decides whether to use the enum tester axioms or not (default: true)
  --print-depths Decides whether to print depths to stderr (default: false)
  -help  Display this list of options
  --help  Display this list of options
```

## Testing

You can run testing.py to simulate our paper results on the necessary benchmarks. This will return a csv in test/dataframes and a graph in test/graphs and print the results in the command line. There are several options that you have control over at the top of the file:

```
    timeout: default is 1200 seconds
    test_case: can be 'Barrett', 'Bouvier', 'BouvierUF', or 'blocksworld'
    output_name: the name that 
    run_pre_solvers; decides whether to run z3, cvc5, and princess for the comparison
    princess path: the path to run princess, default is 'princess'
    algaroba flags: can run the solver with different flags to compare, default is just '{"algaroba": []}', i.e. no flags
```
