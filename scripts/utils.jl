using ExTinyMD, EwaldSummations
using JLD2, CSV, DataFrames

function cal_energy(jld_path, γu, γd, s, M)
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
    
    α = s / (Lx / 2 - 0.1)
    ICMEwald2D_Interaction = IcmEwald2DInteraction(n_atoms, s, α, (γu, γd), L, M)
    energy_ewald = ICM_Ewald2D_energy(ICMEwald2D_Interaction, coords, charge)

    @info "H = $(H), γu = $(γu), γd = $(γd), s = $(s), M = $(M), energy_ewald = $(energy_ewald)"
    return energy_ewald
end

function cal_force(jld_path, γu, γd, s, M)
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

    α = s / (Lx / 2 - 0.1)
    ICMEwald2D_Interaction = IcmEwald2DInteraction(n_atoms, s, α, (γu, γd), L, M)
    force_ewald = ICM_Ewald2D_force(ICMEwald2D_Interaction, coords, charge)

    @info "H = $(H), γu = $(γu), γd = $(γd), s = $(s), M = $(M)"
    return force_ewald
end


function cal_energy_EwaldELC(jld_path, γu, γd, s, M, Ns)
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

    α = s / (Lx / 2 - 0.1)
    ICMEwald3D_interaction = IcmEwald3DInteraction(n_atoms, s, α, (γu, γd), L, M, Ns)
    energy_ewald = ICM_Ewald3D_energy(ICMEwald3D_interaction, coords, charge)

    @info "H = $(H), γu = $(γu), γd = $(γd), s = $(s), M = $(M), Ns = $(Ns), energy_ewald = $(energy_ewald)"
    return energy_ewald
end

function cal_force_EwaldELC(jld_path, γu, γd, s, M, Ns)
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

    α = s / (Lx / 2 - 0.1)
    ICMEwald3D_interaction = IcmEwald3DInteraction(n_atoms, s, α, (γu, γd), L, M, Ns)
    force_ewald = ICM_Ewald3D_force(ICMEwald3D_interaction, coords, charge)

    @info "H = $(H), γu = $(γu), γd = $(γd), s = $(s), M = $(M), Ns = $(Ns)"
    return force_ewald
end

function max_rel_error(f, f_exact)
    return maximum(sqrt.(dist2.(f - f_exact)) ./ sqrt.(dist2.(f_exact)))
end

function load_refs()
    refs = CSV.read("data/refs.csv", DataFrame)
    return refs
end

function load_refs_n2()
    refs = CSV.read("data/refs_n2.csv", DataFrame)
    return refs
end