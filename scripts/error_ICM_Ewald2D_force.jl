include("utils.jl")

begin
    @load "data/force_refs.jld2" force_dict

    data_file = CSV.write("data/error_ICM_Ewald2D_force.csv", DataFrame(H = Float64[], M = Float64[], γu = Float64[], γd = Float64[], error_r = Float64[]))
    for H in [10.0, 5.0, 1.0, 0.5, 0.1]
        jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
        for (γu, γd) in [(0.3, 0.3), (0.6, 0.6), (1.0, 1.0)]
            for M in 1:2:30
                s = 6.0
                f = cal_force(jld_path, γu, γd, s, M)
                f_exact = force_dict[(H, γu, γd)]
                error_r = max_rel_error(f, f_exact)
                @info "H = $(H), M = $(M), γu = $(γu), γd = $(γd), error_r = $(error_r)"
                CSV.write("data/error_ICM_Ewald2D_force.csv", DataFrame(H = H, M = M, γu = γu, γd = γd, error_r = error_r), append = true)
            end
        end
    end
end