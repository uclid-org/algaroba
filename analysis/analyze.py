from matplotlib import pyplot as plt
from matplotlib import rc
import matplotlib.pyplot as plt
plt.close("all")
rc("font", **{"family":"serif","serif":["Computer Modern Roman"], "size":15})
rc("text", usetex=True)
import pandas as pd
import numpy as np

timeout = 60*20

CB_color_cycle = ['#377eb8', '#ff7f00', '#4daf4a',
                  '#f781bf', '#984ea3', '#e41a1c', '#dede00']

def color(solver):
    solver = solver.lower()
    match solver:
        case "algaroba":
            return CB_color_cycle[3]
        case "cvc5":
            return CB_color_cycle[1]
        case "z3":
            return CB_color_cycle[2]
        case "princess":
            return CB_color_cycle[4]
        case _ if not solver.startswith("vb wo/"):
            return CB_color_cycle[0]
        case _:
            return color(solver.split(" ")[-1])

def marker(solver):
    solver = solver.lower()
    match solver:
        case "algaroba":
            return 'v'
        case "cvc5":
            return 'D'
        case "z3":
            return 'o'
        case "princess":
            return 'X'
        case _ if not solver.startswith("vb"):
            return 's'
        case _:
            return 'P'

def get_solvers(df):
    # find the index of the column labeled "Depths"
    index = list(df.columns).index("Depths")
    # remove "Algaroba no pause" from the list of solvers
    solvers = [s for s in list(df.columns)[index + 1:] if s != "Algaroba no pause"]
    solvers = sorted(solvers, key=lambda v: v.upper())
    return solvers

def compute_score(points, vb_points, data):
    total = len(data)
    solved = len(vb_points[vb_points < timeout])
    return 1 - (solved / total), -sum(points)

def virtual_bests(points):
    solvers = list(points.keys())
    vbs = {}
    df = pd.DataFrame(points)
    df = df.fillna(timeout)
    for solver in solvers:
        others = [s for s in solvers if s != solver]
        vb = df[others].min(axis=1)
        vbs[solver] = vb

    vb = df[solvers].min(axis=1)
    vbs["VB"] = vb
    return vbs

def contribution_scores(points, data):
    solvers = points.keys()
    vbs = virtual_bests(points)
    for solver in solvers:
        score = compute_score(points[solver], vbs[solver], data)
        vbs[solver] = score
    
    return vbs

files = ["data/BlocksWorld.csv", "data/Bouvier.csv"]

csvs = {}
for csv in files:
    # read the csv file
    data = pd.read_csv(csv)
    # get the name of the csv file
    csv = csv.split("/")[-1].split(".")[0]
    csv = csv.replace("BlocksWorld", "Blocks world")
    # add the data to the dictionary
    csvs[csv] = data

def plot_time_line():
    for csv, data in csvs.items():
        points = {}

        solvers = get_solvers(data)

        for solver in solvers:
            solver = solver
            d = data[solver]
            points[solver] = d

        scores = contribution_scores(points, data)
        # sort solvers by score
        ranks = {}
        for i, solver in enumerate(sorted(solvers, key=lambda s: scores[s], reverse=True)):
            ranks[solver] = i + 1

        for solver in solvers:
            points[solver] = points[solver][points[solver] < timeout].sort_values().reset_index(drop=True)

        # let us make a simple graph
        plt.figure(figsize=[7, 5])
        ax = plt.subplot(111)

        # set the limits
        # find the max value in the data
        topmost = max([(int(v.shape[0] / 10) + 1) * 10 for v in points.values()])
        # find the first index where the difference between rows is greater than some bound
        # this is where we want to start the graph
        bound = 0.15
        lowest = max(points["Princess"].gt(points["Algaroba"] + bound).idxmax(), points["Algaroba"].gt(points["Princess"] + bound).idxmax())
        # lowest = 0

        # set the step size for x as whatever is needed to have 10 ticks
        count_step = int((topmost - lowest) / 10)
        # set the step size for y as whatever is needed to have 10 ticks
        time_step = int(timeout / 10)

        labels = {}
        for i, solver in enumerate(solvers):
            solved_by_solver = len(points[solver])
            total_queries = len(data)
            percent = solved_by_solver / total_queries
            percent = round(percent * 100, 2)
            percent = f'({percent}\% solved)'
            rank = f"{ranks[solver]}. " if solver in ranks else ""
            labels[solver] = f"{rank}{solver} {percent}"

        leftmost = int(min([v.min() for v in points.values()]))
        rightmost = int(max([v.max() for v in points.values()]))

        # create a line chart with the number of rows that have a value of less than timeout
        for k in solvers:
            v = points[k]
            # plot all the points in v with the same color and label them k
            ax.plot(v, range(1, len(v) + 1), color=color(k), alpha=0.25, linewidth=4)
            ax.plot(v, range(1, len(v) + 1), color=color(k), alpha=1, linewidth=0, label=labels[k], marker=marker(k), markersize=6, markerfacecolor='white', markeredgewidth=1, markeredgecolor=color(k))

        if timeout - rightmost < time_step:
            # add a verticle line at the timeout
            ax.axvline(x=timeout, color='black', linestyle='dashed', alpha=1, linewidth=1.5, label=f'Timeout')

        if len(data) - topmost < count_step:
            # add a horizontal line at number of queries
            ax.axhline(y=len(data), color='black', linestyle='dotted', alpha=1, linewidth=2.5, label="All Queries")

        ax.set_xlabel(f'Time Elapsed (s)')
        ax.set_ylabel(f'Number of Queries Solved')
        ax.set_title(f'{csv} ({len(data)} Queries, {timeout}s Timeout)')

        # add the legend at the top left
        legend = ax.legend(loc='upper left' if csv == "Bouvier" else "best", fancybox=True, framealpha=0.75)

        # add more ticks
        ax.set_yticks(np.arange(lowest, topmost + count_step + 1, step=count_step))
        ax.set_xticks(np.arange(timeout + time_step + 1, step=time_step))
        
        ax.set_ylim(lowest, topmost + count_step * 1.05)
        ax.set_xlim(leftmost, rightmost + time_step * 1.05)
        
        # remove tick marks
        ax.xaxis.set_tick_params(size=0)
        ax.yaxis.set_tick_params(size=0)

        # set the grid on
        ax.grid('on')
        ax.spines['right'].set_color((1, 1, 1))
        ax.spines['top'].set_color((1, 1, 1))

        # add space between axis and label
        ax.xaxis.labelpad = 10
        ax.yaxis.labelpad = 10

        plt.tight_layout()
        plt.savefig(f'plots/{csv.lower().replace(" ", "")}_line.pdf')
        plt.clf()

plot_time_line()
