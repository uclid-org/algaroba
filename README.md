# Algaroba
An eager solver for algebraic data types

## Install Dependencies
First [install `opam` and `dune`](https://ocaml.org/docs/up-and-running). This was tested using dune version 3.10.0, opam version 2.1.5, and OCaml version 5.0.0. Then do
```sh
opam install -y --deps-only .
```

## Install
```sh
dune build
dune install
```


## Usage
```
algaroba <query> [options]
  -o Write to an output file
  -t Set a timeout for solving (in milliseconds)
  --z3-simplifier Use a Z3 simplifier.
  --dont-depth-based-acyclicality-pause Normally, we do unrolling at half of the average depth. If set to true we don't do this
  --acyclicality-pause Point in depth to pause and check
  --measure Measure time spent in each step
  --global-z3-parameter Use a Z3 global parameter.
  --set-z3-solver-flag Set a Z3 solver flag to true.
  --clear-z3-solver-flag Set a Z3 solver flag to false.
  --assert-conjunctions Rewrite top-level conjunctions to assertions (default: false)
  --simplify-ite Rewrite if-then-else statements to use normal boolean operations  (default: false)
  --constant-prop Does propagation for variables set to symbolic constants  (default: false)
  --inline-constants Decides whether to inline constants (WARNING: choosing true is not sound as currently implemented) (default: false)
  --use-enum-test-axioms Decides whether to use the enum tester axioms or not (default: true)
  --print-depths Decides whether to print depths to stderr (default: false)
  -help  Display this list of options
  --help  Display this list of options
```
