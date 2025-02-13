include("setting.jl")

data_file = "data/error_ICM_EwaldELC.csv"

df = CSV.read(data_file, DataFrame)

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 400), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)

    lines!(ax, df[df.H .== 0.1 .&& df.γu .== 0.95 .&& df.γd .== 0.95, :M], df[df.H .== 0.1 .&& df.γu .== 0.95 .&& df.γd .== 0.95, :error_r], label = "H = 0.1")
    lines!(ax, df[df.H .== 0.5 .&& df.γu .== 0.95 .&& df.γd .== 0.95, :M], df[df.H .== 0.5 .&& df.γu .== 0.95 .&& df.γd .== 0.95, :error_r], label = "H = 0.5")
    lines!(ax, df[df.H .== 1.0 .&& df.γu .== 0.95 .&& df.γd .== 0.95, :M], df[df.H .== 1.0 .&& df.γu .== 0.95 .&& df.γd .== 0.95, :error_r], label = "H = 1.0")
    lines!(ax, df[df.H .== 5.0 .&& df.γu .== 0.95 .&& df.γd .== 0.95, :M], df[df.H .== 5.0 .&& df.γu .== 0.95 .&& df.γd .== 0.95, :error_r], label = "H = 5.0")
    lines!(ax, df[df.H .== 10.0 .&& df.γu .== 0.95 .&& df.γd .== 0.95, :M], df[df.H .== 10.0 .&& df.γu .== 0.95 .&& df.γd .== 0.95, :error_r], label = "H = 10.0")
    axislegend(ax)
    save("figs/icm_elc_error_0.95.png", f, px_per_unit = 2)
    f
end

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 400), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)

    lines!(ax, df[df.H .== 0.1 .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M], df[df.H .== 0.1 .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r], label = "H = 0.1")
    lines!(ax, df[df.H .== 0.5 .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M], df[df.H .== 0.5 .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r], label = "H = 0.5")
    lines!(ax, df[df.H .== 1.0 .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M], df[df.H .== 1.0 .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r], label = "H = 1.0")
    lines!(ax, df[df.H .== 5.0 .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M], df[df.H .== 5.0 .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r], label = "H = 5.0")
    lines!(ax, df[df.H .== 10.0 .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M], df[df.H .== 10.0 .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r], label = "H = 10.0")
    axislegend(ax)
    save("figs/icm_elc_error_1.0.png", f, px_per_unit = 2)
    f
end


begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 400), fontsize = 20)
    ax = Axis(f[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)

    lines!(ax, df[df.H .== 0.1 .&& df.γu .== 0.6 .&& df.γd .== 0.6, :M], df[df.H .== 0.1 .&& df.γu .== 0.6 .&& df.γd .== 0.6, :error_r], label = "H = 0.1")
    lines!(ax, df[df.H .== 0.5 .&& df.γu .== 0.6 .&& df.γd .== 0.6, :M], df[df.H .== 0.5 .&& df.γu .== 0.6 .&& df.γd .== 0.6, :error_r], label = "H = 0.5")
    lines!(ax, df[df.H .== 1.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6, :M], df[df.H .== 1.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6, :error_r], label = "H = 1.0")
    lines!(ax, df[df.H .== 5.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6, :M], df[df.H .== 5.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6, :error_r], label = "H = 5.0")
    lines!(ax, df[df.H .== 10.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6, :M], df[df.H .== 10.0 .&& df.γu .== 0.6 .&& df.γd .== 0.6, :error_r], label = "H = 10.0")
    axislegend(ax)
    save("figs/icm_elc_error_0.6.png", f, px_per_unit = 2)
    f
end