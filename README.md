# detrendeR - remove trend from signal and avoid artifacts

This package provides a small set of functions that detect and remove linear or polynomial trends 
in the time-series signal. The main functions are '*getltrend*' and '*gettrend*'. This package 
does not depend on any other package or function outside of the 'stat' namespace.

## Installation


```r
library(devtools)
devtools::install_github("bartekkroczek/detrendeR")

# or build with documentation
devtools::install_github("bartekkroczek/detrendeR", build_vignettes = TRUE)
```

## Rationals

There is often to see a **trend** in the time series. It can be understood as a systematic pattern
(e.g. rising or falling) that disturbs the stationarity of the signal. Removing this trend
is important for many reasons, including to emphasize the oscillatory nature of the signal.

 


```r
n <- 48 # no. of data points
time <- 1 # how many sec artifical signal lasts
freq <- 6 # frequency of miningful oscilaltion
t <- seq(0, time, length.out = n)
set.seed(123) # make runif getting this same result every time
noise <- runif(n)
trend <- seq(0.01, 3, length.out = n)
sine <- sin(2 * pi * freq * t) / 2
signal <- sine + trend + noise

f <- seq_along(t) / time
y <- fft(signal)
mag <- sqrt(Re(y)^2 + Im(y)^2) * 2 / n

layout(matrix(c(1, 2), 2, 1, byrow = TRUE))
plot(t, signal,
     type = "l", xlab = "Time [s]", ylab = "sine + trend + noise",
     main = "Example signal containing 6 Hz oscillation, trend and noise"
)
plot(f[1:length(f) / 2], mag[1:length(f) / 2],
     type = "l", xlab = "Frequency [Hz]", ylim = c(0, 0.5),
     ylab = "Amplitude", main = "Frequency spectra, oscillation is hard to spot"
)
```

![](detrendeR_files/figure-html/signal-1.png)<!-- -->

Although the oscillation in the signal is quite distinct, the trend makes it barely
noticeable in the spectrum.

A popular method of getting rid of a trend is to "filter" the signal with a moving average.
However, this can lead to frequency artifacts, as shown in (@placeholder). 


```r
roll_mean <- (function(x, n = 5) filter(x, rep(1 / n, n), sides = 2))
roll_mean_ord  <- 5 # how many points averaged

mov_avg <- na.omit(signal - roll_mean(signal, roll_mean_ord))

f <- seq_along(mov_avg) / time
y <- fft(mov_avg)
mag <- sqrt(Re(y)^2 + Im(y)^2) * 2 / n

layout(matrix(c(1, 2), 2, 1, byrow = TRUE))
plot(seq_along(mov_avg) + floor(roll_mean_ord / 2), mov_avg,
     type = "l", xlab = "Time [s]", ylab = "sine + noise + artifacts?",
     main = "Effect of moving avg trend removal method"
)
plot(f[1:length(f) / 2], mag[1:length(f) / 2],
     type = "l", xlab = "Frequency [Hz]", ylim = c(0, 0.5), ylab = "Amplitude",
     main = "The desired effect is clearer, but there are also potential artifacts"
)
arrows(x0 = 15.1, y0 = 0.37, x1 = 9.1, y1 = 0.17, lwd = 0.8)
arrows(x0 = 15.4, y0 = 0.37, x1 = 12.05, y1 = 0.185, lwd = 0.8)
arrows(x0 = 15.7, y0 = 0.37, x1 = 16, y1 = 0.165, lwd = 0.8)
arrows(x0 = 16.0, y0 = 0.37, x1 = 17.95, y1 = 0.13, lwd = 0.8)
text(x = 15.6, y = 0.43, label = "Artifacts?")
arrows(x0 = 3.9, y0 = 0.38, x1 = 6.8, y1 = 0.22)
text(x = 3.75, y = 0.43, label = "Desired effect")
```

![](detrendeR_files/figure-html/moving_avg-1.png)<!-- -->

As an alternative, we propose a small set of functions that allows to detect and remove a
linear or polynomial trend in the time series without contaminating signal.


```r
library(detrendeR)

detrend <- detrendeR::getltrend(signal)

f <- seq_along(t) / time
y <- fft(detrended(detrend))
mag <- sqrt(Re(y)^2 + Im(y)^2) * 2 / n

layout(matrix(c(1, 2), 2, 1, byrow = TRUE))
plot(t, detrended(detrend),
     type = "l", xlab = "Time [s]", ylab = "sine + noise",
     main = "Signal detrended with detrendeR::getltrend"
)
plot(f[1:length(f) / 2], mag[1:length(f) / 2],
     type = "l", xlab = "Frequency [Hz]", ylim = c(0, 0.5),
     ylab = "Amplitude", main = "The desired effect is sound, artifacts are neglected"
)
```

![](detrendeR_files/figure-html/detrendeR-1.png)<!-- -->


## Usage

### Random data 


```r
n <- 48 # no. of data points
time <- 1 # how many sec artifical signal lasts
freq <- 6 # frequency of miningful oscilaltion
t <- seq(0, time, length.out = n)
noise <- runif(n)
trend <- seq(0.01, 3, length.out = n) + (sin(2 * pi * 2 * t) / 2)
sine <- sin(2 * pi * freq * t) / 2
signal <- sine + trend + noise
```

### Remove and plot linear trend 


```r
detrend <- detrendeR::getltrend(signal)
plot(detrend)
```

![](detrendeR_files/figure-html/lin_trend-1.png)<!-- -->

### Remove polynomial trend by setting a degree


```r
detrend <- detrendeR::gettrend(signal, degree = 3)
plot(detrend)
```

![](detrendeR_files/figure-html/pol_deg-1.png)<!-- -->

### ... or set degree automatically


```r
detrend <- detrendeR::gettrend(signal, maxfreq = 3, time = 1)
plot(detrend)
```

![](detrendeR_files/figure-html/pol_auto-1.png)<!-- -->

### Get detrended signal


```r
detrend <- detrendeR::gettrend(signal, degree = 5)

time  <- time(detrend) # same as time  <- t
orig  <- orisignal(detrend) # same as orig  <- signal
res <- detrended(detrend)

layout(matrix(c(1, 2), 2, 1, byrow = TRUE))
plot(time, orig, type = "l", xlab = "Time [s]", ylab = "Val", main = "Original signal")
plot(time, res, type = "l", xlab = "Time [s]", ylab = "Val", main = "Detrended signal")
```

![](detrendeR_files/figure-html/detrended-1.png)<!-- -->


## Authors
**Tomasz Smoleń**, <tomasz.smolen@uj.edu.pl>, [ORCID](https://orcid.org/0000-0003-1884-4909)

**Bartłomiej Kroczek**, <bartek.kroczek@doctoral.uj.edu.pl>, [ORCID](https://orcid.org/0000-0002-4632-636X)

## Cite as 

<div id="refs"></div>

## Reproducibility 


```r
sessionInfo()
#> R version 4.1.2 (2021-11-01)
#> Platform: x86_64-pc-linux-gnu (64-bit)
#> Running under: EndeavourOS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/libopenblasp-r0.3.19.so
#> LAPACK: /usr/lib/liblapack.so.3.10.0
#> 
#> locale:
#>  [1] LC_CTYPE=en_GB.UTF-8       LC_NUMERIC=C              
#>  [3] LC_TIME=pl_PL.UTF-8        LC_COLLATE=en_GB.UTF-8    
#>  [5] LC_MONETARY=pl_PL.UTF-8    LC_MESSAGES=en_GB.UTF-8   
#>  [7] LC_PAPER=pl_PL.UTF-8       LC_NAME=C                 
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=pl_PL.UTF-8 LC_IDENTIFICATION=C       
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] detrendeR_0.9
#> 
#> loaded via a namespace (and not attached):
#>  [1] digest_0.6.29   R6_2.5.1        jsonlite_1.7.3  magrittr_2.0.2 
#>  [5] evaluate_0.14   highr_0.9       stringi_1.7.6   rlang_1.0.0    
#>  [9] cli_3.1.1       jquerylib_0.1.4 bslib_0.3.1     rmarkdown_2.11 
#> [13] tools_4.1.2     stringr_1.4.0   xfun_0.29       yaml_2.2.2     
#> [17] fastmap_1.1.0   compiler_4.1.2  htmltools_0.5.2 knitr_1.37     
#> [21] sass_0.4.0
```
