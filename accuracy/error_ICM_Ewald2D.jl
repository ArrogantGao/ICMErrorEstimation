include("utils.jl")

begin
    refs = load_refs()

    data_file = CSV.write("data/error_ICM_Ewald2D.csv", DataFrame(H = Float64[], M = Float64[], γu = Float64[], γd = Float64[], energy = Float64[], error_r = Float64[]))
    for H in [10.0, 5.0, 1.0, 0.5, 0.1]
        jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
        for (γu, γd) in [(0.6, 0.6), (0.6, -0.6), (-0.6, -0.6), (0.95, 0.95), (0.95, -0.95), (-0.95, -0.95), (1.0, 1.0), (1.0, -1.0), (-1.0, -1.0), (0.3, 0.3), (0.5, 0.5)]
            for M in 1:2:30
                s = 6.0
                energy_ewald = cal_energy(jld_path, γu, γd, s, M)
                energy_exact = refs[refs.H .== H .&& refs.γu .== γu .&& refs.γd .== γd, :energy_exact][1]
                error_r = abs(energy_ewald - energy_exact) / abs(energy_exact)
                @info "H = $(H), M = $(M), γu = $(γu), γd = $(γd), energy_ewald = $(energy_ewald), energy_exact = $(energy_exact), error_r = $(error_r)"
                CSV.write("data/error_ICM_Ewald2D.csv", DataFrame(H = H, M = M, γu = γu, γd = γd, energy = energy_ewald, error_r = error_r), append = true)
            end
        end
    end
end