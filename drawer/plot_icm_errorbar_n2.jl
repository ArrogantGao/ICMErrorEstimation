include("setting.jl")

data_file = "data/error_ICM_Ewald2D_n2.csv"
df = CSV.read(data_file, DataFrame)

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)

    ax1 = Axis(f[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}", yscale = log10)
    ax2 = Axis(f[1, 2], xlabel = L"M", ylabel = L"\mathcal{E}", yscale = log10)

    # for H in [0.5, 1.0, 5.0]
    for (l, H, ms, ls, c) in [("20", 0.5, markerstyle[1], linestyle[1], colors[1]), ("10", 1.0, markerstyle[2], linestyle[2], colors[2]), ("2", 5.0, markerstyle[3], linestyle[3], colors[3])]

        Ms = unique(df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M])
        errors = [df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0 .&& df.M .== m, :error_a] for m in Ms]
        high_errors = maximum.(errors) .- mean.(errors)
        low_errors = mean.(errors) .- minimum.(errors)

        errorbars!(ax1, Ms, mean.(errors), low_errors, high_errors, color = c, linewidth = linewidth, whiskerwidth = 10)

        scatter!(ax1, Ms,mean.(errors), marker = ms, markersize = 10, color = c, label = l)

        ub_ms = [-1:2:30...]
        ub = [icm_energy_error(10.0, 10.0, H, M, 1, 4, 1, 1) for M in ub_ms]
        lines!(ax1, ub_ms, ub, color = c, linestyle = :dash, linewidth = linewidth)
        
        # @. model(x, p) = p[1] + x*p[2]
        # p0 = [1.0, 1.0]
        # filter = df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_a] .> 1e-9
        # xdata = df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M][filter]
        # ydata = log10.(df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_a][filter])
        # fit = curve_fit(model, xdata, ydata, p0)
        # lines!(ax1, [0:20...], 10 .^ model([0:20...], fit.param), color = c, linestyle = :dash, linewidth = linewidth)
    end
    axislegend(ax1, L"L_x / H", position = :lb)
    xlims!(ax1, 0, 20)
    ylims!(ax1, 1e-14, 1)
    text!(ax1, 19.5, 1, text = "(a)", fontsize = 30, align = (:right, :bottom))

    for (l, γ, ms, ls, c) in [("1.0", 1.0, markerstyle[1], linestyle[1], colors[1]), ("0.6", 0.6, markerstyle[2], linestyle[2], colors[2]), ("0.3", 0.3, markerstyle[3], linestyle[3], colors[3])]

        Ms = unique(df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :M])
        errors = [df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ .&& df.M .== m, :error_a] for m in Ms]
        high_errors = maximum.(errors) .- mean.(errors)
        low_errors = mean.(errors) .- minimum.(errors)

        errorbars!(ax2, Ms, mean.(errors), low_errors, high_errors, color = c, linewidth = linewidth, whiskerwidth = 10)
        scatter!(ax2, Ms, mean.(errors), marker = ms, markersize = 10, color = c, label = l)
        
        ub_ms = [-1:2:30...]
        ub = [icm_energy_error(10.0, 10.0, 1.0, M, 1, 4, γ, γ) for M in ub_ms]
        lines!(ax2, ub_ms, ub, color = c, linestyle = :dash, linewidth = linewidth)

        # @. model(x, p) = p[1] + x*p[2]
        # p0 = [1.0, 1.0]
        # filter = df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :error_a] .> 1e-9
        # xdata = df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :M][filter]
        # ydata = log10.(df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :error_a][filter])
        # fit = curve_fit(model, xdata, ydata, p0)
        # lines!(ax2, [0:40...], 10 .^ model([0:40...], fit.param), color = c, linestyle = :dash, linewidth = linewidth)
    end
    axislegend(ax2, L"\gamma", position = :lb)
    xlims!(ax2, 0, 30)
    ylims!(ax2, 1e-14, 1)
    text!(ax2, 29, 1, text = "(b)", fontsize = 30, align = (:right, :bottom))


    save("figs/icm_error_withbar_n2.pdf", f)

    f
end

f