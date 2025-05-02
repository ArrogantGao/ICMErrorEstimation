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

i = 1
jld_path = "reference_results/Lx_10.0_Ly_10.0_H_5.0_n_39_md_$(i).jld2"
coords, charge, L = load_data(jld_path)

