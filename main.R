library(tercen)
library(tidyverse)
library(neighbouRhood)
library(data.table)
library(parallel)


# initialize

ctx = tercenCtx()

seed = as.integer(ctx$op.value('seed'))
if (seed>0) set.seed(seed)
n_perm = as.integer(ctx$op.value('n_perm'))
ncores = as.integer(ctx$op.value('ncores'))


color_name <- unlist(ctx$colors)
data <- ctx$select(c(".x",".y", color_name))

objects <-
  data %>% 
  select(-.x) %>% 
  distinct(.y, .keep_all = TRUE) %>% 
  rename("ObjectNumber" =".y", "label" = color_name) %>% 
  mutate(ObjectID = ObjectNumber, ObjectName = "cell", ImageNumber = 1, group = 1 ) %>%
  as.data.table()
  
objects_relationship <-
  data %>%
  select(-color_name) %>% 
  mutate("First Object ID" = .y, "Second Object ID" = .x, group=1, ct =1) %>%
  select(-.x, -.y) %>% 
  as.data.table()


dat_baseline = apply_labels(objects, objects_relationship) %>%
  aggregate_histo()


dat_perm = rbindlist(mclapply(1:n_perm, function(x){
  dat_labels = shuffle_labels(objects)
  apply_labels(dat_labels, objects_relationship) %>%
    aggregate_histo()
},mc.cores = ncores
), idcol = 'run')

dat_p <- calc_p_vals(dat_baseline, dat_perm, n_perm = 1000, p_tresh = 0.01)

result <- dat_p %>% as_tibble %>%
  mutate(sig = as.numeric(sig), direction = as.numeric(direction))  %>%
  select(p, FirstLabel, SecondLabel)  %>% 
  mutate(.ci = 0, .ri = 0)  %>% 
  ctx$addNamespace()

ctx$save(result)
