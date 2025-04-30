include("utils.jl")

function jld_name(sys, H, i)
    if sys == 1
        return "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39_seed_$(i).jld2"
    elseif sys == 2
        return "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39_md_$(i).jld2"
    elseif sys == 3
        return "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_2_seed_$(i).jld2"
    end
end

function cal_error(refs, data_file, γu, γd, H, r, M, sys)
    Lz = H + 10.0 * r
    Ns = (Lz - H) / (2H)
    for i in 1:10
        jld_path = jld_name(sys, H, i)
        e = cal_energy_EwaldELC(jld_path, γu, γd, 6.0, M, Ns)
        e_exact = refs[refs.H .== H .&& refs.γu .== γu .&& refs.γd .== γd .&& refs.i .== i, :energy_exact][1]
        er = abs(e - e_exact) / abs(e_exact)
        ea = abs(e - e_exact)
        @info "i = $(i), H = $(H), r = $(r), Lz = $(Lz), γu = $(γu), γd = $(γd), M = $(M), e = $(e), e_exact = $(e_exact), er = $(er), ea = $(ea)"
        CSV.write(data_file, DataFrame(i = i, H = H, r = r, Lz = Lz, γu = γu, γd = γd, M = M, energy = e, error_r = er, error_a = ea), append = true)
    end
    nothing
end

begin
    refss = [load_refs(), load_refs_md(), load_refs_n2()]
    data_files = ["data/error_ICM_EwaldELC_compare_n39.csv", "data/error_ICM_EwaldELC_compare_n39_md.csv", "data/error_ICM_EwaldELC_compare_n2.csv"]

    γ = 1.0
    γu = γ
    γd = γ
    H = 5.0

    for sys in 1:3
        r = 5.0
        for M in 1:2:15
            cal_error(refss[sys], data_files[sys], γu, γd, H, r, M, sys)
        end

        M = 7
        for r in 1.0:1.0:10.0
            cal_error(refss[sys], data_files[sys], γu, γd, H, r, M, sys)
        end
    end
end