import pandas as pd
import numpy as np

TIMEOUT = 60*20


def get_time_tables():
    bouvier = ("Bouvier", pd.read_csv("data/Bouvier.csv"))
    barrett = ("Barrett", pd.read_csv("data/Barrett.csv"))
    blocks = ("BlocksWorld", pd.read_csv("data/BlocksWorld.csv"))
    overall = ("Overall", pd.concat([bouvier[1], barrett[1], blocks[1]]))

    tables = {}

    for name, df in [bouvier, barrett, blocks, overall]:
        # find the index of the column labeled "Depths"
        index = list(df.columns).index("Depths")
        # remove "Algaroba no pause" from the list of solvers
        solvers = [s for s in list(df.columns)[index + 1:] if s != "Algaroba no pause"]
        # sort the solvers
        solvers = sorted(solvers, key=lambda x: x.lower())
        # create a pandas dataframe to hold the results
        time_df = pd.DataFrame(columns=["min time", "max time", "avg time", "std time"], index=solvers)

        # for each solver, report the minimum, maximum, and average time to solve
        for solver in solvers:
            solved = df[df[solver] < TIMEOUT][solver]
            time_df.loc[solver] = [solved.min(), solved.max(), solved.mean(), solved.std()]
            
        tables[name] = time_df

    return tables


def get_sat_unsat_tables():
    bouvier = ("Bouvier", pd.read_csv("data/Bouvier.csv"))
    barrett = ("Barrett", pd.read_csv("data/Barrett.csv"))
    blocks = ("BlocksWorld", pd.read_csv("data/BlocksWorld.csv"))
    overall = ("Overall", pd.concat([bouvier[1], barrett[1], blocks[1]]))

    tables = {}

    for name, df in [bouvier, barrett, blocks, overall]:
        # find the index of the column labeled "Depths"
        index = list(df.columns).index("Depths")

        # remove "Algaroba no pause" from the list of solvers
        solvers = [s for s in list(df.columns)[index + 1:] if s != "Algaroba no pause"]
        # sort the solvers
        solvers = sorted(solvers, key=lambda x: x.lower())
        # create a pandas dataframe to hold the results
        sat_df = pd.DataFrame(columns=["\# \\textbf{sat}", "\# \\textbf{unsat}", "\# timeout"], index=solvers)

        # for each solver, report the minimum, maximum, and average time to solve
        for solver in solvers:
            solved = df[df[solver] < TIMEOUT][solver]
            if solver == "Algaroba":
                sat_unsat = df[df[solver] < TIMEOUT]["SAT/UNSAT"].apply(lambda x: eval(x)[solver.lower()])
                sat = sat_unsat.value_counts()["sat"]
                unsat = sat_unsat.value_counts()["unsat"]
                assert len(sat_unsat) == len(solved)
            else:
                sat = np.nan
                unsat = np.nan

            t_count = len(df) - len(solved)
            sat_df.loc[solver] = [sat, unsat, t_count]
            
        tables[name] = sat_df

    return tables

# get the tables for the time to solve
time_tables = get_time_tables()
# get the tables for the number of SAT/UNSAT
sat_unsat_tables = get_sat_unsat_tables()

# print the tables
for name, df in time_tables.items():
    s = df.style.set_caption(f"{name} Execution Time")
    print(s.to_latex())

for name, df in sat_unsat_tables.items():
    s = df.style.set_caption(f"{name} Result Counts")
    print(s.to_latex())