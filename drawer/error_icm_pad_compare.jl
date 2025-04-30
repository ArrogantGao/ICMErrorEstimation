include("setting.jl")

dfs = [CSV.read("data/error_ICM_EwaldELC_compare_n39.csv", DataFrame), CSV.read("data/error_ICM_EwaldELC_compare_n39_md.csv", DataFrame), CSV.read("data/error_ICM_EwaldELC_compare_n2.csv", DataFrame)]
labels = ["random", "equilibrium", "dipole"]

begin
    gamma = 1.0
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)
    ax1 = Axis(f[1, 1], xlabel = L"P", ylabel = L"\langle \mathcal{E} \rangle", yscale = log10)
    ax2 = Axis(f[1, 2], xlabel = L"M", ylabel = L"\langle \mathcal{E} \rangle", yscale = log10)

    sp1 = 1
    H = 5.0
    Cqs = [46^2, 39 * 4, 4]

    for i in 1:3
        M = 7
        c = colors[i]
        ls = linestyle[i]
        ms = markerstyle[i]
        df = dfs[i]
        Cq = Cqs[i]
        rs = unique(df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M, :r])
        errors = [df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M .&& df.r .== r, :error_a] for r in rs]
        high_errors = maximum.(errors) .- mean.(errors)
        low_errors = mean.(errors) .- minimum.(errors)
        errorbars!(ax1, rs, mean.(errors), low_errors, high_errors, color = c, linewidth = linewidth, whiskerwidth = 10, label = labels[i])
        scatter!(ax1, rs, mean.(errors), marker = ms, markersize = 10, color = c)

        xs = [0.1:0.5:10.6...]
        ys = abs.([icm_elc_energy_error(10, 10, 5 + 10 * x, 5, 7, 1, Cq, gamma, gamma) for x in xs])
        lines!(ax1, xs, ys, color = c, linestyle = :dash, linewidth = linewidth)
    end
    axislegend(ax1, "system", position = :lb)
    xlims!(ax1, 0.5, 10.5)
    ylims!(ax1, 1e-12, 1e2)


    sp2 = 1
    r = 5.0
    for i in 1:3
        c = colors[i]
        ls = linestyle[i]
        ms = markerstyle[i]
        df = dfs[i]
        Cq = Cqs[i]

        Ms = unique(df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r, :M])
        errors = [df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r .&& df.M .== m, :error_a] for m in Ms]
        high_errors = maximum.(errors) .- mean.(errors)
        low_errors = mean.(errors) .- minimum.(errors)

        errorbars!(ax2, Ms, mean.(errors), low_errors, high_errors, color = c, linewidth = linewidth, whiskerwidth = 10)
        scatter!(ax2, Ms, mean.(errors), marker = ms, markersize = 10, color = c)

        xs = [-1:2:15...]
        ys = abs.([icm_elc_energy_error(10, 10, 5 + 10 * r, 4.999, x, 1, Cq, gamma, gamma) + icm_energy_error(10, 10, 5, x, 1, Cq, gamma, gamma) for x in xs])
        @show ys
        lines!(ax2, xs, ys, color = c, linestyle = :dash, linewidth = linewidth)
    end

    xlims!(ax2, -0.5, 15.5)
    ylims!(ax2, 1e-12, 1e2)

    text!(ax1, 5.1, 10^(3), text = "(a)", fontsize = 30, align = (:right, :center))
    text!(ax2, 100, 10^(3), text = "(b)", fontsize = 30, align = (:right, :center))

    save("figs/error_icm_pad_gamma_1_compare.pdf", f, px_per_unit = 2)
    f
end