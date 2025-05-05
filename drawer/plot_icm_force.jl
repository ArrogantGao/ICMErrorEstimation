include("setting.jl")

data_file = "data/error_ICM_Ewald2D_force.csv"

df = CSV.read(data_file, DataFrame)


begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)

    ax1 = Axis(f[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)
    ax2 = Axis(f[1, 2], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)

    for (l, H, ms, ls, c) in [("20", 0.5, markerstyle[1], linestyle[1], colors[1]), ("10", 1.0, markerstyle[2], linestyle[2], colors[2]), ("2", 5.0, markerstyle[3], linestyle[3], colors[3])]
        scatter!(ax1, df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M], df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r], label = l, marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)

        filter = df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r] .> 1e-9
        xdata = df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M][filter]
        ydata = df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r][filter]

        fit_x = [0:20...]
        fit_y = exp_fit(xdata, ydata, (- 2π * H / 10) * log10(exp(1)), fit_x)
        lines!(ax1, fit_x, fit_y, color = c, linestyle = :dash, linewidth = linewidth)
    end
    axislegend(ax1, L"L_x / H", position = :lb)
    xlims!(ax1, 0, 20)
    ylims!(ax1, 1e-14, 10)
    text!(ax1, 19.5, 1e-1, text = "(a)", fontsize = 30, align = (:right, :bottom))

    for (l, γ, ms, ls, c) in [("0.3", 0.3, markerstyle[1], linestyle[1], colors[1]), ("0.6", 0.6, markerstyle[2], linestyle[2], colors[2]), ("1.0", 1.0, markerstyle[3], linestyle[3], colors[3])]
        scatter!(ax2, df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :M], df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :error_r], label = l, marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)

        filter = df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :error_r] .> 1e-9
        xdata = df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :M][filter]
        ydata = df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :error_r][filter]

        fit_x = [0:40...]
        fit_y = exp_fit(xdata, ydata, log10(γ) + (- 2π * 1.0 / 10) * log10(exp(1)), fit_x)
        lines!(ax2, fit_x, fit_y, color = c, linestyle = :dash, linewidth = linewidth)
    end
    axislegend(ax2, L"\gamma", position = :lb)
    xlims!(ax2, 0, 30)
    ylims!(ax2, 1e-14, 10)
    text!(ax2, 29, 1e-1, text = "(b)", fontsize = 30, align = (:right, :bottom))

    save("figs/icm_error_force.pdf", f)

    f
end

f