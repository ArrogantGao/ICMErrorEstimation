using CSV, DataFrames
using CairoMakie, LaTeXStrings
using Statistics

data_file_exact = "md_data/ICMPPPM_Exact.csv"
data_file_yuan = "md_data/ICMPPPM_Yuan_12.csv"
data_file_new = "md_data/ICMPPPM_New.csv"

df_exact = CSV.read(data_file_exact, DataFrame)
df_yuan = CSV.read(data_file_yuan, DataFrame)
df_new = CSV.read(data_file_new, DataFrame)


begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 400), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"t", ylabel = L"MSD_x", xscale = log10, yscale = log10)

    lines!(ax, df_exact.t[2:end], df_exact.c_msdx[2:end], label = "Exact")
    lines!(ax, df_yuan.t[2:end], df_yuan.c_msdx[2:end], label = "Yuan")
    lines!(ax, df_new.t[2:end], df_new.c_msdx[2:end], label = "New")
    axislegend(ax, position = :rb)
    save("figs/msd_x.png", f, px_per_unit = 2)
    f
end

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 400), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"t", ylabel = L"MSD_z", xscale = log10, yscale = log10)

    lines!(ax, df_exact.t[2:end], df_exact.c_msdz[2:end], label = "Exact")
    lines!(ax, df_yuan.t[2:end], df_yuan.c_msdz[2:end], label = "Yuan")
    lines!(ax, df_new.t[2:end], df_new.c_msdz[2:end], label = "New")
    axislegend(ax, position = :rb)
    save("figs/msd_z.png", f, px_per_unit = 2)
    f
end

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 400), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"t", ylabel = L"E_{tol}")
    lines!(ax, df_exact.t[2:end], [mean(df_exact.TotEng[2:i]) for i in 1:length(df_exact.t[2:end])], label = "Exact")
    lines!(ax, df_yuan.t[2:end], [mean(df_yuan.TotEng[2:i]) for i in 1:length(df_yuan.t[2:end])], label = "Yuan")
    lines!(ax, df_new.t[2:end], [mean(df_new.TotEng[2:i]) for i in 1:length(df_new.t[2:end])], label = "New")
    axislegend(ax, position = :rt)
    save("figs/TotEng.png", f, px_per_unit = 2)
    f
end
