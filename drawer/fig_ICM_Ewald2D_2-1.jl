using CSV, DataFrames
using CairoMakie, LaTeXStrings

data_file = "data/ICM_Ewald2D_2-1.csv"

df = CSV.read(data_file, DataFrame)

N_imgs = unique(df.N_img)

begin

    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 400), fontsize = 20)
    ga = f[1, 1] = GridLayout()

    axr = Axis(ga[1, 1], xlabel = L"N_{img}", ylabel = L"\mathcal{E}_r", yscale = log10)

    xlims!(axr, 0, 20)
    ylims!(axr, 1e-16, 1e-2)

    colors = [:blue, :red, :green]
    ls = [:solid, :dash, :dot]

    lelement = [LineElement(linestyle = l, color = :black) for l in ls]
    lname = [L"\gamma = (\Delta, \Delta)", L"\gamma = (-\Delta, -\Delta)", L"\gamma = (-\Delta, \Delta)"]

    for (i, Δ) in enumerate([0.3, 0.6, 0.9])
        for (j, γ) in enumerate([(Δ, Δ), (-Δ, -Δ), (-Δ, Δ)])
            dfγ = df[(df.γ1 .== γ[1]) .& (df.γ2 .== γ[2]), :]
            ln = scatterlines!(axr, dfγ.N_img, dfγ.error_r .+ 1e-16, label = L"%$(γ[1]), %$(γ[2])", color = colors[i], linestyle = ls[j])
        end
    end

    axislegend(axr, L"$\gamma$", position = :rt, labelsize = 12, merge = true, unique = true, nbanks = 3, titlesize = 15)

    save("figs/error_ICM_Ewald2D_2-1.png", f)
    save("figs/error_ICM_Ewald2D_2-1.pdf", f)

    f
end