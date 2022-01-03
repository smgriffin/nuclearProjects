# import libraries

import requests
from bs4 import BeautifulSoup
import pandas as pd

# create url object
url = 'https://world-nuclear.org/information-library/facts-and-figures/world-nuclear-power-reactors-and-uranium-requireme.aspx'

# create object page
page = requests.get(url).content # <Response [200]

# obtain and parse page information to list
df_list = pd.read_html(page, header= 0)

# change list to dataframe
df = df_list[0]

# save to csv
df.to_csv("nuclearData.csv", index=False)
