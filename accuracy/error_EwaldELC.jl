include("utils.jl")

begin
    refs = load_refs()

    data_file = CSV.write("data/error_EwaldELC.csv", DataFrame(H = Float64[], rr = Float64[], energy = Float64[], error_r = Float64[]))
    for H in [10.0, 5.0, 1.0, 0.5, 0.1]
        jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39.jld2"
        for r in 0.0:10.0
            Lx = 10.0
            Lz = r * Lx + H
            Ns = Int(ceil((Lz - H) / (2H)))
            e = cal_energy_EwaldELC(jld_path, 0.0, 0.0, 6.0, 1, Ns)
            e_exact = refs[refs.H .== H .&& refs.γu .== 0.0 .&& refs.γd .== 0.0, :energy_exact][1]
            er = abs(e - e_exact) / abs(e_exact)
            rr = ((2Ns + 1) * H - H) / Lx
            @info "H = $(H), r = $(r), Ns = $(Ns), rr = $(rr), e = $(e), e_exact = $(e_exact), er = $(er)"
            CSV.write(data_file, DataFrame(H = H, rr = rr, energy = e, error_r = er), append = true)
        end
    end
end