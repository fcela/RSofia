svm_to_df <- function(x) {

  MAX_INDEX <- 0

  response <- double(length(x))
  temp_ops <- vector("list", length(x))

  for(i in seq_along(x)) {

    temp_ops[[i]] <- strsplit(x[i], " ")[[1]]
    response[i] <- as.numeric(temp_ops[[i]][1])
    temp_ops[[i]] <- temp_ops[[i]][-1]
    temp_ops[[i]] <- sapply(temp_ops[[i]], strsplit, ":")
    temp_ops[[i]] <- sapply(temp_ops[[i]], as.numeric)
    temp_ops[[i]] <- t(temp_ops[[i]])
    TEMP_MAX_INDEX <- temp_ops[[i]][nrow(temp_ops[[i]]),1]
    MAX_INDEX <- ifelse(TEMP_MAX_INDEX > MAX_INDEX, TEMP_MAX_INDEX, MAX_INDEX)

  }

  res <- matrix(0, nrow = length(x), ncol = MAX_INDEX)

  for(i in 1:length(x)) {
    res[i,][temp_ops[[i]][,1]] <- temp_ops[[i]][,2]
  }

  res <- cbind(response, res)
  res <- as.data.frame(res)

  names(res)[1] <- "Y"
  names(res)[2:ncol(res)] <- paste("X", 1:(ncol(res)-1), sep = "")

  return (res) 

}

