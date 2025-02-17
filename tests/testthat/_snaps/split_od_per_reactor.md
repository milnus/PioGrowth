# No fixed_intercept nor zero_point

    Code
      split_od_per_reactor(input, fixed_intercept = F, add_zero_point = F)
    Output
      [1] "[split_od_per_reactor] - STARING"
      [1] "[split_od_per_reactor] - add_zero_point: FALSE"
      [1] "[split_od_per_reactor] - fixed_intercept: FALSE"
      $P01
      $P01$calibration_model
      
      Call:
      FUN(formula = ..1, data = X[[i]])
      
      Coefficients:
      (Intercept)       pio_od  
          0.04202      0.79832  
      
      
      $P01$calibtation_data
        name pio_od manual_od
      1  P01   0.01      0.05
      2  P01   1.20      1.00
      
      
      $P02
      $P02$calibration_model
      
      Call:
      FUN(formula = ..1, data = X[[i]])
      
      Coefficients:
      (Intercept)       pio_od  
          0.04202      0.79832  
      
      
      $P02$calibtation_data
        name pio_od manual_od
      3  P02   0.01      0.05
      4  P02   1.20      1.00
      
      

# Add fixed_intercept

    Code
      split_od_per_reactor(input, fixed_intercept = T, add_zero_point = F)
    Output
      [1] "[split_od_per_reactor] - STARING"
      [1] "[split_od_per_reactor] - add_zero_point: FALSE"
      [1] "[split_od_per_reactor] - fixed_intercept: TRUE"
      $P01
      $P01$calibration_model
      
      Call:
      FUN(formula = ..1, data = X[[i]])
      
      Coefficients:
      pio_od  
      0.8336  
      
      
      $P01$calibtation_data
        name pio_od manual_od
      1  P01   0.01      0.05
      2  P01   1.20      1.00
      
      
      $P02
      $P02$calibration_model
      
      Call:
      FUN(formula = ..1, data = X[[i]])
      
      Coefficients:
      pio_od  
      0.8336  
      
      
      $P02$calibtation_data
        name pio_od manual_od
      3  P02   0.01      0.05
      4  P02   1.20      1.00
      
      

# Add zero_point

    Code
      split_od_per_reactor(input, fixed_intercept = F, add_zero_point = T)
    Output
      [1] "[split_od_per_reactor] - STARING"
      [1] "[split_od_per_reactor] - add_zero_point: TRUE"
      [1] "[split_od_per_reactor] - fixed_intercept: FALSE"
      $P01
      $P01$calibration_model
      
      Call:
      FUN(formula = ..1, data = X[[i]])
      
      Coefficients:
      (Intercept)       pio_od  
          0.02083      0.81612  
      
      
      $P01$calibtation_data
        name pio_od manual_od
      1  P01   0.01      0.05
      2  P01   1.20      1.00
      3  P01   0.00      0.00
      
      
      $P02
      $P02$calibration_model
      
      Call:
      FUN(formula = ..1, data = X[[i]])
      
      Coefficients:
      (Intercept)       pio_od  
          0.02083      0.81612  
      
      
      $P02$calibtation_data
          name pio_od manual_od
      3    P02   0.01      0.05
      4    P02   1.20      1.00
      3.1  P02   0.00      0.00
      
      

# Both fixed_intercept and zero_point

    Code
      split_od_per_reactor(input, fixed_intercept = T, add_zero_point = T)
    Output
      [1] "[split_od_per_reactor] - STARING"
      [1] "[split_od_per_reactor] - add_zero_point: TRUE"
      [1] "[split_od_per_reactor] - fixed_intercept: TRUE"
      $P01
      $P01$calibration_model
      
      Call:
      FUN(formula = ..1, data = X[[i]])
      
      Coefficients:
      pio_od  
      0.8336  
      
      
      $P01$calibtation_data
        name pio_od manual_od
      1  P01   0.01      0.05
      2  P01   1.20      1.00
      
      
      $P02
      $P02$calibration_model
      
      Call:
      FUN(formula = ..1, data = X[[i]])
      
      Coefficients:
      pio_od  
      0.8336  
      
      
      $P02$calibtation_data
        name pio_od manual_od
      3  P02   0.01      0.05
      4  P02   1.20      1.00
      
      

