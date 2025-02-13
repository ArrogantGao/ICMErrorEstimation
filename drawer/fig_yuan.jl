using CSV, DataFrames
using CairoMakie, LaTeXStrings
using LsqFit

include("setting.jl")

data_file = "data/ICM_Ewald3D_2-1.csv"

df = CSV.read(data_file, DataFrame)

N_imgs = unique(df.N_img)
N_slabs = unique(df.N_slab)

H = 5

begin

    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)
    ga = f[1, 1] = GridLayout()
    gb = f[1, 2] = GridLayout()
    gc = f[1, 3] = GridLayout()

    axr = Axis(ga[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10, title = L"\gamma = 0.6")
    axc = Axis(gb[1, 1], xlabel = L"M", yscale = log10, title = L"\gamma = 0.95")
    axl = Axis(gc[1, 1], xlabel = L"M", yscale = log10, title = L"\gamma = 1.0")

    # xlims!(axr, 2, 16)
    # xlims!(axc, 2, 16)
    # xlims!(axl, 2, 16)

    ylims!(axr, 1e-9, 1e1)
    ylims!(axc, 1e-9, 1e1)
    ylims!(axl, 1e-9, 1e1)

    ls = [:solid, :dash, :dot]

    lelement = [LineElement(linestyle = l, color = :black) for l in ls]
    lname = [L"\gamma = (\Delta, \Delta)", L"\gamma = (-\Delta, -\Delta)", L"\gamma = (-\Delta, \Delta)"]

    lns = []

    loh = [9, 15, 21]

    p0 = [0.01, 1.0, 10^(-7.2)]

    for (Δ, ax) in [(0.6, axr), (0.95, axc), (1.0, axl)]
        for (i, N_slab) in enumerate(N_slabs)
            @show i
            c = colors[i]
            ls = linestyle[i]
            ms = markerstyle[i]

            for (j, γ) in enumerate([(Δ, Δ)])
                dfγ = df[(df.N_slab .== N_slab) .& (df.γ1 .== γ[1]) .& (df.γ2 .== γ[2]), :]
                ln = scatter!(ax, dfγ.N_img, dfγ.error_r, label = L"%$(H * loh[i])",  marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)

                # lines!(ax, dfγ.N_img, dfγ.error_r, color = c, linestyle = :dash, linewidth = linewidth)

                push!(lns, ln)

                Lz = H * loh[i]
                p = p0
                fe = x -> p[1] * exp(-(Lz - H) * 2π / 15) + p[1] * 2 *  Δ^(x) * exp(-(Lz - (x + 1) * H) * 2π / 15) + p[2] * Δ^(x + 1) * exp(-2π * (x + 1) * 5 / 15) + p[3]
                
                @. model(x, p) = log.(abs.(p[1] * exp(-(Lz - H) * 2π / 15) + p[1] * 2 *  Δ^(x) * exp(-(Lz - (x + 1) * H) * 2π / 15) + p[2] * Δ^(x + 1) * exp(-2π * (x + 1) * 5 / 15) + p[3] ))

                # raw_y_data = dfγ.error_r
                # raw_x_data = dfγ.N_img
                # if i == 1 && j == 1
                #     n = 6
                # else
                #     n = findfirst(x -> x > 1e-1, raw_y_data)
                # end
                # if n == nothing
                #     n = length(raw_y_data)
                # end
                # x_data = raw_x_data[1:n]
                # y_data = raw_y_data[1:n]
                # p0 = [1.0, 1.0, 0.0]
                # fit = curve_fit(model, x_data, log.(abs.(y_data)), p0)
                # @show fit.param

                # fe(x) = exp(model(x, fit.param))
                
                lines!(ax, [0:0.1:16...], fe.([0:0.1:16...]), color = colors[i], linestyle = :dash)
            end
        end
    end

    axislegend(axr, L"L_z", position = :lt)

    save("figs/error_yuan.png", f)
    save("figs/error_yuan.pdf", f)

    f
end