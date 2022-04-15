test_that("quanti ggplot2", {
  gg <- explore_uni(1:10)
  expect_is(gg, "ggplot")
})

test_that("quali ggplot2", {
  gg <- explore_uni(iris$Species)
  expect_is(gg, "ggplot")
})



