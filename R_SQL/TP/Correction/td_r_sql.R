##############################################
##### Premiers pas avec l'interface DBI -----

install.packages(c("DBI", "RMySQL", "RPostgres", "RSQLite"))

# 1. Ouvrir une connexion avec ``dbConnect``

require(DBI)
require(RPostgres)

con <- dbConnect(RPostgres::Postgres(), # RMySQL::MySQL()
                 host = "XXX.XXX.XXXX",
                 port = 8081,
                 dbname = "db_name",
                 user = "ds_test",
                 password = "pwd!")

con

# 2. Lister les tables présentes dans la base de données
dbListTables(con)

# 3. Lister les champs disponibles dans une table
dbListFields(con, "table")

# 4. Récupérer l'ensemble de la table  avec ``dbReadTable``
table_df <- dbReadTable(con, "table")
head(table_df)

# 5.
table_df <- dbGetQuery(con, "SELECT * FROM table")

##############################################
##### Sécuriser les informations de connexion -----

require(config)

conf <- config::get(file = "TP/Correction/config.yml")

# acutellement sur la config default
config::is_active("default")

# connexion
con <- dbConnect(RPostgres::Postgres(), # RMySQL::MySQL()
                 host = conf$host,
                 port = conf$port,
                 dbname = conf$dbname,
                 user = conf$user,
                 password = conf$password)
con
dbDisconnect(con)

# Changement d'environnement ?

# soit en passant directement le nom dans config
conf_prod <- config::get(
  file = "TP/Correction/config.yml",
  config = "production"
)
# attention, dans ce cas is_active retourne quand même FALSE
config::is_active("production")

# soit en fixant la variable R_CONFIG_ACTIVE
Sys.setenv(R_CONFIG_ACTIVE = "production")
conf_prod <- config::get(
  file = "TP/Correction/config.yml"
)
# attention, dans ce cas is_active retourne quand même FALSE
config::is_active("production")


##############################################
##### Requêtes paramétrables -----
require(DBI)
require(RSQLite)
library(nycflights13)

head(nycflights13::flights)
head(nycflights13::airports)
head(nycflights13::airlines)

# initialisation d'une base sqlite sur disque
con <- DBI::dbConnect(RSQLite::SQLite(),
                      dbname = "tp_r_sql_flights.sqlite")

if(dbExistsTable(con, "flights")) dbRemoveTable(con, "flights")
if(dbExistsTable(con, "airports")) dbRemoveTable(con, "airports")
if(dbExistsTable(con, "airlines")) dbRemoveTable(con, "airlines")

# ecriture de l'historique des vols
copy_to(con,
        nycflights13::flights,
        "flights",
        temporary = FALSE,
        indexes = list(
          c("year", "month", "day"),
          "carrier",
          "tailnum",
          "dest"
        )
)
# ecriture du référentiel des airports
copy_to(con,
        nycflights13::airports,
        "airports",
        temporary = FALSE,
        indexes = list("faa")
)

# ecriture du référentiel des compagnies
copy_to(con,
        nycflights13::airlines,
        "airlines",
        temporary = FALSE,
        indexes = list("carrier")
)

dbListTables(con)

# if(dbExistsTable(con, "flights")) dbRemoveTable(con, "flights")
# if(dbExistsTable(con, "airports")) dbRemoveTable(con, "airports")
# if(dbExistsTable(con, "airlines")) dbRemoveTable(con, "airline")


# 1. Que fait le code suivant ?
ex_bind <-  dbSendQuery(con, "SELECT * FROM flights WHERE year = ? AND month = ?")
data_01_2013 <- dbFetch(dbBind(ex_bind, list(2013, 1)))
data_04_2013 <- dbFetch(dbBind(ex_bind, list(2013, 4)))

# 2. Utiliser le package **glue** et la fonction **glue_sql()** pour faire la même requête
glue_sql_val <- "SELECT * FROM flights WHERE year = {year} AND month = {month}"

data_01_2013 <- dbGetQuery(con,
                           glue::glue_sql(
                             glue_sql_val,
                             year = 2013,
                             month = 1
                           )
)

data_04_2013 <- dbGetQuery(con, glue::glue_sql(glue_sql_val, year = 2013, month = 4))

# 3. Modifier votre requête **glue** pour pouvoir sélectionner plusieurs mois
glue_sql_val <- "SELECT * FROM flights WHERE year = {year} AND month IN ({month*})"

data_01_04_2013 <- dbGetQuery(con,
                           glue::glue_sql(
                             glue_sql_val,
                             year = 2013,
                             month = c(1, 4)
                           )
)


##############################################
##### dbply -----

# 1.
flights_db <- tbl(con, "flights")

# 2.
flights_db %>%
  filter(origin == "JFK") %>%
  collect()

# 3.
flights_db %>%
  filter(origin == "JFK", month == 7) %>%
  collect()

# 4.
flights_db %>%
  filter(origin == "JFK", month == 7) %>%
  arrange(desc(day)) %>%
  select(-year, -month, -origin) %>%
  collect()

# 5.
flights_db %>%
  filter(origin == "JFK") %>%
  group_by(month) %>%
  summarise(n_vol = n()) %>%
  collect()

# 6.
flights_db %>%
  filter(origin == "JFK") %>%
  group_by(month, day) %>%
  summarise(n_vol = n()) %>%
  collect()

# 7.
flights_db %>%
  filter(origin == "JFK") %>%
  group_by(month, day) %>%
  summarise(n_vol = n()) %>%
  collect() %>%
  ungroup() %>%
  summarise(mean_day = mean(n_vol))

# 8.
flights_db %>%
  group_by(carrier) %>%
  summarise(mean_dep_delay = mean(dep_delay, na.rm = T),
            mean_arr_delay = mean(arr_delay, na.rm = T)) %>%
  collect()

# 9.
flights_db %>%
  group_by(carrier) %>%
  summarise(mean_dep_delay = mean(dep_delay, na.rm = T),
            mean_arr_delay = mean(arr_delay, na.rm = T)) %>%
  mutate(mean_delay = (mean_dep_delay + mean_arr_delay) / 2) %>%
  arrange(desc(mean_delay))  %>%
  collect()

# 10.
flights_db %>%
  group_by(carrier) %>%
  summarise(mean_dep_delay = mean(dep_delay, na.rm = T),
            mean_arr_delay = mean(arr_delay, na.rm = T)) %>%
  mutate(mean_delay = (mean_dep_delay + mean_arr_delay) / 2) %>%
  arrange(desc(mean_delay))  %>%
  show_query()

# 11.
flights_db %>%
  mutate(
    trip = paste(origin, dest, sep = "-"),
    speed = distance  /(air_time/60)
  ) %>%
  group_by(trip) %>%
  summarise(mean_trip = mean(speed, na.rm = TRUE), n_trip = n()) %>%
  collect()

# 12.
airports_db <- tbl(con, "airports")

flights_db %>%
  group_by(origin) %>%
  summarise(n_vol = n()) %>%
  left_join(airports_db, by = c("origin" = "faa")) %>%
  collect()


# 13.
airlines_db <- tbl(con, "airlines")

flights_db %>%
  group_by(carrier) %>%
  summarise(mean_dep_delay = mean(dep_delay, na.rm = T),
            mean_arr_delay = mean(arr_delay, na.rm = T)) %>%
  mutate(mean_delay = (mean_dep_delay + mean_arr_delay) / 2) %>%
  left_join(airlines_db) %>%
  arrange(desc(mean_delay))  %>%
  collect()
