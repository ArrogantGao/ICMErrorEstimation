using CSV, DataFrames
using CairoMakie, LaTeXStrings

data_file_exact = "md_data/exact_z_hist.csv"
data_file_yuan = "md_data/yuan_z_hist.csv"
data_file_new = "md_data/new_z_hist.csv"

df_exact = CSV.read(data_file_exact, DataFrame)
df_yuan = CSV.read(data_file_yuan, DataFrame)
df_new = CSV.read(data_file_new, DataFrame)

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"z", ylabel = L"P(z)")
    lines!(ax, df_exact[df_exact.atoms_type .== 1, :z], df_exact[df_exact.atoms_type .== 1, :hist], label = "Exact")
    lines!(ax, df_yuan[df_yuan.atoms_type .== 1, :z], df_yuan[df_yuan.atoms_type .== 1, :hist], label = "Yuan")
    lines!(ax, df_new[df_new.atoms_type .== 1, :z], df_new[df_new.atoms_type .== 1, :hist], label = "New")
    axislegend(ax, position = :lt)

    ax2 = Axis(f[1, 2], xlabel = L"z", ylabel = L"P(z)")
    lines!(ax2, df_exact[df_exact.atoms_type .== 2, :z], df_exact[df_exact.atoms_type .== 2, :hist], label = "Exact")
    lines!(ax2, df_yuan[df_yuan.atoms_type .== 2, :z], df_yuan[df_yuan.atoms_type .== 2, :hist], label = "Yuan")
    lines!(ax2, df_new[df_new.atoms_type .== 2, :z], df_new[df_new.atoms_type .== 2, :hist], label = "New")

    save("figs/z_hist.png", f, px_per_unit = 2)
    f
end
