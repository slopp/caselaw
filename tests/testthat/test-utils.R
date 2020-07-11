test_that("compact works", {
  expect_equal(compact(list(x = "test", y = NULL)), list(x = "test"))
})
