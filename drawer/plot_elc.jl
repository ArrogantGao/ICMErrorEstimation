include("setting.jl")

data_file = "data/error_EwaldELC.csv"

df = CSV.read(data_file, DataFrame)

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 400), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"$R$", ylabel = L"\mathcal{E}_r", yscale = log10)

    for (l, ms, ls, c, xdata, ydata, filter) in [("20", markerstyle[1], linestyle[1], colors[1], df[df.H .== 0.5 .&& df.i .== 1, :rr], df[df.H .== 0.5 .&& df.i .== 1, :error_r], 1:5), ("10", markerstyle[2], linestyle[2], colors[2], df[df.H .== 1.0 .&& df.i .== 1, :rr], df[df.H .== 1.0 .&& df.i .== 1, :error_r], 1:5), ("2", markerstyle[3], linestyle[3], colors[3], df[df.H .== 5.0 .&& df.i .== 1, :rr], df[df.H .== 5.0 .&& df.i .== 1, :error_r], 1:5)]
        # filter = ydata .> 1e-11
        fit_xdata = xdata[filter]
        fit_ydata = ydata[filter]
        
        fit_x = [-1:0.1:6...]
        fit_y = exp_fit(fit_xdata, fit_ydata, (- 2π) * log10(exp(1)), fit_x)
        lines!(ax, fit_x, fit_y, color = c, linestyle = :dash, linewidth = linewidth)

        scatter!(ax, xdata, ydata, label = l, marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
    end

    axislegend(ax, L"$L_x / H$", position = :rt)
    xlims!(ax, -0.5, 6.5)
    ylims!(ax, 1e-15, 1e2)
    f
end

f

save("figs/elc_error.pdf", f)
save("figs/elc_error.svg", f)