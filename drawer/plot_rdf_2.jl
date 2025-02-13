using CairoMakie, LaTeXStrings
using CSV, DataFrames

begin
    for gamma in [-0.95, -0.6, 0.6, 0.95]
        dfs = [CSV.read("data/rdf/O_$(i)_$(gamma)_$(gamma)_rdf.csv", DataFrame) for i in 2:2:6]
        # df_exact = CSV.read("data/rdf_exact/O_10_$(gamma)_$(gamma)_exact_rdf.csv", DataFrame)
        f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 800), fontsize = 20)
        ax = Axis(f[1, 1], xlabel = L"r", ylabel = L"rdf(r)")
        for (i, df) in enumerate(dfs)
            @show i, maximum(df.rdf1)
            scatter!(ax, df.r, df.rdf1, label = "M=$(i)")
        end
        # lines!(ax, df_exact.r, df_exact.rdf1, label = "Exact")
        axislegend(ax)
        save("figs/rdf_$(gamma).pdf", f, px_per_unit = 2)
        f
    end
end

f