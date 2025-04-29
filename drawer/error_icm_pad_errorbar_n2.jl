include("setting.jl")

data_file = "data/error_ICM_EwaldELC_n2.csv"
df = CSV.read(data_file, DataFrame)

begin
    gamma = 1.0
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)
    ax1 = Axis(f[1, 1], xlabel = L"P", ylabel = L"\mathcal{E}", yscale = log10)
    ax2 = Axis(f[1, 2], xlabel = L"M", ylabel = L"\mathcal{E}", yscale = log10)

    sp1 = 1
    H = 0.5
    ranges = [5:10, 9:14, 10:15]
    for (M, i) in [(25, 1), (35, 2), (45, 3)]
        c = colors[i]
        ls = linestyle[i]
        ms = markerstyle[i]
        r = ranges[i]

        rs = unique(df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M, :r])
        errors = [df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M .&& df.r .== r, :error_a] for r in rs]
        high_errors = maximum.(errors) .- mean.(errors)
        low_errors = mean.(errors) .- minimum.(errors)

        xdata = rs[ranges[i]]
        ydata = mean.(errors[ranges[i]])
        @. model(x, p) = p[1] + x * p[2]
        p0 = [0.0, 0.0]
        fit = curve_fit(model, xdata, log10.(ydata), p0)
        p = fit.param
        fit_x = [-1:0.1:6...]
        fit_y = model(fit_x, p)
        lines!(ax1, fit_x, 10.0 .^ fit_y, color = c, linestyle = :dash, linewidth = 2)

        # scatter!(ax1, rs[1:sp1:end], mean.(errors)[1:sp1:end], label = "$M", marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        errorbars!(ax1, rs[1:sp1:end], mean.(errors)[1:sp1:end], low_errors[1:sp1:end], high_errors[1:sp1:end], color = c, linewidth = linewidth, whiskerwidth = 10, label = "$M")
    end
    axislegend(ax1, L"$M$", position = :lb)
    xlims!(ax1, -0.25, 5.25)
    ylims!(ax1, 1e-10, 1e4)


    sp2 = 1
    M = 45
    ranges = [4:6, 8:14, 15:20]
    for (i, r) in [(1, 1), (2, 3), (3, 5)]
        c = colors[i]
        ls = linestyle[i]
        ms = markerstyle[i]

        Ms = unique(df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r, :M])
        errors = [df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r .&& df.M .== m, :error_a] for m in Ms]
        high_errors = maximum.(errors) .- mean.(errors)
        low_errors = mean.(errors) .- minimum.(errors)

        # scatter!(ax2, Ms[1:sp2:end], mean.(errors)[1:sp2:end], label = "$r", marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        errorbars!(ax2, Ms[1:sp2:end], mean.(errors)[1:sp2:end], low_errors[1:sp2:end], high_errors[1:sp2:end], color = c, linewidth = linewidth, whiskerwidth = 10, label = "$r")

        c = colors[i]
        xdata = Ms[ranges[i]]
        ydata = mean.(errors[ranges[i]])

        @. model(x, p) = p[1] + x * p[2]
        p0 = [0.0, 0.0]
        fit = curve_fit(model, xdata, log10.(ydata), p0)
        p = fit.param
        fit_x = [-5:0.1:105...]
        fit_y = model(fit_x, p)
        lines!(ax2, fit_x, 10.0 .^ fit_y, color = c, linestyle = :dash, linewidth = 2)
    end

    # @. model(x, p) = p[1] + x * p[2]
    # p0 = [0.0, 0.0]
    # xdata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== 5, :M][1:10]
    # ydata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== 5, :error_r][1:10]
    # fit = curve_fit(model, xdata, log10.(ydata), p0)
    # p = fit.param
    # fit_x = [-5:0.1:105...]
    # fit_y = model(fit_x, p)
    # lines!(ax2, fit_x, 10.0 .^ fit_y, color = :black, linestyle = :dash, linewidth = 2)

    axislegend(ax2, L"$P$", position = :lb)
    xlims!(ax2, -5, 105)
    ylims!(ax2, 1e-10, 1e4)

    text!(ax1, 5.1, 10^(3), text = "(a)", fontsize = 30, align = (:right, :center))
    text!(ax2, 100, 10^(3), text = "(b)", fontsize = 30, align = (:right, :center))

    save("figs/error_icm_pad_gamma_1_n2_withbar.pdf", f, px_per_unit = 2)
    f
end


begin
    gamma = 0.6
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)
    ax1 = Axis(f[1, 1], xlabel = L"P", ylabel = L"\mathcal{E}", yscale = log10)
    ax2 = Axis(f[1, 2], xlabel = L"M", ylabel = L"\mathcal{E}", yscale = log10)

    sp1 = 1
    H = 0.5
    for (i, M) in enumerate([5, 15, 25])
        c = colors[i]
        ls = linestyle[i]
        ms = markerstyle[i]

        rs = unique(df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M, :r])
        errors = [df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M .&& df.r .== r, :error_a] for r in rs]
        high_errors = maximum.(errors) .- mean.(errors)
        low_errors = mean.(errors) .- minimum.(errors)

        # scatter!(ax1, Ms[1:sp1:end], mean.(errors)[1:sp1:end], label = "$M", marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        errorbars!(ax1, rs[1:sp1:end], mean.(errors)[1:sp1:end], low_errors[1:sp1:end], high_errors[1:sp1:end], color = c, linewidth = linewidth, whiskerwidth = 10, label = "$M")
    end
    axislegend(ax1, L"$M$", position = :lb)
    xlims!(ax1, -0.25, 5.25)
    ylims!(ax1, 1e-14, 1e3)

    # @. model(x, p) = p[1] + x * p[2]
    # p0 = [0.0, 0.0]
    # xdata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== 45, :r][1:end - 1]
    # ydata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== 45, :error_r][1:end - 1]
    # fit = curve_fit(model, xdata, log10.(ydata), p0)
    # p = fit.param
    # fit_x = [-1:0.1:6...]
    # fit_y = model(fit_x, p)
    # lines!(ax1, fit_x, 10.0 .^ fit_y, color = :black, linestyle = :dash, linewidth = 2)


    sp2 = 1
    M = 49
    for (i, r) in enumerate([1, 3, 5])
        c = colors[i]
        ls = linestyle[i]
        ms = markerstyle[i]

        Ms = unique(df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r, :M])
        errors = [df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r .&& df.M .== m, :error_a] for m in Ms]
        high_errors = maximum.(errors) .- mean.(errors)
        low_errors = mean.(errors) .- minimum.(errors)

        # scatter!(ax2, df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r, :M][1:sp2:11], df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r, :error_r][1:sp2:11], label = "$r", marker = ms[i], markersize = markersize, color = c[i], strokecolor = strokecolor, strokewidth = strokewidth)
        errorbars!(ax2, Ms[1:sp2:end], mean.(errors)[1:sp2:end], low_errors[1:sp2:end], high_errors[1:sp2:end], color = c, linewidth = linewidth, whiskerwidth = 10, label = "$r")
    end
    axislegend(ax2, L"$P$", position = :lb)
    xlims!(ax2, -2.5, 52.5)
    ylims!(ax2, 1e-14, 1e3)

    # @. model(x, p) = p[1] + x * p[2]
    # p0 = [0.0, 0.0]
    # xdata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== 5, :M][1:7]
    # ydata = df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== 5, :error_r][1:7]
    # fit = curve_fit(model, xdata, log10.(ydata), p0)
    # p = fit.param
    # fit_x = [-10:0.1:100...]
    # fit_y = model(fit_x, p)
    # lines!(ax2, fit_x, 10.0 .^ fit_y, color = :black, linestyle = :dash, linewidth = 2)

    text!(ax1, 5.1, 10^(1), text = "(a)", fontsize = 30, align = (:right, :center))
    text!(ax2, 50, 10^(1), text = "(b)", fontsize = 30, align = (:right, :center))

    save("figs/error_icm_pad_gamma_0.6_n2_withbar.pdf", f, px_per_unit = 2)
    f
end

# begin
#     sp1 = 1
#     f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)
#     ax1 = Axis(f[1, 2], xlabel = L"M", ylabel = L"\mathcal{E}", yscale = log10)
#     ax2 = Axis(f[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}", yscale = log10)

#     Hs = [0.5, 1.0, 5.0]
#     l = ["20", "10", "2"]

#     for i in 1:3
#         H = Hs[i]
#         l = ls[i]
#         c = colors[i]
#         ls = linestyle[i]
#         ms = markerstyle[i]

#         Ms = unique(df[df.H .== H .&& df.γu .== 1 .&& df.γd .== 1 .&& df.r .== 5, :M])
#         errors = [df[df.H .== H .&& df.γu .== 1 .&& df.γd .== 1 .&& df.r .== 5 .&& df.M .== m, :error_r] for m in Ms]
#         high_errors = maximum.(errors) .- mean.(errors)
#         low_errors = mean.(errors) .- minimum.(errors)

#         # scatter!(ax1, Ms[1:sp1:end], mean.(errors)[1:sp1:end], label = l, marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
#         errorbars!(ax1, Ms[1:sp1:end], mean.(errors)[1:sp1:end], low_errors[1:sp1:end], high_errors[1:sp1:end], color = c, linewidth = linewidth, whiskerwidth = 10, label = l)
#     end

#     # x_data_1 = df[df.H .== 0.5 .&& df.γu .== 1 .&& df.γd .== 1, :M][1:3]
#     # y_data_1 = df[df.H .== 0.5 .&& df.γu .== 1 .&& df.γd .== 1, :error_r][1:3]
#     # @. model(x, p) = p[1] + x*p[2]
#     # p0 = [1.0, 1.0]
#     # fit = curve_fit(model, x_data_1, y_data_1, p0)
#     # lines!(ax1, [-1:10...], 10 .^ model([-1:10...], fit.param), color = colors[1], linestyle = :dash, linewidth = linewidth)

#     xlims!(ax1, -2, 102)
#     ylims!(ax1, 1e-12, 1e3)
#     text!(ax1, 100, 100, text = "(b)", fontsize = 30, align = (:right, :center))

#     sp2 = 1
#     for (H, l, c, ls, ms) in [(0.5, "20", colors[1], linestyle[1], markerstyle[1]), (1.0, "10", colors[2], linestyle[2], markerstyle[2]), (5.0, "2", colors[3], linestyle[3], markerstyle[3])]
#         scatter!(ax2, df[df.H .== H .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.r .== 5, :M][1:sp2:end], df[df.H .== H .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.r .== 5, :error_r][1:sp2:end], label = l, marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
#         lines!(ax2, df[df.H .== H .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.r .== 5, :M], df[df.H .== H .&& df.γu .== 0.6 .&& df.γd .== 0.6 .&& df.r .== 5, :error_r], color = c, linestyle = :dash, linewidth = linewidth)
#     end
#     axislegend(ax1, L"$L_x / H$", position = :rb)
#     xlims!(ax2, -2, 102)
#     ylims!(ax2, 1e-15, 1e3)
#     text!(ax2, 100, 100, text = "(a)", fontsize = 30, align = (:right, :center))

#     save("figs/icm_elc_error_withbar.pdf", f)

#     f
# end