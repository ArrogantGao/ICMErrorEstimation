include("utils.jl")

begin

    force_dict = Dict()
    # @load "data/force_refs.jld2" force_dict

    for (H, M) in [(10.0, 100), (5.0, 200), (1.0, 200), (0.5, 400), (0.1, 1000)]
        jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
        for (γu, γd) in [(0.3, 0.3), (0.6, 0.6), (1.0, 1.0)]
            s = 6.0
            force_ewald = cal_force(jld_path, γu, γd, s, M)
            force_dict[(H, γu, γd)] = force_ewald
        end
    end

    for H in [10.0, 5.0, 1.0, 0.5, 0.1]
        jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
        s = 6.0
        force_ewald = cal_force(jld_path, 0.0, 0.0, s, 1)
        force_dict[(H, 0.0, 0.0)] = force_ewald
    end

    @save "data/force_refs.jld2" force_dict
end
