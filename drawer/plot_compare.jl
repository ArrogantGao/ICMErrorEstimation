include("setting.jl")

df_n39 = CSV.read("data/error_ICM_Ewald2D.csv", DataFrame)
df_n39_md = CSV.read("data/error_ICM_Ewald2D_md.csv", DataFrame)
df_n2 = CSV.read("data/error_ICM_Ewald2D_n2.csv", DataFrame)
dfs = [df_n39, df_n39_md, df_n2]

dfs_1 = [CSV.read("data/error_EwaldELC.csv", DataFrame), CSV.read("data/error_EwaldELC_md.csv", DataFrame), CSV.read("data/error_EwaldELC_n2.csv", DataFrame)]
dfs_2 = [CSV.read("data/error_ICM_EwaldELC_compare_n39.csv", DataFrame), CSV.read("data/error_ICM_EwaldELC_compare_n39_md.csv", DataFrame), CSV.read("data/error_ICM_EwaldELC_compare_n2.csv", DataFrame)]

Lx = 10.0
H = 5.0
gamma = 1.0
labels = ["random", "equilibrium", "dipole"]
Cqs = [46^2, 40, 4]
n_atomss = [1, 1, 1]

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (800, 600), fontsize = 20)

    ax1 = Axis(f[1, 1], xlabel = L"M", ylabel = L"\langle \mathcal{E} \rangle", yscale = log10)
    ax2 = Axis(f[1, 2], xlabel = L"$P$", ylabel = L"\langle \mathcal{E} \rangle", yscale = log10)
    ax3 = Axis(f[2, 1], xlabel = L"P", ylabel = L"\langle \mathcal{E} \rangle", yscale = log10)
    ax4 = Axis(f[2, 2], xlabel = L"M", ylabel = L"\langle \mathcal{E} \rangle", yscale = log10)

    for i in 1:3
        df = dfs[i]
        ms = markerstyle[i]
        ls = linestyle[i]
        c = colors[i]
        l = labels[i]
        Cq = Cqs[i]
        n_atoms = n_atomss[i]
        Ms = unique(df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M])
        errors = [df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0 .&& df.M .== m, :error_a] ./ n_atoms for m in Ms]
        high_errors = maximum.(errors) .- mean.(errors)
        low_errors = mean.(errors) .- minimum.(errors)

        errorbars!(ax1, Ms, mean.(errors), low_errors, high_errors, color = c, linewidth = linewidth, whiskerwidth = 10)
        scatter!(ax1, Ms,mean.(errors), marker = ms, markersize = 10, color = c, label = l)
        
        xs = [-1:2:9...]
        ys = [icm_energy_error(10, 10, 5, x, 1, Cq, 1, 1) / n_atoms for x in xs]
        lines!(ax1, xs, ys, color = c, linestyle = :dash, linewidth = linewidth)
    end
    axislegend(ax1, position = :lb, labelsize = 15)
    xlims!(ax1, 0, 8)
    ylims!(ax1, 1e-14, 1e2)


    for (i, df) in enumerate(dfs_1)

        ms, ls, c = markerstyle[i], linestyle[i], colors[i]
        l = labels[i]
        Cq = Cqs[i]
        n_atoms = n_atomss[i]

        xdata = unique(df[df.H .== H, :rr])
        ydata = [df[df.H .== H .&& df.rr .== r, :error_a] for r in xdata] ./ n_atoms
        high_errors = maximum.(ydata) .- mean.(ydata)
        low_errors = mean.(ydata) .- minimum.(ydata)

        errorbars!(ax2, xdata, mean.(ydata), low_errors, high_errors, color = c, linewidth = linewidth, whiskerwidth = 10)
        scatter!(ax2, xdata, mean.(ydata), label = l, marker = ms, markersize = 10, color = c)

        ps = [0.5:0.5:6.5...]
        ys = [elc_energy_error(Lx, Lx, H + p * Lx, H, 1, Cq) / n_atoms for p in ps]
        lines!(ax2, ps, ys, color = c, linestyle = :dash, linewidth = linewidth)
    end
    xlims!(ax2, 0.5, 6.25)
    ylims!(ax2, 1e-14, 1e2)


    H = 5.0
    for i in 1:3
        M = 7
        c = colors[i]
        ls = linestyle[i]
        ms = markerstyle[i]
        df = dfs_2[i]
        Cq = Cqs[i]
        rs = unique(df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M, :r])
        errors = [df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.M .== M .&& df.r .== r, :error_a] for r in rs]
        high_errors = maximum.(errors) .- mean.(errors)
        low_errors = mean.(errors) .- minimum.(errors)
        errorbars!(ax3, rs, mean.(errors), low_errors, high_errors, color = c, linewidth = linewidth, whiskerwidth = 10, label = labels[i])
        scatter!(ax3, rs, mean.(errors), marker = ms, markersize = 10, color = c)

        xs = [3.6:0.5:10.6...]
        ys = abs.([icm_elc_energy_error(10, 10, 5 + 10 * x, 5, 7, 1, Cq, gamma, gamma) for x in xs])
        lines!(ax3, xs, ys, color = c, linestyle = :dash, linewidth = linewidth)
    end
    xlims!(ax3, 0.5, 10.5)
    ylims!(ax3, 1e-14, 1e2)


    r = 5.0
    for i in 1:3
        c = colors[i]
        ls = linestyle[i]
        ms = markerstyle[i]
        df = dfs_2[i]
        Cq = Cqs[i]

        Ms = unique(df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r, :M])
        errors = [df[df.γu .== gamma .&& df.γd .== gamma .&& df.H .== H .&& df.r .== r .&& df.M .== m, :error_a] for m in Ms]
        high_errors = maximum.(errors) .- mean.(errors)
        low_errors = mean.(errors) .- minimum.(errors)

        errorbars!(ax4, Ms, mean.(errors), low_errors, high_errors, color = c, linewidth = linewidth, whiskerwidth = 10)
        scatter!(ax4, Ms, mean.(errors), marker = ms, markersize = 10, color = c)

        xs = [-1:2:15...]
        ys = abs.([icm_elc_energy_error(10, 10, 5 + 10 * r, 4.999, x, 1, Cq, gamma, gamma) + icm_energy_error(10, 10, 5, x, 1, Cq, gamma, gamma) for x in xs])
        lines!(ax4, xs, ys, color = c, linestyle = :dash, linewidth = linewidth)
    end

    xlims!(ax4, -0.5, 15.6)
    ylims!(ax4, 1e-14, 1e2)

    text!(ax1, 7.75, 10^(1), text = "(a)", fontsize = 30, align = (:right, :center))
    text!(ax2, 6, 10^(1), text = "(b)", fontsize = 30, align = (:right, :center))
    text!(ax3, 10, 10^(1), text = "(c)", fontsize = 30, align = (:right, :center))
    text!(ax4, 15, 10^(1), text = "(d)", fontsize = 30, align = (:right, :center))
end

save("figs/error_compare.pdf", f)
f