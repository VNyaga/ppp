# PPP - Plotting the pre- and post-test probabilities after diagnostic testing
An immediate command to plot a nomogram-like graph showing how pre-test probability evolves to post-test probability after one or more diagnostic tests. The method is based on Bayes’ theorem and is similar in spirit to the fagan plot, but allows sequential tests (“triages”).


The command requires Stata 10.1 or later versions.

To install the from SSC, type
```
ssc install ppp
```

To install the development version directly, type
```
net install ppp, from("https://raw.githubusercontent.com/VNyaga/ppp/master/")
```
