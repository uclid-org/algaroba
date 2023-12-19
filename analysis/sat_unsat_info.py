import pandas as pd

TIMEOUT = 60*20

bouvier = ("Bouvier", pd.read_csv("data/Bouvier.csv"))
barrett = ("Barrett", pd.read_csv("data/Barrett.csv"))
blocks = ("BlocksWorld", pd.read_csv("data/BlocksWorld.csv"))
overall = ("Overall", pd.concat([bouvier[1], barrett[1], blocks[1]]))
non_trivial = ("Blocks World and Bouvier", pd.concat([bouvier[1], blocks[1]]))

z3_solved_that_algaroba_did_not_all_unsat = [
    '../blocksworld/blocksworld_from_13_0_1_to_11_0_3_negated_goal_bmc_23.smt2', 
    '../blocksworld/blocksworld_from_16_4_2_to_16_3_3_negated_goal_bmc_19.smt2', 
    '../blocksworld/blocksworld_from_3_4_6_to_1_9_3_negated_goal_bmc_16.smt2', 
    '../blocksworld/blocksworld_from_12_7_0_to_14_5_0_negated_goal_bmc_22.smt2'
]


def parse_algaroba_result(row):
    if row["Query Path"] in z3_solved_that_algaroba_did_not_all_unsat:
        return "unsat"
    
    if row["Query Path"].startswith("../QF_DT2/") and "Bouvier" in row["Query Path"]:
        # find the letter before \d\d.smt2
        letter = row["Query Path"][-8]
        if letter == "h":
            return "sat"
        elif letter == "b":
            return "unsat"
        else:
            raise ValueError("Unexpected letter: " + row["Query Path"])
        
    if row["Query Path"].startswith("../QF_UFDT/") and "Bouvier" in row["Query Path"]:
        # find the letter before \d\d.smt2
        letter = row["Query Path"][-8]
        if letter == "k":
            return "sat"
        elif letter == "e":
            return "unsat"
        else:
            raise ValueError("Unexpected letter: " + row["Query Path"])

    x = row["SAT/UNSAT"]
    d = eval(x)
    if d["algaroba"] == "sat":
        return "sat"
    elif d["algaroba"] == "unsat":
        return "unsat"
    else:
        return "unknown"



for benchmark in [bouvier, barrett, blocks, overall, non_trivial]:
    name = benchmark[0]
    benchmark = benchmark[1]
    benchmark["SAT/UNSAT"] = benchmark.apply(parse_algaroba_result, axis=1)

    # find the index of the column labeled "Depths"
    index = list(benchmark.columns).index("Depths")
    # remove "Algaroba no pause" from the list of solvers
    solvers = [s for s in list(benchmark.columns)[index + 1:] if s != "Algaroba no pause"]
    # sort the solvers
    solvers = sorted(solvers, key=lambda x: x.lower())

    counts_df = pd.DataFrame(columns=solvers, index=["\# sat", "\# unsat", "\# timeout"])

    for solver in solvers:
        num_sat = len(benchmark[(benchmark[solver] < TIMEOUT) & (benchmark["SAT/UNSAT"] == "sat")])
        num_unsat = len(benchmark[(benchmark[solver] < TIMEOUT) & (benchmark["SAT/UNSAT"] == "unsat")])
        num_timeout = len(benchmark[(benchmark[solver] >= TIMEOUT)])
        counts_df[solver] = [num_sat, num_unsat, num_timeout]

    s = counts_df.style.set_caption(f"{name} Result Counts")
    print(s.to_latex())

    