#### Test NULL input ####
test_that("user_pio_selection handles NULL input correctly", {
  expect_null(user_pio_selection(NULL, NULL))
})