include("utils.jl")

begin
    @load "data/force_refs.jld2" force_dict

    data_file = "data/error_parameter_select_force.csv"

    data_file = CSV.write(data_file, DataFrame(H = Float64[], s = Float64[], Lz = Float64[], γu = Float64[], γd = Float64[], M = Int[], error_r = Float64[]))

    for γ in [0.6]
        γu = γ
        γd = γ
        for H in [1.0]
            for (Lz, s) in [(15.0, 3.0), (30.0, 4.0), (45.0, 5.0)]
                Ns = (Lz - H) / (2H)
                for M in 0:1:30
                    jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
                    f = cal_force_EwaldELC(jld_path, γu, γd, s, M, Ns)
                    f_exact = force_dict[(H, γu, γd)]
                    er = max_rel_error(f, f_exact)
                    @info "H = $(H), s = $(s), Lz = $(Lz), γu = $(γu), γd = $(γd), M = $(M), er = $(er)"
                    CSV.write(data_file, DataFrame(H = H, s = s, Lz = Lz, γu = γu, γd = γd, M = M, error_r = er), append = true)
                end
            end

            for (M, s) in [(9, 3.0), (17, 4.0), (25, 5.0)]
                for Lz in 5.0:5.0:50.0
                    Ns = (Lz - H) / (2H)
                    jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
                    f = cal_force_EwaldELC(jld_path, γu, γd, s, M, Ns)
                    f_exact = force_dict[(H, γu, γd)]
                    er = max_rel_error(f, f_exact)
                    @info "H = $(H), s = $(s), Lz = $(Lz), γu = $(γu), γd = $(γd), M = $(M), er = $(er)"
                    CSV.write(data_file, DataFrame(H = H, s = s, Lz = Lz, γu = γu, γd = γd, M = M, error_r = er), append = true)
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
                    f = cal_force_EwaldELC(jld_path, γu, γd, s, M, Ns)
                    f_exact = force_dict[(H, γu, γd)]
                    er = max_rel_error(f, f_exact)
                    @info "H = $(H), s = $(s), Lz = $(Lz), γu = $(γu), γd = $(γd), M = $(M), er = $(er)"
                    CSV.write(data_file, DataFrame(H = H, s = s, Lz = Lz, γu = γu, γd = γd, M = M, error_r = er), append = true)
                end
            end

            for (M, s) in [(16, 3.0), (31, 4.0), (45, 5.0)]
                for Lz in 5.0:5.0:100.0
                    Ns = (Lz - H) / (2H)
                    jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
                    f = cal_force_EwaldELC(jld_path, γu, γd, s, M, Ns)
                    f_exact = force_dict[(H, γu, γd)]
                    er = max_rel_error(f, f_exact)
                    @info "H = $(H), s = $(s), Lz = $(Lz), γu = $(γu), γd = $(γd), M = $(M), er = $(er)"
                    CSV.write(data_file, DataFrame(H = H, s = s, Lz = Lz, γu = γu, γd = γd, M = M, error_r = er), append = true)
                end
            end
        end
    end
end