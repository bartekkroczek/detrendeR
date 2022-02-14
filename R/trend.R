#' Generic print function for class 'trend'
#'
#' Prints trend detected in the signal.
#' @seealso [gettrend()], [getltrend()], [plot.trend()], [time.trend()], [detrended()], [orisignal()]
#' @export
print.trend <- function(x,...){
  print.default(as.vector(x),...)
}

#' Generic plot function for class 'trend'
#'
#' Plots trend detected in the signal alongside the signal.
#' @seealso [gettrend()], [getltrend()], [time.trend()], [detrended()], [orisignal()]
#' @export
plot.trend <- function(x,...){
  layout(matrix(c(1,2), nrow=2))
  plot.default(x=attr(x, "time"), y=attr(x, "values"), type="l", xlab="Time", ylab="Values + trend",...)
  lines(x=attr(x, "time"), y=x, col="red",...)
  plot.default(x=attr(x, "time"), y=attr(x, "detrended"), type="l", xlab="Time", ylab="Detrended",...)
}

#' Generic function for class 'trend'
#' Returns the time vector for the trend.
#' @seealso [gettrend()], [getltrend()], [plot.trend()], [detrended()], [orisignal()], [predict.trend()]
#' @export
time.trend <- function(x,...){
  attr(x, "time")
}

#' Function for class 'trend'
#'
#' Returns the detrended signal for the trend.
#' @seealso [gettrend()], [getltrend()], [plot.trend()], [time.trend()], [orisignal()], [predict.trend()]
#' @export
detrended <- function(x,...){
  attr(x, "detrended")
}

#' Function for class 'trend'
#'
#' Returns the initial signal for the trend.
#' @seealso [gettrend()], [getltrend()], [plot.trend()], [time.trend()], [detrended()], [predict.trend()]
#' @export
orisignal <- function(x,...){
  attr(x, "values")
}

#' Function for class 'trend'
#'
#' Predicts the trend for new time interval
#' Returns a 'trend' class object.
#' @seealso [gettrend()], [getltrend()], [plot.trend()], [time.trend()], [detrended()], [orisignal()]
#' @export
predict.trend <- function(x, newtime,...){
  structure(as.vector(predict(attr(x, "model"), newdata=data.frame(x=newtime))),
            values=rep(NA, length(newtime)),
            detrended=rep(NA, length(newtime)),
            time=newtime,
            model=attr(x, "model"),
            class="trend")
}
