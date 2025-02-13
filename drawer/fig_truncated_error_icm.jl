using CSV, DataFrames
using CairoMakie, LaTeXStrings
using LsqFit

data_file = "data/truncate_error.csv"
data_file_force = "data/truncate_error_force.csv"

df = CSV.read(data_file, DataFrame)
df_force = CSV.read(data_file_force, DataFrame)

N_imgs = unique(df.N_img)

begin

    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (500, 700), fontsize = 20)
    ga = f[1, 1] = GridLayout()
    gb = f[2, 1] = GridLayout()

    axr = Axis(ga[1, 1], xlabel = L"M", ylabel = L"$\mathcal{E}_r$ (Energy)", yscale = log10, title = L"\gamma_u = \gamma_d = \gamma")
    axl = Axis(gb[1, 1], xlabel = L"M", ylabel = L"$\mathcal{E}_r$ (Force)", yscale = log10)

    xlims!(axr, 0, 18)
    ylims!(axr, 1e-16, 1e-2)

    xlims!(axl, 0, 18)
    ylims!(axl, 1e-16, 1e-2)

    colors = [:blue, :red, :green]
    ls = [:solid, :dash, :dot]
    
    for (i, Δ) in enumerate([0.1, 0.5, 0.9])
        # gammas = [(Δ, Δ), (-Δ, -Δ), (-Δ, Δ)]
        gammas = [(Δ, Δ)]
        for (j, γ) in enumerate(gammas)
            
            dfγ = df[(df.γ1 .== γ[1]) .& (df.γ2 .== γ[2]), :]
            ln = scatter!(axr, dfγ.N_img, dfγ.error_r .+ 1e-15, label = L"\gamma = %$(Δ)", color = colors[i])

            @. model(x, p) = log.(abs.((Δ + Δ^2) * p[1] * Δ^(x + 2) * exp(-2π * (x - 1) * 5 / 15) / (1 - Δ^2 * exp(-2π * 5 / 15))))
            raw_y_data = dfγ.error_r
            raw_x_data = dfγ.N_img
            n = findfirst(x -> x < 1e-14, raw_y_data)
            x_data = raw_x_data[1:n]
            y_data = raw_y_data[1:n]
            p0 = [1.0]
            fit = curve_fit(model, x_data, log.(abs.(y_data)), p0)
            @show fit.param[1]

            lines!(axr, [0:16...], exp.(model([0:16...], fit.param)), color = colors[i], linestyle = :dash)

            df_forceγ = df_force[(df_force.γ1 .== γ[1]) .& (df_force.γ2 .== γ[2]), :]
            ln = scatter!(axl, df_forceγ.N_img, df_forceγ.error_r .+ 1e-15, color = colors[i])

            @. model(x, p) = log.(abs.(p[1] * Δ^(x) * exp(-2π * (x - 1) * 5 / 15) ))
            raw_y_data = df_forceγ.error_r
            raw_x_data = df_forceγ.N_img
            n = findfirst(x -> x < 1e-14, raw_y_data)
            x_data = raw_x_data[1:n]
            y_data = raw_y_data[1:n]
            p0 = [1.0]
            fit = curve_fit(model, x_data, log.(abs.(y_data)), p0)
            lines!(axl, [0:16...], exp.(model([0:16...], fit.param)), color = colors[i], linestyle = :dash)

        end
    end

    axislegend(axr, position = :rt, labelsize = 20)

    text!(axr, (1, 10^(-15)), text = "(a)", fontsize = 30, align = (:left, :baseline))
    text!(axl, (1, 10^(-15)), text = "(b)", fontsize = 30, align = (:left, :baseline))

    save("figs/truncate_error.png", f)
    save("figs/truncate_error.pdf", f)

    f
end