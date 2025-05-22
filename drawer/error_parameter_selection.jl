include("setting.jl")

data_file = "data/error_parameter_select.csv"

df = CSV.read(data_file, DataFrame)

begin
    sp1 = 1
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)
    ax1 = Axis(f[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)
    ax2 = Axis(f[1, 2], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)

    for (s, l, c, ls, ms, M0, er0) in [(3.0, L"10^{-4}", colors[1], linestyle[1], markerstyle[1], 9, 1e-4), (4.0, L"10^{-8}", colors[2], linestyle[2], markerstyle[2], 17, 1e-8), (5.0, L"10^{-12}", colors[3], linestyle[3], markerstyle[3], 25, 1e-12)]
        scatter!(ax1, [M0], [er0], marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        lines!(ax1, df[df.H .== 1.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.s .== s, :M], df[df.H .== 1.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.s .== s, :error_r], color = c, linestyle = :dash, linewidth = linewidth, label = l)
    end

    # x_data_1 = df[df.H .== 0.5 .&& df.γu .== 1 .&& df.γd .== 1, :M][1:3]
    # y_data_1 = df[df.H .== 0.5 .&& df.γu .== 1 .&& df.γd .== 1, :error_r][1:3]
    # @. model(x, p) = p[1] + x*p[2]
    # p0 = [1.0, 1.0]
    # fit = curve_fit(model, x_data_1, y_data_1, p0)
    # lines!(ax1, [-1:10...], 10 .^ model([-1:10...], fit.param), color = colors[1], linestyle = :dash, linewidth = linewidth)

    xlims!(ax1, 0, 30)
    ylims!(ax1, 1e-14, 1e1)
    text!(ax1, 28.5, 1, text = "(a)", fontsize = 30, align = (:right, :center))

    sp2 = 1
    for (s, l, c, ls, ms, M0, er0) in [(3.0, "3.0", colors[1], linestyle[1], markerstyle[1], 16, 1e-4), (4.0, "4.0", colors[2], linestyle[2], markerstyle[2], 31, 1e-8), (5.0, "5.0", colors[3], linestyle[3], markerstyle[3], 45, 1e-12)]
        scatter!(ax2, [M0], [er0], label = l, marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        lines!(ax2, df[df.H .== 1.0 .&& df.γu .== 1.0 .&& df.γd .== 1.0 .&& df.s .== s, :M], df[df.H .== 1.0 .&& df.γu .== 1.0 .&& df.γd .== 1.0 .&& df.s .== s, :error_r], color = c, linestyle = :dash, linewidth = linewidth)
    end
    axislegend(ax1, L"\epsilon", position = :lb)

    xlims!(ax2, 0, 50)
    ylims!(ax2, 1e-14, 1e1)
    text!(ax2, 47.5, 1, text = "(b)", fontsize = 30, align = (:right, :center))

    save("figs/error_parameter_selection.pdf", f)
    save("figs/error_parameter_selection.svg", f)
    f
end