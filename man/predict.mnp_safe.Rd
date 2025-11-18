\name{predict.mnp_safe}
\alias{predict.mnp_safe}
\title{Predict Method for Safe Models}
\description{
Prediction method for models fitted with fit_mnp_safe().
}
\usage{
predict.mnp_safe(object, newdata, type = c("probs", "class"), ...)
}
\arguments{
\item{object}{A model object from fit_mnp_safe().}
\item{newdata}{Data frame with new observations.}
\item{type}{Character. "probs" for probabilities, "class" for predicted class.}
\item{...}{Additional arguments.}
}
\value{
Matrix of predicted probabilities or vector of predicted classes.

}
\examples{
\dontrun{
fit <- fit_mnp_safe(choice ~ x1 + x2, data = train_data)
probs <- predict(fit, newdata = test_data, type = "probs")
classes <- predict(fit, newdata = test_data, type = "class")
}

}
