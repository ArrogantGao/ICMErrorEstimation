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

function exp_fit(xdata, ydata, a, xs)
    @. model(x, p) = p[1] + x * a
    p0 = [0.0]
    fit = curve_fit(model, xdata, log10.(ydata), p0)
    p = fit.param
    fit_y = model(xs, p)
    return 10.0 .^ fit_y
end