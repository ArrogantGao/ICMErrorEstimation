using CairoMakie, LaTeXStrings
using CSV, DataFrames

for gamma in [-0.95, -0.6, 0.6, 0.95]
    dfs = [CSV.read("data/density/PPPM_O_z_$(i)_$(gamma)_$(gamma)_exact_density.csv", DataFrame) for i in 1:6]

    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 800), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"z", ylabel = L"density")
    for (i, df) in enumerate(dfs)
        lines!(ax, df.z, df.density, label = "M=$(i)")
    end
    axislegend(ax)
    save("figs/density_$(gamma).pdf", f, px_per_unit = 2)
    f
end