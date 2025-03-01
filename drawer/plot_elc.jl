include("setting.jl")

data_file = "data/error_EwaldELC.csv"

df = CSV.read(data_file, DataFrame)

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 400), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"$P$", ylabel = L"\mathcal{E}_r", yscale = log10)

    for (l, ms, ls, c, xdata, ydata, filter) in [("20", markerstyle[1], linestyle[1], colors[1], df[df.H .== 0.5, :rr], df[df.H .== 0.5, :error_r], 1:6), ("10", markerstyle[2], linestyle[2], colors[2], df[df.H .== 1.0, :rr], df[df.H .== 1.0, :error_r], 1:6), ("2", markerstyle[3], linestyle[3], colors[3], df[df.H .== 5.0, :rr], df[df.H .== 5.0, :error_r], 1:5)]
        # filter = ydata .> 1e-11
        fit_xdata = xdata[filter]
        fit_ydata = log10.(ydata[filter])
        @. model(x, p) = p[1] + x*p[2]
        p0 = [1.0, 1.0]
        fit = curve_fit(model, fit_xdata, fit_ydata, p0)
        scatter!(ax, xdata, ydata, label = l, marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        @show model(xdata, fit.param)
        lines!(ax, [-1:10...], 10 .^ model([-1:10...], fit.param), color = c, linestyle = :dash, linewidth = linewidth)
    end

    axislegend(ax, L"$L_x / H$", position = :rt)
    save("figs/elc_error.png", f, px_per_unit = 2)
    xlims!(ax, -0.5, 6.5)
    ylims!(ax, 1e-15, 1e2)
    f
end

f

save("figs/elc_error.pdf", f)