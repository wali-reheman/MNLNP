\name{plot_recommendation_regions}
\alias{plot_recommendation_regions}
\title{Plot Recommendation Regions}
\description{
Creates a 2D plot showing recommended model by sample size and correlation.
}
\usage{
plot_recommendation_regions(n_range = c(50, 1000), correlation_range = c(0, 0.8), ...)
}
\arguments{
\item{n_range}{Range of sample sizes to plot. Default c(50, 1000).}
\item{correlation_range}{Range of correlations. Default c(0, 0.8).}
\item{...}{Additional plotting arguments.}
}
\value{
A heatmap showing recommendation regions.

}
\examples{
\dontrun{
plot_recommendation_regions()
}

}
