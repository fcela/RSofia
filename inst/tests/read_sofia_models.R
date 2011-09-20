path_dir <- "../SofiaModels/"

model_names   <- list.files(path_dir)
models        <- vector("list", length(model_names))
names(models) <- model_names 

for(i in 1:length(model_names)) {
  models[[i]] <- scan(paste(path_dir, model_names[i], sep="/"), what = double(), quiet = TRUE)
}

save(models, file = "models.RData")
