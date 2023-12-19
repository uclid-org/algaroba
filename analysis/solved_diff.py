import pandas as pd

TIMEOUT = 60*20

bouvier = ("Bouvier", pd.read_csv("data/Bouvier.csv"))
barrett = ("Barrett", pd.read_csv("data/Barrett.csv"))
blocks = ("BlocksWorld", pd.read_csv("data/BlocksWorld.csv"))
overall = ("Overall", pd.concat([bouvier[1], barrett[1], blocks[1]]))
non_trivial = ("Blocks World and Bouvier", pd.concat([bouvier[1], blocks[1]]))


for benchmark in [bouvier, barrett, blocks, overall, non_trivial]:
    name = benchmark[0]
    benchmark = benchmark[1]

    # find the queries where Algaroba succeeded and no one else did
    algaroba_solved = set(benchmark[benchmark["Algaroba"] < TIMEOUT]["Query Path"].unique())
    z3_solved = set(benchmark[benchmark["Z3"] < TIMEOUT]["Query Path"].unique())
    cvc5_solved = set(benchmark[benchmark["cvc5"] < TIMEOUT]["Query Path"].unique())
    princess_solved = set(benchmark[benchmark["Princess"] < TIMEOUT]["Query Path"].unique())

    others = z3_solved | cvc5_solved | princess_solved
    diff = algaroba_solved - others

    print(f"Algaroba solved {len(diff)} queries in {name} that no other solver solved.")


    