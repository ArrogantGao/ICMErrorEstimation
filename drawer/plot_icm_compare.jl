include("setting.jl")

df_n39 = CSV.read("data/error_ICM_Ewald2D.csv", DataFrame)
df_n39_md = CSV.read("data/error_ICM_Ewald2D_md.csv", DataFrame)
df_n2 = CSV.read("data/error_ICM_Ewald2D_n2.csv", DataFrame)

dfs = [df_n39, df_n39_md, df_n2]

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 400), fontsize = 20)

    ax1 = Axis(f[1, 1], xlabel = L"M", ylabel = L"\langle \mathcal{E} \rangle", yscale = log10)

    H = 5.0
    labels = ["random", "equilibrium", "dipole"]
    Cqs = [46^2, 40, 4]
    n_atomss = [1, 1, 1]
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
    axislegend(ax1, "system", position = :lb)
    xlims!(ax1, 0, 8)
    ylims!(ax1, 1e-14, 1e2)


    save("figs/icm_error_compare.pdf", f)

    f
end

f