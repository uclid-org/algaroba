import pandas as pd

# load data/blocksworld-others.csv
others = pd.read_csv('data/blocksworld-others.csv')

# load data/blocksworld-justpause.csv
justpause = pd.read_csv('data/blocksworld-justpause.csv')

# remove the algaroba column of others
others = others.drop(columns=['Algaroba', 'Algaroba no pause'])

# keep only the Query Path and algaroba columns of justpause
justpause = justpause[['Query Path', 'Algaroba']]

# inner join the two dataframes on Query Path
combined = pd.merge(others, justpause, on='Query Path')

# save the combined dataframe to data/blocksworld.csv
combined.to_csv('data/BlocksWorld.csv', index=False)

# load data/BouvierNoUF.csv
nouf = pd.read_csv('data/BouvierNoUF.csv')

# load data/BouvierUF.csv
uf = pd.read_csv('data/BouvierUF.csv')

# concat the two dataframes
combined = pd.concat([nouf, uf])

# save the combined dataframe to data/bouvier.csv
combined.to_csv('data/Bouvier.csv', index=False)