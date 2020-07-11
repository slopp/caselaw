#' Class representing the case law API
#'
#' @name caselaw
#'
#' @section Usage:
#' \preformatted{
#' cl <- cl_client$new()
#' }
#'
#' @section Details:
#'
#' This class allows a user to interact with a case law API and provides
#' utility functions for GETs including cursor pagination and
#' the specifics of the case law query parameter structure
#'
#' The constructor respects CASE_LAW_API_KEY environment variable if set, and will
#' use it to authorize all requests
#'
#'
#' @family R6 classes
#'
#' @export
cl_client <- R6::R6Class(
  "caselaw",
  public = list(
    api_key = NULL,
    base = NULL,
    version = NULL,
    initialize = function(base = "https://api.case.law",
                          version = "v1"){
      self$api_key <- Sys.getenv("CASE_LAW_API_KEY")
      if (self$api_key == "") {
        warning("No CASE_LAW_API_KEY detected, will not be able to access some cases")
      }
      self$base <- base
      self$version <- version
    },

    raise_error = function(res) {
      if (httr::http_error(res)) {
        err <- sprintf(
          "%s request failed with %s",
          res$request$url,
          httr::http_status(res)$message
        )
        message(capture.output(str(httr::content(res))))
        stop(err)
      }
    },

    add_auth = function() {
      if(!(self$api_key == "")) {
        httr::add_headers(Authorization = paste0("Token ", self$api_key))
      } else {
        NULL
      }

    },

    # params is a list with keys as the name, value as the value
    add_url_params = function(path, params) {
      # handle double quoting parameters
      params <- lapply(params, function(x){ifelse(grepl("\\s", x), paste0('"', x, '"'), x)})
      keys <- names(params)

      if (!is.null(params)) {
        # first argument is passed as url/?key=value
        path <- paste0(path,"/?", keys[1], "=",params[[1]])

        # remaining passed as url/?key=value&key=value
        if(length(params) > 1) {
          filters <- paste(sapply(2:length(params), function(i) {
            sprintf("%s=%s", keys[i], params[[i]])
          }), collapse = "&")
          path <- paste0(path, "&", filters)
        }
      }

      #url encode everything
      URLencode(path)
    },

    GET_PAGES = function(path, writer = httr::write_memory(), parser = "parsed", limit = Inf) {
      results <- list()
      res <- self$GET(path, writer, parser)

      results <- append(results, res$results)
      c <- 0
      while (!is.null(res$`next`) && c < limit) {
        res <- self$GET_URL(res$`next`, writer, parser)
        results <- append(results, res$results)
        c <- c + 1
      }
      results
    },

    GET = function(path, writer = httr::write_memory(), parser = "parsed") {
      req <- paste0(self$base,"/", self$version, "/", path)
      self$GET_URL(url = req, writer = writer, parser = parser)
    },

    GET_URL = function(url, writer = httr::write_memory(), parser = "parsed") {
      res <- self$GET_RESULT_URL(url = url, writer = writer)
      self$raise_error(res)
      httr::content(res, as = parser)
    },

    GET_RESULT_URL = function(url, writer = httr::write_memory()) {

       httr::GET(
        url,
        self$add_auth(),
        writer
      )
    }
  )
)


