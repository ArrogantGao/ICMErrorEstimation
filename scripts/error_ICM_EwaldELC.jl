include("utils.jl")

begin
    refs = load_refs()

    data_file = CSV.write("data/error_ICM_EwaldELC.csv", DataFrame(i = Int64[], H = Float64[], r = Float64[], Lz = Float64[], γu = Float64[], γd = Float64[], M = Int[], energy = Float64[], error_r = Float64[], error_a = Float64[]))

    for i in 1:10
        for γ in [0.6, 0.95, 1.0]
            γu = γ
            γd = γ
            for H in [0.5, 1.0, 5.0]
                for r in 0.0:0.25:5.0
                    Lz = H + 10.0 * r
                    Ns = (Lz - H) / (2H)
                    for M in 0:5:100
                        jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39_seed_$(i).jld2"
                        e = cal_energy_EwaldELC(jld_path, γu, γd, 6.0, M, Ns)
                        e_exact = refs[refs.H .== H .&& refs.γu .== γu .&& refs.γd .== γd .&& refs.i .== i, :energy_exact][1]
                        er = abs(e - e_exact) / abs(e_exact)
                        ea = abs(e - e_exact)
                        @info "i = $(i), H = $(H), r = $(r), Lz = $(Lz), γu = $(γu), γd = $(γd), M = $(M), e = $(e), e_exact = $(e_exact), er = $(er), ea = $(ea)"
                        CSV.write(data_file, DataFrame(i = i, H = H, r = r, Lz = Lz, γu = γu, γd = γd, M = M, energy = e, error_r = er, error_a = ea), append = true)
                    end
                end
            end
        end
    end
end