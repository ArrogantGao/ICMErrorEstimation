include("setting.jl")

data_file = "data/error_parameter_select_force.csv"

df = CSV.read(data_file, DataFrame)

begin
    sp1 = 1
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 800), fontsize = 20)
    ax1 = Axis(f[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)
    ax2 = Axis(f[1, 2], xlabel = L"L_z", ylabel = L"\mathcal{E}_r", yscale = log10)

    ax3 = Axis(f[2, 1], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)
    ax4 = Axis(f[2, 2], xlabel = L"L_z", ylabel = L"\mathcal{E}_r", yscale = log10, xticks = [0, 20, 40, 60, 80, 100])

    for (s, l, c, ls, ms, M0, er0, L0) in [(3.0, L"10^{-4}", colors[1], linestyle[1], markerstyle[1], 9, 1e-4, 15), (4.0, L"10^{-8}", colors[2], linestyle[2], markerstyle[2], 17, 1e-8, 30), (5.0, L"10^{-12}", colors[3], linestyle[3], markerstyle[3], 25, 1e-12, 45)]
        scatter!(ax1, [M0], df[df.H .== 1.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.s .== s .&& df.M .== M0 .&& df.Lz .== L0, :error_r], marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        lines!(ax1, df[df.H .== 1.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.s .== s .&& df.Lz .== L0, :M][1:end - 1], df[df.H .== 1.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.s .== s .&& df.Lz .== L0, :error_r][1:end - 1], color = c, linestyle = :dash, linewidth = linewidth, label = l)
    end

    # x_data_1 = df[df.H .== 0.5 .&& df.γu .== 1 .&& df.γd .== 1, :M][1:3]
    # y_data_1 = df[df.H .== 0.5 .&& df.γu .== 1 .&& df.γd .== 1, :error_r][1:3]
    # @. model(x, p) = p[1] + x*p[2]
    # p0 = [1.0, 1.0]
    # fit = curve_fit(model, x_data_1, y_data_1, p0)
    # lines!(ax1, [-1:10...], 10 .^ model([-1:10...], fit.param), color = colors[1], linestyle = :dash, linewidth = linewidth)

    xlims!(ax1, 0, 30)
    ylims!(ax1, 1e-13, 1e1)
    text!(ax1, 28.5, 1, text = "(a)", fontsize = 30, align = (:right, :center))

    sp2 = 1
    for (s, l, c, ls, ms, M0, L0, er0) in [(3.0, L"10^{-4}", colors[1], linestyle[1], markerstyle[1], 9, 15, 1e-4), (4.0, L"10^{-8}", colors[2], linestyle[2], markerstyle[2], 17, 30, 1e-8), (5.0, L"10^{-12}", colors[3], linestyle[3], markerstyle[3], 25, 45, 1e-12)]
        scatter!(ax2, [L0], df[df.H .== 1.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.s .== s .&& df.M .== M0 .&& df.Lz .== L0, :error_r], marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        lines!(ax2, df[df.H .== 1.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.s .== s .&& df.M .== M0, :Lz][2:end], df[df.H .== 1.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.s .== s .&& df.M .== M0, :error_r][2:end], color = c, linestyle = :dash, linewidth = linewidth, label = l)
    end

    axislegend(ax1, L"\epsilon", position = :lb)

    xlims!(ax2, 0, 50)
    ylims!(ax2, 1e-13, 1e1)
    text!(ax2, 47.5, 1, text = "(b)", fontsize = 30, align = (:right, :center))


    gamma = 1.0

    for (s, l, c, ls, ms, M0, L0, er0) in [(3.0, L"10^{-4}", colors[1], linestyle[1], markerstyle[1], 16, 32, 1e-4), (4.0, L"10^{-8}", colors[2], linestyle[2], markerstyle[2], 31, 62, 1e-8), (5.0, L"10^{-12}", colors[3], linestyle[3], markerstyle[3], 45, 91, 1e-12)]
        scatter!(ax3, [M0], df[df.H .== 1.0 .&& df.γu .== gamma .&& df.γd .== gamma .&& df.s .== s .&& df.M .== M0 .&& df.Lz .== L0, :error_r], marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)  
        lines!(ax3, df[df.H .== 1.0 .&& df.γu .== gamma .&& df.γd .== gamma .&& df.s .== s .&& df.Lz .== L0, :M][1:end - 1], df[df.H .== 1.0 .&& df.γu .== gamma .&& df.γd .== gamma .&& df.s .== s .&& df.Lz .== L0, :error_r][1:end - 1], color = c, linestyle = :dash, linewidth = linewidth, label = l)
    end

    for (s, l, c, ls, ms, M0, L0, er0) in [(3.0, L"10^{-4}", colors[1], linestyle[1], markerstyle[1], 16, 32, 1e-4), (4.0, L"10^{-8}", colors[2], linestyle[2], markerstyle[2], 31, 62, 1e-8), (5.0, L"10^{-12}", colors[3], linestyle[3], markerstyle[3], 45, 91, 1e-12)]
        scatter!(ax4, [L0], df[df.H .== 1.0 .&& df.γu .== gamma .&& df.γd .== gamma .&& df.s .== s .&& df.M .== M0 .&& df.Lz .== L0, :error_r], marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        lines!(ax4, df[df.H .== 1.0 .&& df.γu .== gamma .&& df.γd .== gamma .&& df.s .== s .&& df.M .== M0, :Lz][2:end], df[df.H .== 1.0 .&& df.γu .== gamma .&& df.γd .== gamma .&& df.s .== s .&& df.M .== M0, :error_r][2:end], color = c, linestyle = :dash, linewidth = linewidth, label = l)
    end


    xlims!(ax3, 0, 50)
    ylims!(ax3, 1e-13, 1e1)
    text!(ax3, 47.5, 1, text = "(c)", fontsize = 30, align = (:right, :center))
    xlims!(ax4, 0, 100)
    ylims!(ax4, 1e-13, 1e1)
    text!(ax4, 97.5, 1, text = "(d)", fontsize = 30, align = (:right, :center))

    save("figs/error_parameter_selection_force.pdf", f, px_per_unit = 2)
    save("figs/error_parameter_selection_force.png", f, px_per_unit = 2)
    f
end
