include("utils.jl")

begin
    refs = load_refs_md()

    data_file = CSV.write("data/error_ICM_Ewald2D_md.csv", DataFrame(i = Int64[], H = Float64[], M = Float64[], γu = Float64[], γd = Float64[], energy = Float64[], error_r = Float64[], error_a = Float64[]))
    for i in 1:10
        for H in [5.0]
            jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39_md_$(i).jld2"
            for (γu, γd) in [(0.3, 0.3), (0.6, 0.6), (1.0, 1.0)]
                for M in 1:2:15
                    s = 6.0
                    energy_ewald = cal_energy(jld_path, γu, γd, s, M)
                    energy_exact = refs[refs.H .== H .&& refs.γu .== γu .&& refs.γd .== γd .&& refs.i .== i, :energy_exact][1]
                    error_a = abs(energy_ewald - energy_exact)
                    error_r = abs(energy_ewald - energy_exact) / abs(energy_exact)
                    @info "i = $(i), H = $(H), M = $(M), γu = $(γu), γd = $(γd), energy_ewald = $(energy_ewald), energy_exact = $(energy_exact), error_r = $(error_r), error_a = $(error_a)"
                    CSV.write(data_file, DataFrame(i = i, H = H, M = M, γu = γu, γd = γd, energy = energy_ewald, error_r = error_r, error_a = error_a), append = true)
                end
            end
        end
    end
end