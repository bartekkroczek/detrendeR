#' Generic print function for class 'trend'
#'
#' Prints trend detected in the signal.
#' @seealso [gettrend()], [getltrend()], [plot_trend()], [time_trend()], [detrended()], [orisignal()]
#' @export
print_trend <- function(x,...){
  print.default(as.vector(x),...)
}

#' Generic plot function for class 'trend'
#'
#' Plots trend detected in the signal alongside the signal.
#' @seealso [gettrend()], [getltrend()], [time_trend()], [detrended()], [orisignal()]
#' @export
plot_trend <- function(x,...){
  layout(matrix(c(1,2), nrow=2))
  plot.default(x=attr(x, "time"), y=attr(x, "values"), type="l", xlab="Time", ylab="Values + trend",...)
  lines(x=attr(x, "time"), y=x, col="red",...)
  plot.default(x=attr(x, "time"), y=attr(x, "detrended"), type="l", xlab="Time", ylab="Detrended",...)
}

#' Generic function for class 'trend'
#' Returns the time vector for the trend.
#' @seealso [gettrend()], [getltrend()], [plot.trend()], [detrended()], [orisignal()]
#' @export
time_trend <- function(x,...){
  attr(x, "time")
}

#' Function for class 'trend'
#'
#' Returns the detrended signal for the trend.
#' @seealso [gettrend()], [getltrend()], [plot_trend()], [time_trend()], [orisignal()]
#' @export
detrended <- function(x,...){
  attr(x, "detrended")
}

#' Function for class 'trend'
#'
#' Returns the initial signal for the trend.
#' @seealso [gettrend()], [getltrend()], [plot_trend()], [time_trend()], [detrended()]
#' @export
orisignal <- function(x,...){
  attr(x, "values")
}
