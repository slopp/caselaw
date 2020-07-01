
#' Get Cases
#'
#' @param search A search term or phrase, case metadata and text is searched
#' @param jurisdiction A jurisdiction slug, eg. "ill" or "us". TODO: cl_get_jurisdictions()
#' @param court A court slug. TODO: cl_get_courts()
#' @param reporter A reporter id. TODO: cl_get_reporters()
#' @param docket_number A string with the docket number
#' @param decision_date_max Max search date in YYYY-MM-DD
#' @param decision_date_min Min search date in YYYY-MM-DD
#' @param name_abbreviation Case name abbreviation as a string
#'
#' @return tidy metadata about matching cases, with an emphasis on context not publication info
#' @export
cl_get_cases <- function(search = NULL,
                         jurisdiction = NULL,
                         court = NULL,
                         reporter = NULL,
                         docket_number = NULL,
                         decision_date_max = NULL,
                         decision_date_min = NULL,
                         name_abbreviation = NULL) {

  # construct query list
  params <- compact(list(search = search, jurisdiction = jurisdiction,
                         court = court, reporter = reporter,
                         docket_number = docket_number,
                         decision_date_max = decision_date_max,
                         name_abbreviation = name_abbreviation))

  # create client
  cl <- cl_client$new()
  path <- cl$add_url_params("cases", params)
  results <- cl$GET_PAGES(path)
  res <- results$results

  # parse results
  tibble::tibble(
    id = purrr::map_chr(res, "id"),
    name = purrr::map_chr(res, "name"),
    name_abbreviation = purrr::map_chr(res, "name_abbreviation"),
    decision_date = purrr::map_chr(res, "decision_date"),
    jurisdiction_id = purrr::map_chr(res, list("jurisdiction", "id")),
    jurisdiction = purrr::map_chr(res, list("jurisdiction", "slug")),
    court = purrr::map_chr(res, list("court", "name")),
    court_id = purrr::map_chr(res, list("court", "id"))
  )
}

#' Get case opinions
#'
#' @param case_id Case ID to retrieve
#'
#' @return Information on the case, 1 row per opinion
#' @export
cl_get_case_opinions <- function(case_id){
  cl <- cl_client$new()
  path <- cl$add_url_params(path = sprintf("cases/%s/", case_id),
                            params = list(full_case = "true"))
  results <- cl$GET(path)
  if(results$casebody$status != "ok"){
    stop(sprintf("Unable to fetch case %s with error %s", case_id, results$casebody$status))
  }
  res <- results$casebody$data

  # flatten into a very wordy tibble
  tibble::tibble(
    case_id = case_id,
    judges = purrr::simplify(res$judges),
    attorneys = paste(purrr::simplify(res$attorneys), collapse = " "),
    head_matter  = res$head_matter,
    author = purrr::map_chr(res$opinions, "author"),
    text = purrr::map_chr(res$opinions, "text"),
    type = purrr::map_chr(res$opinions, "type")
  )

}
