using CSV, DataFrames
using CairoMakie, LaTeXStrings
using Statistics
using LsqFit
using EwaldSummations

colors = [:red, :blue, :green, :purple, :orange, :brown, :pink, :gray, :black]
markersize = 15
linestyle = [:solid, :dash, :dot, :dashdot, :dashdotdot]
linewidth = 2
markerstyle = [:rect, :circle, :diamond, :utriangle, :dtriangle, :rtriangle, :ltriangle]
strokecolor = :black
strokewidth = 0.5