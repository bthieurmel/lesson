con <- dbConnect(RSQLite::SQLite(), ":memory:")

dbWriteTable(con, "mtcars", mtcars)
rs <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
dbFetch(rs)
dbClearResult(rs)


require(RPostgres)

con <- dbConnect(RPostgres::Postgres(), # RMySQL::MySQL()
                 host = "ns6623384.ip-151-80-105.eu",
                 port = 8081,
                 dbname = "enedisprev",
                 user = "ds_test",
                 password = "ds_test_2020!")

dbListTables(con)

dbReadTable(con, "preveol_ref")

dbListFields(con, "preveol_ref")

dbGetQuery(con, "SELECT DISTINCT \"ID\" FROM preveol_point")

dbGetQuery(con, 'SELECT COUNT(*)  FROM preveol_point GROUP BY "ID"')

con <- dbConnect(RSQLite::SQLite(), ":memory:")
dbWriteTable(con, "mtcars", mtcars)
cyl_code <- "4"
dbGetQuery(con, paste0("SELECT * FROM mtcars WHERE  cyl = ", cyl_code ,""))

cyl_code <- "4; DROP TABLE mtcars"
dbGetQuery(con, paste0("SELECT * FROM mtcars WHERE  cyl = ", cyl_code ,""))

dbSendQuery(con, "")


con <- dbConnect(RSQLite::SQLite(), ":memory:")
dbWriteTable(con, "mtcars", mtcars)

simple_glue <- glue::glue_sql("SELECT * FROM mtcars WHERE cyl = {val_cyl}",
                              val_cyl = 4,n.con = con)

simple_glue
head(dbGetQuery(con, simple_glue), 2)

simple_bind <-  dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = ?")
dbBind(simple_bind, list(4))
head(dbFetch(simple_bind), n = 2)

multiple_bind <-  dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = ? AND am = ?")
dbBind(multiple_bind, list(4, 0))
head(dbFetch(multiple_bind), n = 2)

mtcars %>% filter("am" == 0)

mtcars %>% mutate("wt_sq2" = wt ^ 2)


mtcars_mod <- mtcars %>% group_by(cyl) %>%
  mutate(mean_mpg = mean(mpg)) %>%
  select(mpg, cyl, mean_mpg)
head(mtcars_mod)


mtcars %>% group_by(am, vs) %>%
  summarise(
    min_mpg = min(mpg),
    max_mpg = max(mpg),
    n_rows = n()
  )

mutate(am_vs = case_when(
  am == 0 & vs == 0 ~ "Nothing", am == 0 & vs == 1 ~ "Vs only",
  am == 1 & vs == 0 ~ "Am only", am == 1 & vs == 1 ~ "Am & Vs",
  TRUE ~ "Other"
))



con <- dbConnect(RSQLite::SQLite(), ":memory:")

mtcars$name <- row.names(mtcars)
copy_to(dest = con,
        df = mtcars,
        name = "mtcars",
        indexes = list("name")
)
dbWriteTable(con, "mtcars", mtcars)

mtcars_con <- tbl(con, "mtcars")
mtcars_con

first_query <- mtcars_con %>%
  filter(am == 0, vs == 1,  cyl == 6)  %>%
  mutate(wt_sq = wt ^ 2) %>%
  select(mpg, am, vs, cyl, name, wt, wt_sq)


first_query %>% show_query()

group_query <- mtcars_con %>%
  group_by(am, vs)  %>%
  summarise(
    min_mpg = min(mpg, na.rm = T),
    max_mpg = max(mpg, na.rm = T),
    n = n()
  )

group_query %>% show_query()
group_query %>% collect()


sql_query <- mtcars_con %>%
  group_by(am, vs)  %>%
  summarise(
    n_r = n(),
    n_sql  = "COUNT(*)",
    mean_sql = AVG(mpg)
  )

sql_query %>% show_query()
sql_query %>% collect()


library(nycflights13)

## Chargement des trois tables du jeu de données
head(flights)


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


ex_bind <-  dbSendQuery(con, "SELECT * FROM flights WHERE year = ? AND month = ?")
data_01_2013 <- dbFetch(dbBind(ex_bind, list(2013, 1)))
data_04_2014 <- dbFetch(dbBind(ex_bind, list(2013, 5)))
