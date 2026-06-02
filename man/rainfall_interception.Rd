\name{rainfall_interception}
\alias{rainfall_interception}
\title{Daily rainfall interception (Granier et al. 1999, Eq. 3)}
\usage{rainfall_interception(p, lai, forest_type = c("broadleaved", "coniferous"),
  k = 0.5, coef = NULL, min_rain = NULL)}
\arguments{
\item{p}{Incident rainfall (mm).}
\item{lai}{Leaf area index.}
\item{forest_type}{"broadleaved" or "coniferous".}
\item{k}{Light extinction coefficient (default 0.5).}
\item{coef}{Optional named a,b,c,d overriding the default coefficients.}
\item{min_rain}{Threshold below which In = P (default 1 broadleaved, 2 coniferous).}
}
\value{Interception (mm).}
\description{Throughfall \eqn{Th = exp(a + b\,R/R0 + c\,P + d\,P^2)} and
\eqn{In = P - Th}, after Aussenac (1968). \eqn{R/R0} is percent transmitted
radiation \eqn{100\,exp(-k\,LAI)}. In is clamped to [0, P].}
\references{Aussenac G (1968) Ann. Sci. For. 25:135-156.}
