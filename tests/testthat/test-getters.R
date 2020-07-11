
test_that("parameters are added correctly", {
  cl <- cl_client$new()
  path <- "test"
  path_appended <- cl$add_url_params(path, list(full_case = "true"))
  expect_equal(path_appended, "test/?full_case=true")
  path_appended2 <- cl$add_url_params(path, list(full_case = "true",court = "us"))
  expect_equal(path_appended2, "test/?full_case=true&court=us")
  path_appended3 <- cl$add_url_params(path, list(search = "has a space"))
  expect_equal(path_appended3, "test/?search=%22has%20a%20space%22")
})


test_that("paging limit is enforced", {
  # stub out the GET calls to check the paging loop
  cl <- cl_client$new(base = "fakeo", version = "v1")
  orig_get <- httr::GET
  on.exit({
    assignInNamespace("GET", orig_get, "httr")
  })
  myGET <- function(...){
    structure(
      list(
       status_code = 200L,
       content = list(results = list("bar"),
                      `next` = "not null"),
       headers = list(`Content-Type` = "")
      ),
      class = "response"
    )
  }
  assignInNamespace("GET", myGET, "httr")
  result <- cl$GET_PAGES("foo", limit = 5, parser = "raw")
  expect_equal(length(result), 6)
})

test_that("no API key prints a warning", {

})

test_that("golden test: check for case ", {
  # golden test means it'll break if either I break the code
  # OR the API changes... check both!

})

test_that("golden test: check for non-argued opinion", {
  # golden test means it'll break if either I break the code
  # OR the API changes... check both!

})

test_that("golden test: check for argued opinion with types", {
  # golden test means it'll break if either I break the code
  # OR the API changes... check both!

})
