# from fuzzing import *
# import z3
import os
import time
import glob
import subprocess
from concurrent.futures import ProcessPoolExecutor, as_completed
import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime
import pandas as pd

timeout = 1200
reduction_timeout = timeout
test_case = "Barrett"
output_name = ""
run_pre_solvers= True
princess_path = "princess"
cvc5_path = "cvc5"
z3_path = "z3"
algaroba_flags = {"algaroba2": []}


# A function that runs the Ocaml that does the reductions for us
def run_ocaml_on_smt2(smt2_file_path, ocaml_executable_path = "_build/default/bin/algaroba2.exe", flags = []):
    cmd = [ocaml_executable_path] + flags + [smt2_file_path]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout = reduction_timeout)
    except subprocess.TimeoutExpired as timeErr:
        outs = timeErr.stdout
        return "TIMEOUT", outs
    
    if result.returncode != 0:
        return f"Error: {result.stderr}", []
    else:
        # Get the outputs
        file_output, depths_list = result.stdout, result.stderr
        return file_output, depths_list



# For Barrett benchmarks

if test_case == "Barrett":
    folder1 = "test/QF_DT2/20172804-Barrett/barrett-jsat/tests/v1/"
    folder2 = "test/QF_DT2/20172804-Barrett/barrett-jsat/tests/v2/"
    folder3 = "test/QF_DT2/20172804-Barrett/barrett-jsat/tests/v3/"
    folder5 = "test/QF_DT2/20172804-Barrett/barrett-jsat/tests/v5/"
    folder10 = "test/QF_DT2/20172804-Barrett/barrett-jsat/tests/v10/"
    typedfolder1 = "test/QF_DT2/20172804-Barrett/barrett-jsat/typed/v1/"
    typedfolder2 = "test/QF_DT2/20172804-Barrett/barrett-jsat/typed/v2/"
    typedfolder3 = "test/QF_DT2/20172804-Barrett/barrett-jsat/typed/v3/"
    typedfolder5 = "test/QF_DT2/20172804-Barrett/barrett-jsat/typed/v5/"
    typedfolder10 = "test/QF_DT2/20172804-Barrett/barrett-jsat/typed/v10/"

    folders = {"test/QF_DT2/20172804-Barrett/barrett-jsat/tests/v1/": glob.glob(folder1 + "*.smt2"),
            "test/QF_DT2/20172804-Barrett/barrett-jsat/tests/v2/": glob.glob(folder2 + "*.smt2"),
            "test/QF_DT2/20172804-Barrett/barrett-jsat/tests/v3/": glob.glob(folder3 + "*.smt2"),
            "test/QF_DT2/20172804-Barrett/barrett-jsat/tests/v5/": glob.glob(folder5 + "*.smt2"),
            "test/QF_DT2/20172804-Barrett/barrett-jsat/tests/v10/": glob.glob(folder10 + "*.smt2"),
            "test/QF_DT2/20172804-Barrett/barrett-jsat/typed/v1/": glob.glob(typedfolder1 + "*.smt2"),
            "test/QF_DT2/20172804-Barrett/barrett-jsat/typed/v2/": glob.glob(typedfolder2 + "*.smt2"),
            "test/QF_DT2/20172804-Barrett/barrett-jsat/typed/v3/": glob.glob(typedfolder3 + "*.smt2"),
            "test/QF_DT2/20172804-Barrett/barrett-jsat/typed/v5/": glob.glob(typedfolder5 + "*.smt2"),
            "test/QF_DT2/20172804-Barrett/barrett-jsat/typed/v10/": glob.glob(typedfolder10 + "*.smt2")
            }        
elif test_case == "Bouvier":
    folders = {"test/QF_DT2/20210312-Bouvier/": glob.glob("test/QF_DT2/20210312-Bouvier/*smt2")}
elif test_case == "BouvierUF":
    folders = {}
    for i in range(16244440, 16244640): #16244640
        folder = "test/QF_UFDT/20210312-Bouvier/" + str(i) + "/"
        folders[folder] = glob.glob(folder + "*.smt2")
elif test_case == "blocksworld":
    folders = {"test/blocksworld/": glob.glob("test/blocksworld/*.smt2")}
    folders = folders = {"test/blocksworld/": ["test/blocksworld/blocksworld_from_18_0_3_to_4_13_4_negated_goal_bmc_3.smt2"]}
else:
    folders = {}
    print("ERROR: Not given a valid test case")

# Will take in a file name
# returns: the runtime for z3 pre/post-reduction, cvc5 pre/post reduction, mc2 post red
# whether each of these return sat or unsat
# and whether this value violates sat/unsat
def reduction_on_file(file_name, folder):
    doesnt_match = False
    print(file_name)

    # Running algaroba with all of the flags that we want
    algaroba_results = {}
    algaroba_times = {}
    ground_truth = "T"
    for flag_key in algaroba_flags.keys():
        start_time = time.time()
        algaroba_result, depths_list = run_ocaml_on_smt2(file_name, flags = algaroba_flags[flag_key])
        if (ground_truth == "sat" and algaroba_result == "unsat") or (ground_truth == "unsat" and algaroba_result == "sat"):
            doesnt_match = True
        ground_truth = algaroba_result
        algaroba_time = time.time() - start_time

        print(algaroba_result, ": ", file_name)

        if algaroba_result == "TIMEOUT":
            print("We timeout on " + file_name)
            total_time = timeout + 1
            algaroba_time = total_time
            algaroba_result = "T"
            algaroba_results[flag_key] = "T"
            algaroba_times[flag_key] = total_time
        elif algaroba_result[:40] == "Error: Fatal error: exception Stack overflow"[:40]:
            print("We overflow on " + file_name)
            total_time = timeout + 1
            algaroba_time = total_time
            algaroba_result = "SO"
            algaroba_results[flag_key] = "T"
            algaroba_times[flag_key] = total_time
        else:
            algaroba_results[flag_key] = algaroba_result
            algaroba_times[flag_key] = algaroba_time


    if run_pre_solvers:
        # # z3 solver for pre reduction
        start_time = time.time()
        z3_result = os.popen(z3_path + " -T:" + str(timeout) + " " + file_name)
        z3_result = z3_result.read()[0]
        total_time = time.time() - start_time
        z3_result = z3_result
        if z3_result == "s":
            z3_time = total_time
        elif z3_result == "u":
            z3_time = total_time
        else:
            z3_time= timeout + 1

        # cvc5 solver for pre-reduction
        start_time = time.time()
        pre_reduction_cvc5 = os.popen(cvc5_path + " --tlimit=" + str(timeout * 1000) + " " + file_name)
        pre_reduction_cvc5 = pre_reduction_cvc5.read()
        total_time = time.time() - start_time

        if pre_reduction_cvc5 != "":
            pre_reduction_cvc5 = pre_reduction_cvc5[0]
            if pre_reduction_cvc5 == "s":
                cvc5_time_pre = total_time
                cvc5_result = "s"
            elif pre_reduction_cvc5 == "u":
                cvc5_time_pre = total_time
                cvc5_result = "u"
            else:
                cvc5_time_pre = timeout + 1
                cvc5_result = "T"
        else:
            cvc5_time_pre = timeout + 1
            cvc5_result = "T"

                # princess solver
        start_time = time.time()

        start_time = time.time()
        pre_reduction_princess = os.popen(princess_path + " +quiet -timeout=" + str(timeout * 1000) + " " + file_name)
        pre_reduction_princess = pre_reduction_princess.read()
        princess_time = time.time() - start_time
        if pre_reduction_princess[:3] == "sat":
            princess_result = "s"
        elif pre_reduction_princess[:5] == "unsat":
            princess_result = "u"
        else:
            princess_result = "T"
            princess_time = timeout + 1

    if run_pre_solvers:
        if algaroba_result == "sat":
            if z3_result == "u":# or file_name[-8] == "e":
                doesnt_match = True
        elif algaroba_result == "unsat":
            if z3_result == "s":# or file_name[-8] == "k":
                doesnt_match = True

    
    if not run_pre_solvers:
        z3_time, cvc5_time_pre, princess_time = timeout + 1, timeout +1, timeout +1
        z3_result, cvc5_result, princess_result = "doesn't matter", "doesn't matter", "doesnt matter"

    return file_name, depths_list, [algaroba_times, z3_time, cvc5_time_pre, princess_time], [algaroba_results, z3_result, cvc5_result, princess_result], doesnt_match
    

def make_graph(algaroba,z3, cvc5, princess): 
    if run_pre_solvers:
        data_lists = list(algaroba.values()) + [z3, cvc5, princess]
    else:
        data_lists = list(algaroba.values())
    max_value = timeout

    # Calculate percentages for each list
    percentages = []
    for data in data_lists:
        counts, _ = np.histogram(data, bins=np.arange(max_value + 1))
        cumulative_counts = np.cumsum(counts)
        percentage = cumulative_counts / len(data) * 100
        percentages.append(percentage)

    # Create x-values from 0 to max_value
    x = np.arange(max_value + 1)

    # Ensure x and percentage have the same length
    x = x[:len(percentages[0])]

    # Plot each line
    colors = ['g', 'r', 'b', 'c', 'm']
    labels = list(algaroba.keys()) + ["Z3", "CVC5", "Princess"]
    if not run_pre_solvers:
        percentages, colors, labels = percentages, colors[:len(algaroba.keys())], labels[:len(algaroba.keys())]
    for i, percentage in enumerate(percentages):
        plt.plot(x, percentage, color=colors[i], label= labels[i])

    # Set x and y labels
    plt.xlabel('Time (seconds)')
    plt.ylabel('Percentage of Queries Solved')



    # Add legend
    plt.legend(loc='center left', bbox_to_anchor=(1, 0.5))

    plt.savefig("test/graphs/" + output_name + datetime.now().strftime("%Y-%m-%d%H:%M:%S") + '.png', dpi=300, bbox_inches = "tight")


    # Show the plot
    # plt.show()


if __name__ == '__main__':
    z3, cvc5, princess = [], [], []
    filenames, depths = [], []
    sat_unsat = []

    algaroba_times = {}
    algaroba_results = {}
    for flag_key in algaroba_flags.keys():
        algaroba_results[flag_key] = {"SAT": 0, "UNSAT":0, "TIMEOUT":0, "ERROR": 0, "STACK OVERFLOW": 0}
        algaroba_times[flag_key] = []


    z3_results = {"SAT": 0, "UNSAT":0, "TIMEOUT":0}
    cvc5_results = {"SAT": 0, "UNSAT":0, "TIMEOUT":0}
    princess_results = {"SAT": 0, "UNSAT":0, "TIMEOUT":0}
   
    incorrects = []

    with ProcessPoolExecutor() as executor:
        futures = {executor.submit(reduction_on_file, file, folder): (folder, file) for folder, file_list in folders.items() for file in file_list}
        for future in as_completed(futures):
            file_name, depths_list, times, results, doesnt_match = future.result()

            for flag_key in algaroba_flags.keys():
                algaroba_times[flag_key].append(times[0][flag_key])
                if results[0][flag_key] == "sat":
                    algaroba_results[flag_key]['SAT'] += 1
                elif results[0][flag_key] == "unsat":
                    algaroba_results[flag_key]['UNSAT'] += 1
                elif results[0][flag_key] == 'T':
                    algaroba_results[flag_key]['TIMEOUT'] +=1
                elif results[0][flag_key] == 'SO':
                    algaroba_results[flag_key]['STACK OVERFLOW'] +=1
                else:
                    algaroba_results[flag_key]['ERROR'] += 1

            if run_pre_solvers:
                z3.append(times[1])
                cvc5.append(times[2])
                princess.append(times[3])
            filenames.append(file_name)
            depths.append(depths_list)
            sat_unsat.append(results[0])

            if run_pre_solvers:
                results[0]['z3'] = results[1]
                results[0]['cvc5'] = results[2]
                results[0]['princess'] = results[3]

                if results[1] == "s":
                    z3_results['SAT'] += 1
                elif results[1] == "u":
                    z3_results['UNSAT'] += 1
                else:
                    z3_results['TIMEOUT'] += 1

                if results[2] == "s":
                    cvc5_results['SAT'] += 1
                elif results[2] == "u":
                    cvc5_results['UNSAT'] += 1
                else:
                    cvc5_results['TIMEOUT'] += 1

                if results[3] == "s":
                    princess_results['SAT'] += 1
                elif results[3] == "u":
                    princess_results['UNSAT'] += 1
                else:
                    princess_results['TIMEOUT'] += 1

            if doesnt_match:
                incorrects.append(futures[future])
            

    for key in algaroba_times.keys():
        print("Algaroba ", key, "Times ", algaroba_times[key])
    if run_pre_solvers:
        print("Z3 Times: ", z3)
        print("CVC5 Times: ", cvc5)
        print("Princess Times: ", princess)

    for key in algaroba_results.keys():
        print("Algaroba:", key,"(SAT / UNSAT / TIMEOUT / ERROR / STACK OVERFLOW): ", algaroba_results[key]['SAT'], "/", algaroba_results[key]['UNSAT'], "/", algaroba_results[key]['TIMEOUT'], "/", algaroba_results[key]['ERROR'], "/",algaroba_results[key]['STACK OVERFLOW'])

    if run_pre_solvers:
        print("Z3 (SAT / UNSAT / TIMEOUT): ", z3_results['SAT'], "/", z3_results['UNSAT'], "/", z3_results['TIMEOUT'])
        print("CVC5 Pre-processing (SAT / UNSAT / TIMEOUT): ", cvc5_results['SAT'], "/", cvc5_results['UNSAT'], "/", cvc5_results['TIMEOUT'])
        print("Princess Pre-processing (SAT / UNSAT / TIMEOUT): ", princess_results['SAT'], "/", princess_results['UNSAT'], "/", princess_results['TIMEOUT'])

    
    print("DOESNT MATCH: ", incorrects)

    make_graph(algaroba_times, z3 ,cvc5, princess)

    if run_pre_solvers: 
        new_dict = {"Query Path": filenames,  "SAT/UNSAT": sat_unsat, "Depths": depths}
        for key in algaroba_times.keys():
            new_dict[key] = algaroba_times[key]

        new_dict["z3 Time"] = z3
        new_dict["CVC5 Time"] = cvc5
        new_dict["Princess Time"] = princess    
        df = pd.DataFrame(new_dict)
    else:
        new_dict = {"Query Path": filenames,  "SAT/UNSAT": sat_unsat, "Depths": depths}
        for key in algaroba_times.keys():
            new_dict[key] = algaroba_times[key]
        df = pd.DataFrame(new_dict)

    df.to_csv("test/dataframes/" + output_name + datetime.now().strftime("%Y-%m-%d%H:%M:%S") + ".csv")