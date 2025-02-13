include("utils.jl")

begin

    data_file = CSV.write("data/refs.csv", DataFrame(H = Float64[], γu = Float64[], γd = Float64[], energy_exact = Float64[]))
    for (H, M) in [(10.0, 100), (5.0, 200), (1.0, 200), (0.5, 400), (0.1, 1000)]
        jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
        for (γu, γd) in [(0.3, 0.3), (0.5, 0.5), (0.6, 0.6), (0.6, -0.6), (-0.6, -0.6), (0.95, 0.95), (0.95, -0.95), (-0.95, -0.95), (1.0, 1.0), (1.0, -1.0), (-1.0, -1.0)]
            s = 6.0
            energy_ewald = cal_energy(jld_path, γu, γd, s, M)
            CSV.write("data/refs.csv", DataFrame(H = H, γu = γu, γd = γd, energy_exact = energy_ewald), append = true)
        end
    end

    for H in [10.0, 5.0, 1.0, 0.5, 0.1]
        jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
        s = 6.0
        energy_ewald = cal_energy(jld_path, 0.0, 0.0, s, 1)
        CSV.write("data/refs.csv", DataFrame(H = H, γu = 0.0, γd = 0.0, energy_exact = energy_ewald), append = true)
    end
end