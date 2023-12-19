import pandas as pd

# load the blowup data
bouvier = ("Bouvier", pd.concat([pd.read_csv("data/blowup/blowup_bouvier.csv"), pd.read_csv("data/blowup/blowup_bouvier_extra.csv")]))
barrett = ("Barrett", pd.read_csv("data/blowup/blowup_barrett.csv"))
blocks = ("Blocks", pd.read_csv("data/blowup/blowup_blocksworld.csv"))
non_trivial = ("Non-trivial", pd.concat([bouvier[1], blocks[1]]))
overall = ("Overall", pd.concat([bouvier[1], barrett[1], blocks[1]]))

# create a pandas dataframe to hold the results
blowup_df = pd.DataFrame(columns=["min length before", "max length before", "avg length before", "median length before",
                                  "min length after", "max length after", "avg length after", "median length after",
                                  "min blowup", "max blowup", "avg blowup", "median blowup", "std blowup"],
                         index=["Bouvier", "Barrett", "Blocks", "Non-trivial", "Overall"])

# for each dataset, report the minimum, maximum, and average blowup
for name, df in [bouvier, barrett, blocks, non_trivial, overall]:
    blowup_df.loc[name] = [df['length-before'].min(), df['length-before'].max(), df['length-before'].mean(), df['length-before'].median(),
                           df['length-after'].min(), df['length-after'].max(), df['length-after'].mean(), df['length-after'].median(),
                           df['ratio'].min(), df['ratio'].max(), df['ratio'].mean(), df['ratio'].median(), df['ratio'].std()]

# rotate the dataframe
blowup_df = blowup_df.transpose()

s = blowup_df.style.set_caption(f"Blowup Analysis")
print(s.to_latex())

