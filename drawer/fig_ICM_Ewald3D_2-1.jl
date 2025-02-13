using CSV, DataFrames
using CairoMakie, LaTeXStrings

data_file = "data/ICM_Ewald3D_2-1.csv"

df = CSV.read(data_file, DataFrame)

N_imgs = unique(df.N_img)
N_slabs = unique(df.N_slab)

begin

    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (900, 400), fontsize = 20)
    ga = f[1, 1] = GridLayout()
    gb = f[1, 2] = GridLayout()
    gc = f[1, 3] = GridLayout()

    axr = Axis(ga[1, 1], xlabel = L"N_{img}", ylabel = L"\mathcal{E}_r", yscale = log10, title = L"\Delta = 0.6")
    axc = Axis(gb[1, 1], xlabel = L"N_{img}", yscale = log10, title = L"\Delta = 0.95")
    axl = Axis(gc[1, 1], xlabel = L"N_{img}", yscale = log10, title = L"\Delta = 1.0")

    # xlims!(axr, 2, 16)
    # xlims!(axc, 2, 16)
    # xlims!(axl, 2, 16)

    ylims!(axr, 1e-9, 1e1)
    ylims!(axc, 1e-9, 1e1)
    ylims!(axl, 1e-9, 1e1)

    colors = [:black, :blue, :red]
    ls = [:solid, :dash, :dot]

    lelement = [LineElement(linestyle = l, color = :black) for l in ls]
    lname = [L"\gamma = (\Delta, \Delta)", L"\gamma = (-\Delta, -\Delta)", L"\gamma = (-\Delta, \Delta)"]

    lns = []

    for (Δ, ax) in [(0.6, axr), (0.95, axc), (1.0, axl)]
        for (i, N_slab) in enumerate(N_slabs)
            for (j, γ) in enumerate([(Δ, Δ), (-Δ, -Δ), (-Δ, Δ)])
                dfγ = df[(df.N_slab .== N_slab) .& (df.γ1 .== γ[1]) .& (df.γ2 .== γ[2]), :]
                ln = scatterlines!(ax, dfγ.N_img, dfγ.error_r, label = L"N_{slab} = %$N_slab", color = colors[i], linestyle = ls[j])
                push!(lns, ln)
            end
        end
    end

    axislegend(axr, position = :lt, labelsize = 20, merge = true, unique = true)

    save("figs/error_ICM_Ewald3D_2-1.png", f)
    save("figs/error_ICM_Ewald3D_2-1.pdf", f)

    f
end