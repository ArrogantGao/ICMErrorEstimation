using CairoMakie, LaTeXStrings
using CSV, DataFrames


dfs = [CSV.read("data/rdf/O_$(i)_rdf.csv", DataFrame) for i in 1:4]

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 800), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"r", ylabel = L"rdf(r)")
    for (i, df) in enumerate(dfs)
        lines!(ax, df.r, df.rdf1, label = "M=$(i)")
    end
    axislegend(ax)
    save("figs/rdf.png", f, px_per_unit = 2)
    f
end