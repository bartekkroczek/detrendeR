#' Returns polynomial trend in 'signal' time-serie
#'
#' This function detects a polynomial trend of n-th degree and returns it as a vector.
#' The degree is eithe specified by the parameter 'degree' or computed from the paramters
#' 'time' and 'maxfreq' according to the formula d = 2 time maxfreq, where maxfreq
#' is maximum possible frequency of the trend.
#' The time can be recognised if the signal is a time-serie object.
#' @param signal A vector or a time-serie object. Time-sorted values of signal containing trend.
#' @param degree A positive natural number. The degree of the trend polynomial.
#' @param maxfreq A positive real number. Maximum possible trend frequency.
#' @param time A positive real number. Time span of the signal in base units.
#' @return Returns an object of a class "trend" containing vector of values of the estimated trend.
#'
#' The object also contains:
#' \item{values}{original values of the signal}
#' \item{detrended}{the difference between the original values of the signal and the trend}
#' \item{time}{vector of the time domain of the signal}
#' @seealso [getltrend()], [plot.trend()], [time.trend()], [detrended()], [orisignal()]
#' @examples
#' x <- sin(seq(0, 6, length.out=100)) + rnorm(100)
#' trend1 <- gettrend(x, maxfreq=2, time=1)
#' detrended(trend1)
#'
#' data(austres)
#' trend2 <- gettrend(austres, maxfreq=.1)
#' plot(trend2)
#' @export
gettrend <- function(signal, degree=NULL, maxfreq=NULL, time=NULL){
  if(is.null(degree)){
    if(is.null(maxfreq)){
      stop("Either 'degree' or 'maxfreq' must be specified.")
    }
    else{
      if(is.null(time)){
        if(is.ts(signal)){
          deg <- diff(range(time(signal))) * maxfreq * 2
        }
        else{
          stop("Either 'degree' or both 'time' and 'maxfreq' must be specified.")
        }
      }
      else{
        deg <- time * maxfreq * 2
      }
    }
  }
  else{
    deg <- degree
  }
  if(deg > 6){
    warning("Degree of the polynomial is greater than 6. It seems that the trend more of a regular oscilation. Consider using alternative tools.")
  }
  if(!is.null(time)){
    x <- seq(0, time, length.out=length(signal))
  }
  else if(is.ts(signal)){
    x <- as.vector(time(signal))
  }
  else{
    x <- seq(length(signal))
  }
  y <- as.vector(signal)
  m <- glm(y~stats::poly(x,degree=deg))
  retval <- structure(as.vector(predict(m)),
                      values=y,
                      detrended=as.vector(residuals(m)),
                      time=x,
                      class="trend")
  return(retval)
}


#' Returns linear trend in 'signal' time-serie
#'
#' This function detects a linear trend and returns it as a vector.
#' The time can be recognised if the signal is a time-serie object.
#' This function is a wrapper for [gettrend()].
#' @param signal A vector or a time-serie object. Time-sorted values of signal containing trend.
#' @param time A positive real number. Time span of the signal in base units.
#' @return Returns an object of a class "trend" containing vector of values of the estimated trend.
#'
#' The object also contains:
#' \item{values}{original values of the signal}
#' \item{detrended}{the difference between the original values of the signal and the trend}
#' \item{time}{vector of the time domain of the signal}
#' @seealso [gettrend()], [plot.trend()], [time.trend()], [detrended()], [orisignal()]
#' @examples
#' x <- sin(seq(0, 6, length.out=100)) + rnorm(100)
#' trend1 <- getltrend(x, time=1)
#' detrended(trend1)
#'
#' data(austres)
#' trend2 <- getltrend(austres)
#' plot(trend2)
#' @export
getltrend <- function(signal, time=NULL){
  gettrend(signal=signal, degree=1, maxfreq=NULL, time=time)
}
