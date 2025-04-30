include("utils.jl")

begin
    refs = load_refs_md()

    data_file = CSV.write("data/error_EwaldELC_md.csv", DataFrame(i = Int64[], H = Float64[], rr = Float64[], energy = Float64[], error_r = Float64[], error_a = Float64[]))
    for i in 1:10
        for H in [5.0]
            jld_path = "reference_results/Lx_10.0_Ly_10.0_H_$(H)_n_39_md_$(i).jld2"
            for r in 0.0:10.0
                Lx = 10.0
                Lz = r * Lx + H
                Ns = Int(ceil((Lz - H) / (2H)))
                e = cal_energy_EwaldELC(jld_path, 0.0, 0.0, 6.0, 1, Ns)
                e_exact = refs[refs.H .== H .&& refs.γu .== 0.0 .&& refs.γd .== 0.0 .&& refs.i .== i, :energy_exact][1]
                ea = abs(e - e_exact)
                er = abs(e - e_exact) / abs(e_exact)
                rr = ((2Ns + 1) * H - H) / Lx
                @info "H = $(H), r = $(r), Ns = $(Ns), rr = $(rr), e = $(e), e_exact = $(e_exact), er = $(er), ea = $(ea)"
                CSV.write(data_file, DataFrame(i = i, H = H, rr = rr, energy = e, error_r = er, error_a = ea), append = true)
            end
        end
    end
end