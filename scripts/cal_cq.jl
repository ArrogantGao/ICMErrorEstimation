using ExTinyMD, JLD2

function load_data(jld_path)
    data = load(jld_path)
    n_atoms = data["n_atoms"]
    Lx = data["Lx"]
    Ly = data["Ly"]
    H = data["H"]
    atoms = data["atoms"]
    info = data["info"]
    coords = [p_info.position for p_info in info.particle_info]
    charge = [atoms[p_info.id].charge for p_info in info.particle_info]
    L = (Lx, Ly, H)
    return coords, charge, L
end

for i in 1:10
    jld_path = "reference_results/Lx_10.0_Ly_10.0_H_5.0_n_39_md_$(i).jld2"
    coords, charge, L = load_data(jld_path)
    Lx, Ly, H = L

    n_max = 10
    for ni in 1:length(charge)
        Cq = 0.0
        mxmy = (0.0, 0.0)
        for mx in -n_max:n_max
            for my in -n_max:n_max
                if mx == 0 && my == 0
                    continue
                end
                kx = 2π * mx / Lx
                ky = 2π * my / Ly
                t = 0.0
                for nj in 1:length(charge)
                    t += charge[nj] * exp(im * (kx * (coords[ni][1] - coords[nj][1]) + ky * (coords[ni][2] - coords[nj][2])))
                end
                if abs(t) > Cq
                    mxmy = (mx, my)
                    Cq = abs(t)
                end
            end
        end
        @show i, ni, Cq, mxmy
    end
end