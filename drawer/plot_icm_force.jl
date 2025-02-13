include("setting.jl")

data_file = "data/error_ICM_Ewald2D_force.csv"

df = CSV.read(data_file, DataFrame)

# begin
#     f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 800), fontsize = 20)
#     ax = Axis(f[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)

#     for H in [0.1, 0.5, 1.0, 5.0, 10.0]
#         for γ in [0.6, 0.95, 1.0]
#             lines!(ax, df[df.H .== H .&& df.γu .== γ .&& df.γd .== γ, :M], df[df.H .== H .&& df.γu .== γ .&& df.γd .== γ, :error_r], label = L"H = %$H, \gamma = %$γ")
#         end
#     end
#     axislegend(ax)
#     save("figs/icm_error_force.png", f, px_per_unit = 2)
#     f
# end

# f

begin
    f = Figure(backgroundcolor = RGBf(1.0, 1.0, 1.0), size = (1000, 400), fontsize = 20)

    ax1 = Axis(f[1, 1], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)
    ax2 = Axis(f[1, 2], xlabel = L"M", ylabel = L"\mathcal{E}_r", yscale = log10)

    # for H in [0.5, 1.0, 5.0]
    for (l, H, ms, ls, c) in [("0.05", 0.5, markerstyle[1], linestyle[1], colors[1]), ("0.1", 1.0, markerstyle[2], linestyle[2], colors[2]), ("0.5", 5.0, markerstyle[3], linestyle[3], colors[3])]
        scatter!(ax1, df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M], df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r], label = l, marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        @. model(x, p) = p[1] + x*p[2]
        p0 = [1.0, 1.0]
        filter = df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r] .> 1e-9
        xdata = df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M][filter]
        ydata = log10.(df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r][filter])
        fit = curve_fit(model, xdata, ydata, p0)
        lines!(ax1, [0:20...], 10 .^ model([0:20...], fit.param), color = c, linestyle = :dash, linewidth = linewidth)
    end
    axislegend(ax1, L"H / L_x", position = :lb)
    xlims!(ax1, 0, 20)
    ylims!(ax1, 1e-14, 10)
    text!(ax1, 19.5, 1e-1, text = "(a)", fontsize = 30, align = (:right, :bottom))

    # scales = []
    # Hs = [0.1, 0.5, 1.0, 5.0]
    # for H in Hs
    #     x_data = df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M]
    #     y_data = df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r]
    #     @. model(x, p) = p[1] + x*p[2]
    #     p0 = [1.0, 1.0]
    #     filter = df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r] .> 1e-9
    #     xdata = df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :M][filter]
    #     ydata = log10.(df[df.H .== H .&& df.γu .== 1.0 .&& df.γd .== 1.0, :error_r][filter])
    #     fit = curve_fit(model, xdata, ydata, p0)
    #     push!(scales, fit.param[2])
    # end

    # ax1_in = Axis(f[1, 1], width=Relative(0.3), height=Relative(0.3), halign=0.9, valign=0.5, xlabel = L"\text{lg}(\gamma e^{-2\pi H / L_x})", ylabel = L"k", xticklabelsvisible = false, yticklabelsvisible = false, backgroundcolor = RGBf(1.0, 1.0, 1.0), xgridvisible = false, ygridvisible = false)
    # translate!(ax1_in.scene, 0, 0, 10)
    # # this needs separate translation as well, since it's drawn in the parent scene
    # translate!(ax1_in.elements[:background], 0, 0, 9)
    # scatter!(ax1_in, 2π .* Hs ./ 10,  - log(10.0) .* scales, color = :orange, strokecolor = :black, strokewidth = strokewidth)
    # lines!(ax1_in, 2π .* Hs ./ 10,  2π .* Hs ./ 10, color = :orange, linestyle = :dash, linewidth = linewidth)
    # text!(ax1_in, 2, 3, text = L"y = x", fontsize = 20, align = (:right, :top))

    # for γ in [0.6, 0.95, 1.0]
    for (l, γ, ms, ls, c) in [("0.3", 0.3, markerstyle[1], linestyle[1], colors[1]), ("0.6", 0.6, markerstyle[2], linestyle[2], colors[2]), ("1.0", 1.0, markerstyle[3], linestyle[3], colors[3])]
        scatter!(ax2, df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :M], df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :error_r], label = l, marker = ms, markersize = markersize, color = c, strokecolor = strokecolor, strokewidth = strokewidth)
        @. model(x, p) = p[1] + x*p[2]
        p0 = [1.0, 1.0]
        filter = df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :error_r] .> 1e-9
        xdata = df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :M][filter]
        ydata = log10.(df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :error_r][filter])
        fit = curve_fit(model, xdata, ydata, p0)
        lines!(ax2, [0:40...], 10 .^ model([0:40...], fit.param), color = c, linestyle = :dash, linewidth = linewidth)
    end
    axislegend(ax2, L"\gamma", position = :lb)
    xlims!(ax2, 0, 30)
    ylims!(ax2, 1e-14, 10)
    text!(ax2, 29, 1e-1, text = "(b)", fontsize = 30, align = (:right, :bottom))

    # scales = []
    # gammas = [0.3, 0.6, 1.0]
    # for γ in gammas
    #     x_data = df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :M]
    #     y_data = df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :error_r]
    #     @. model(x, p) = p[1] + x*p[2]
    #     p0 = [1.0, 1.0]
    #     filter = df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :error_r] .> 1e-9
    #     xdata = df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :M][filter]
    #     ydata = log10.(df[df.H .== 1.0 .&& df.γu .== γ .&& df.γd .== γ, :error_r][filter])
    #     fit = curve_fit(model, xdata, ydata, p0)
    #     push!(scales, fit.param[2])
    # end
    # xdata = log10.(gammas) .- 2π / 10 * log10(exp(1))
    # ax2_in = Axis(f[1, 2], width=Relative(0.3), height=Relative(0.3), halign=0.9, valign=0.5, xticklabelsvisible = false, yticklabelsvisible = false, backgroundcolor = RGBf(1.0, 1.0, 1.0), xgridvisible = false, ygridvisible = false, xlabel = L"\text{lg}(\gamma e^{-2\pi H / L_x})", ylabel = L"k")
    # translate!(ax2_in.scene, 0, 0, 10)
    # # this needs separate translation as well, since it's drawn in the parent scene
    # translate!(ax2_in.elements[:background], 0, 0, 9)
    # scatter!(ax2_in, xdata,  scales, color = :orange, strokecolor = :black, strokewidth = strokewidth)
    # lines!(ax2_in, xdata, scales, color = :orange, linestyle = :dash, linewidth = linewidth)
    # text!(ax2_in, - 0.5, - 0.25, text = L"y = x", fontsize = 20, align = (:right, :top))

    save("figs/icm_error_force.png", f, px_per_unit = 2)
    save("figs/icm_error_force.pdf", f)

    f
end

f