include("utils.jl")

begin
    @load "data/force_refs.jld2" force_dict

    data_file = CSV.write("data/error_EwaldELC_force.csv", DataFrame(H = Float64[], rr = Float64[], error_r = Float64[]))
    for H in [10.0, 5.0, 1.0, 0.5, 0.1]
        jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
        for r in 0.0:10.0
            Lx = 10.0
            Lz = r * Lx + H
            Ns = Int(ceil((Lz - H) / (2H)))
            f = cal_force_EwaldELC(jld_path, 0.0, 0.0, 6.0, 1, Ns)
            f_exact = force_dict[(H, 0.0, 0.0)]
            er = max_rel_error(f, f_exact)
            rr = ((2Ns + 1) * H - H) / Lx
            @info "H = $(H), r = $(r), Ns = $(Ns), rr = $(rr), er = $(er)"
            CSV.write(data_file, DataFrame(H = H, rr = rr, error_r = er), append = true)
        end
    end
end