# World-SQL-Queries

- The following SQL queries were performed on [world_data.sql](world_data.sql) to gain insights regarding coutries. 
- SQL queries can be seen on [query_statements.sql](query_statements.sql)
- The raw outputs of the queries can be viewed on [queries_output.txt](queries_output.txt)

Included below are the queries performed and sample output of each query 

## Queries 

For each country, find its neighbor country with the highest elevation point. Report the id
and name of the country and the id and name of its neighboring country.

| c1id |      c1name      | c2id |      c2name      
|------|------------------|------|------------------
|    7 | Austria          |    6 | Switzerland
|    5 | Belize           |    3 | Mexico
|    1 | Canada           |    2 | USA
|   10 | France           |    6 | Switzerland
|    4 | Guatemala        |    3 | Mexico
|    8 | Indonesia        |    9 | Papua New Guinea
|    3 | Mexico           |    2 | USA
|    9 | Papua New Guinea |    8 | Indonesia
|   11 | Saudi Arabia     |   12 | Yemen
|    6 | Switzerland      |   10 | France
|    2 | USA              |    1 | Canada
|   12 | Yemen            |   11 | Saudi Arabia

Find the landlocked countries. Report the id(s) and name(s) of the landlocked countries.

| cid |    cname    
|-----|-------------
|   7 | Austria
|   6 | Switzerland

Find the landlocked countries which are surrounded by exactly one country. Report the id
and name of the landlocked country, followed by the id and name of the country that surrounds it.

| c1id | c1name  | c2id |   c2name    
|------|---------|------|-------------
|    7 | Austria |    6 | Switzerland

Find the accessible ocean(s) of each country. Report the name of the country and the name of
the accessible ocean(s).

| cname            |  oname   
|------------------|----------
| Belize           | Pacific
| Belize           | Atlantic
| Canada           | Pacific
| Canada           | Atlantic
| France           | Atlantic
| Guatemala        | Pacific
| Guatemala        | Atlantic
| Indonesia        | Indian
| Indonesia        | Atlantic
| Mexico           | Pacific
| Mexico           | Atlantic
| Papua New Guinea | Indian
| Papua New Guinea | Atlantic
| Saudi Arabia     | Atlantic
| Switzerland      | Atlantic
| USA              | Pacific
| USA              | Atlantic
| Yemen            | Atlantic

Find the top-10 countries with the highest average Human Development Index (HDI) over the
5-year period of 2009-2013 (inclusive).

| cid |    cname     | avghdi 
|-----|--------------|--------
|   6 | Switzerland  | 0.9328
|   2 | USA          | 0.9126
|   1 | Canada       | 0.9006
|   7 | Austria      | 0.8946
|  10 | France       | 0.8754
|  11 | Saudi Arabia | 0.8228
|   3 | Mexico       | 0.7452
|   5 | Belize       | 0.6986
|   8 | Indonesia    | 0.6738
|   4 | Guatemala    |  0.607

Find the countries that their Human Development Index (HDI) is constantly increasing over
the 5-year period of 2009-2013 (inclusive). 

| cid |    cname     
|-----|--------------
|   5 | Belize
|   1 | Canada
|  10 | France
|   4 | Guatemala
|   8 | Indonesia
|  11 | Saudi Arabia


Find all the pairs of neighboring countries that have the same most popular language. Report the names of
the countries and the language.

|    c1name    |    c2name    |  lname  
|--------------|--------------|---------
| Yemen        | Saudi Arabia | Arabic
| USA          | Canada       | English
| Switzerland  | Austria      | German
| Mexico       | Guatemala    | Spanish

Find the country with the largest span between the country's highest elevation point and the
depth of its deepest ocean. If a country has no direct access to an ocean, assume that its
ocean's depth is 0. Report the name of the country and the total span.

| cname | totalspan 
|-------|-----------
| USA   |     56508

Find the country with the longest borders (with all its neighboring countries). Report the
country and the total length of its borders.

| cname | borderslength 
|-------|---------------
| USA   |         12034
