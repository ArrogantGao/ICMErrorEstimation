include("setting.jl")

data_file = "data/error_ICM_EwaldELC.csv"

df = CSV.read(data_file, DataFrame)

begin
    gamma = 1.0
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)
    ax1 = Axis(f[1, 1], xlabel = L"R", ylabel = L"\mathcal{E}_r", yscale = log10)
    ax2 = Axis(f[1, 2], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)

    sp1 = 1
    H = 0.5
    ranges = [5:10, 9:14, 10:15]
    for (M, i) in [(25, 1), (35, 2), (45, 3)]
        c = colors[i]
        ls = linestyle[i]
        ms = markerstyle[i]
        r = ranges[i]

        xdata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M .&& df.i .== 1, :r][r]
        ydata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M .&& df.i .== 1, :error_r][r]
        fit_x = [-1:0.1:6...]
        fit_y = exp_fit(xdata, ydata, (- 2π) * log10(exp(1)), fit_x)
        lines!(ax1, fit_x, fit_y, color = c, linestyle = :dash, linewidth = 2)

        scatter!(ax1, df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M .&& df.i .== 1, :r][1:sp1:end], df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M .&& df.i .== 1, :error_r][1:sp1:end], label = "$M", marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
    end
    axislegend(ax1, L"$M$", position = :lb)
    xlims!(ax1, -0.25, 5.25)
    ylims!(ax1, 1e-9, 1e3)


    sp2 = 1
    M = 45
    for (r, c, ls, ms) in [(1, colors[1], linestyle[1], markerstyle[1]), (3, colors[2], linestyle[2], markerstyle[2]), (5, colors[3], linestyle[3], markerstyle[3])]
        scatter!(ax2, df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r .&& df.i .== 1, :M][1:sp2:end], df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r .&& df.i .== 1, :error_r][1:sp2:end], label = "$r", marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
    end

    xdata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== 5 .&& df.i .== 1, :M][1:10]
    ydata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== 5 .&& df.i .== 1, :error_r][1:10]
    fit_x = [-5:0.1:105...]
    fit_y = exp_fit(xdata, ydata, (- 2π * H / 10) * log10(exp(1)), fit_x)
    lines!(ax2, fit_x, fit_y, color = :black, linestyle = :dash, linewidth = 2)

    ranges = [4:6, 8:14, 15:20]
    for (i, r) in [(1, 1), (2, 3), (3, 5)]
        c = colors[i]
        xdata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r .&& df.i .== 1, :M][ranges[i]]
        ydata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r .&& df.i .== 1, :error_r][ranges[i]]

        fit_x = [-5:0.1:105...]
        fit_y = exp_fit(xdata, ydata, (2π * H / 10) * log10(exp(1)), fit_x)
        lines!(ax2, fit_x, fit_y, color = c, linestyle = :dash, linewidth = 2)
    end

    axislegend(ax2, L"$R$", position = :lb)
    xlims!(ax2, -5, 105)
    ylims!(ax2, 1e-9, 1e3)

    text!(ax1, 5.1, 10^(2), text = "(a)", fontsize = 30, align = (:right, :center))
    text!(ax2, 100, 10^(2), text = "(b)", fontsize = 30, align = (:right, :center))

    save("figs/error_icm_pad_gamma_1.pdf", f, px_per_unit = 2)
    save("figs/error_icm_pad_gamma_1.svg", f)
    f
end


begin
    gamma = 0.6
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)
    ax1 = Axis(f[1, 1], xlabel = L"R", ylabel = L"\mathcal{E}_r", yscale = log10)
    ax2 = Axis(f[1, 2], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)

    sp1 = 1
    H = 0.5
    for (M, c, ls, ms) in [(5, colors[1], linestyle[1], markerstyle[1]), (15, colors[2], linestyle[2], markerstyle[2]), (25, colors[3], linestyle[3], markerstyle[3])]
        scatter!(ax1, df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M .&& df.i .== 1, :r][1:sp1:end], df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M .&& df.i .== 1, :error_r][1:sp1:end], label = "$M", marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
    end
    axislegend(ax1, L"$M$", position = :lb)
    xlims!(ax1, -0.25, 5.25)
    ylims!(ax1, 1e-15, 1e2)

    xdata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== 45 .&& df.i .== 1, :r][1:end - 1]
    ydata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== 45 .&& df.i .== 1, :error_r][1:end - 1]
    fit_x = [-1:0.1:6...]
    fit_y = exp_fit(xdata, ydata, (- 2π) * log10(exp(1)), fit_x)
    lines!(ax1, fit_x, fit_y, color = :black, linestyle = :dash, linewidth = 2)


    sp2 = 1
    M = 49
    for (r, c, ls, ms) in [(1, colors[1], linestyle[1], markerstyle[1]), (3, colors[2], linestyle[2], markerstyle[2]), (5, colors[3], linestyle[3], markerstyle[3])]
        scatter!(ax2, df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r .&& df.i .== 1, :M][1:sp2:11], df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r .&& df.i .== 1, :error_r][1:sp2:11], label = "$r", marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
    end
    axislegend(ax2, L"$R$", position = :lb)
    xlims!(ax2, -2.5, 52.5)
    ylims!(ax2, 1e-15, 1e2)

    xdata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== 5 .&& df.i .== 1, :M][1:7]
    ydata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== 5 .&& df.i .== 1, :error_r][1:7]
    fit_x = [-10:0.1:100...]
    fit_y = exp_fit(xdata, ydata, log10(gamma) + ( - 2π * H / 10) * log10(exp(1)), fit_x)
    lines!(ax2, fit_x, fit_y, color = :black, linestyle = :dash, linewidth = 2)

    text!(ax1, 5.1, 10^(1), text = "(a)", fontsize = 30, align = (:right, :center))
    text!(ax2, 50, 10^(1), text = "(b)", fontsize = 30, align = (:right, :center))

    save("figs/error_icm_pad_gamma_0.6.pdf", f, px_per_unit = 2)
    save("figs/error_icm_pad_gamma_0.6.svg", f)
    f
end

begin
    sp1 = 1
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)
    ax1 = Axis(f[1, 2], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)
    ax2 = Axis(f[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)

    for (H, l, c, ls, ms) in [(0.5, "20", colors[1], linestyle[1], markerstyle[1]), (1.0, "10", colors[2], linestyle[2], markerstyle[2]), (5.0, "2", colors[3], linestyle[3], markerstyle[3])]
        scatter!(ax1, df[df.H .== H .&& df.γu .== 1 .&& df.γd .== 1 .&& df.r .== 5 .&& df.i .== 1, :M][1:sp1:end], df[df.H .== H .&& df.γu .== 1 .&& df.γd .== 1 .&& df.r .== 5 .&& df.i .== 1, :error_r][1:sp1:end], label = l, marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        lines!(ax1, df[df.H .== H .&& df.γu .== 1 .&& df.γd .== 1 .&& df.r .== 5 .&& df.i .== 1, :M], df[df.H .== H .&& df.γu .== 1 .&& df.γd .== 1 .&& df.r .== 5 .&& df.i .== 1, :error_r], color = c, linestyle = :dash, linewidth = linewidth)
    end

    # x_data_1 = df[df.H .== 0.5 .&& df.γu .== 1 .&& df.γd .== 1, :M][1:3]
    # y_data_1 = df[df.H .== 0.5 .&& df.γu .== 1 .&& df.γd .== 1, :error_r][1:3]
    # @. model(x, p) = p[1] + x*p[2]
    # p0 = [1.0, 1.0]
    # fit = curve_fit(model, x_data_1, y_data_1, p0)
    # lines!(ax1, [-1:10...], 10 .^ model([-1:10...], fit.param), color = colors[1], linestyle = :dash, linewidth = linewidth)

    xlims!(ax1, -2, 102)
    ylims!(ax1, 1e-12, 1e3)
    text!(ax1, 100, 100, text = "(b)", fontsize = 30, align = (:right, :center))

    sp2 = 1
    for (H, l, c, ls, ms) in [(0.5, "20", colors[1], linestyle[1], markerstyle[1]), (1.0, "10", colors[2], linestyle[2], markerstyle[2]), (5.0, "2", colors[3], linestyle[3], markerstyle[3])]
        scatter!(ax2, df[df.H .== H .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.r .== 5 .&& df.i .== 1, :M][1:sp2:end], df[df.H .== H .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.r .== 5 .&& df.i .== 1, :error_r][1:sp2:end], label = l, marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        lines!(ax2, df[df.H .== H .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.r .== 5 .&& df.i .== 1, :M], df[df.H .== H .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.r .== 5 .&& df.i .== 1, :error_r], color = c, linestyle = :dash, linewidth = linewidth)
    end
    axislegend(ax1, L"$L_x / H$", position = :rb)
    xlims!(ax2, -2, 102)
    ylims!(ax2, 1e-15, 1e3)
    text!(ax2, 100, 100, text = "(a)", fontsize = 30, align = (:right, :center))

    save("figs/icm_elc_error.pdf", f)
    save("figs/icm_elc_error.svg", f)
    f
end