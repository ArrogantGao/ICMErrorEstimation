include("setting.jl")

df_n39 = CSV.read("data/error_EwaldELC.csv", DataFrame)
df_md = CSV.read("data/error_EwaldELC_md.csv", DataFrame)
df_n2 = CSV.read("data/error_EwaldELC_n2.csv", DataFrame)

dfs = [df_n39, df_md, df_n2]
labels = ["random", "equilibrium", "dipole"]

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 400), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"$P$", ylabel = L"\langle \mathcal{E} \rangle", yscale = log10)

    Lx = 10.0
    H = 5.0
    Cqs = [46^2, 39 * 4, 4]
    n_atomss = [1, 1, 1]

    for (i, df) in enumerate(dfs)

        ms, ls, c = markerstyle[i], linestyle[i], colors[i]
        l = labels[i]
        Cq = Cqs[i]
        n_atoms = n_atomss[i]

        xdata = unique(df[df.H .== H, :rr])
        ydata = [df[df.H .== H .&& df.rr .== r, :error_a] for r in xdata] ./ n_atoms
        high_errors = maximum.(ydata) .- mean.(ydata)
        low_errors = mean.(ydata) .- minimum.(ydata)

        errorbars!(ax, xdata, mean.(ydata), low_errors, high_errors, color = c, linewidth = linewidth, whiskerwidth = 10)
        scatter!(ax, xdata, mean.(ydata), label = l, marker = ms, markersize = 10, color = c)

        ps = [0.5:0.5:6.5...]
        ys = [elc_energy_error(Lx, Lx, H + p * Lx, H, 1, Cq) / n_atoms for p in ps]
        lines!(ax, ps, ys, color = c, linestyle = :dash, linewidth = linewidth)
    end

    axislegend(ax, "system", position = :rt)
    xlims!(ax, 0.5, 6.5)
    ylims!(ax, 1e-16, 1)
    save("figs/elc_error_compare.pdf", f)
end

f