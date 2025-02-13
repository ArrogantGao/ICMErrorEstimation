include("utils.jl")

begin
    refs = load_refs()

    data_file = CSV.write("data/error_parameter_select.csv", DataFrame(H = Float64[], s = Float64[], Lz = Float64[], γu = Float64[], γd = Float64[], M = Int[], energy = Float64[], error_r = Float64[]))

    for γ in [0.6]
        γu = γ
        γd = γ
        for H in [1.0]
            for (Lz, s) in [(15.0, 3.0), (30.0, 4.0), (45.0, 5.0)]
                Ns = (Lz - H) / (2H)
                for M in 0:1:30
                    jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
                    e = cal_energy_EwaldELC(jld_path, γu, γd, s, M, Ns)
                    e_exact = refs[refs.H .== H .&& refs.γu .== γu .&& refs.γd .== γd, :energy_exact][1]
                    er = abs(e - e_exact) / abs(e_exact)
                    @info "H = $(H), s = $(s), Lz = $(Lz), γu = $(γu), γd = $(γd), M = $(M), e = $(e), e_exact = $(e_exact), er = $(er)"
                    CSV.write(data_file, DataFrame(H = H, s = s, Lz = Lz, γu = γu, γd = γd, M = M, energy = e, error_r = er), append = true)
                end
            end
        end
    end

    for γ in [1.0]
        γu = γ
        γd = γ
        for H in [1.0]
            for (Lz, s) in [(32.0, 3.0), (62.0, 4.0), (91.0, 5.0)]
                Ns = (Lz - H) / (2H)
                for M in 0:1:50
                    jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
                    e = cal_energy_EwaldELC(jld_path, γu, γd, s, M, Ns)
                    e_exact = refs[refs.H .== H .&& refs.γu .== γu .&& refs.γd .== γd, :energy_exact][1]
                    er = abs(e - e_exact) / abs(e_exact)
                    @info "H = $(H), s = $(s), Lz = $(Lz), γu = $(γu), γd = $(γd), M = $(M), e = $(e), e_exact = $(e_exact), er = $(er)"
                    CSV.write(data_file, DataFrame(H = H, s = s, Lz = Lz, γu = γu, γd = γd, M = M, energy = e, error_r = er), append = true)
                end
            end
        end
    end
end