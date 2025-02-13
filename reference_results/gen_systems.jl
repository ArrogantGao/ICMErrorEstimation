using ExTinyMD, EwaldSummations
using JLD2
using Random
Random.seed!(1234)

n_atoms = 39
Lx = 10.0
Ly = 10.0
Hs = [0.1, 0.5, 1.0, 5.0, 10.0]

s = 7.0

for H in Hs
    boundary = ExTinyMD.Q2dBoundary(Lx, Ly, H)

    atoms = Vector{Atom{Float64}}()
    for i in 1:13
        push!(atoms, Atom(type = 1, mass = 1.0, charge = 2.0))
    end
    for i in 14:39
        push!(atoms, Atom(type = 2, mass = 1.0, charge = - 1.0))
    end

    info = SimulationInfo(n_atoms, atoms, (0.0, Lx, 0.0, Ly, 0.0, H), boundary; min_r = 0.1, temp = 1.0)

    @save "reference_results/Lx_$(Lx)_Ly_$(Ly)_H_$(H)_n_$(n_atoms).jld2" n_atoms Lx Ly H atoms info

    # α = s / (Lx / 2 - 0.1)
    # Ewald2D_interaction = Ewald2DInteraction(n_atoms, s, α, (Lx, Ly, H), ϵ = 1.0)

    # r_c = Ewald2D_interaction.r_c

    # Ewald2D_neighbor = CellList3D(info, Ewald2D_interaction.r_c, boundary, 1)
    # energy_ewald = energy(Ewald2D_interaction, Ewald2D_neighbor, info, atoms)
    # @show energy_ewald

    # @save "reference_results/H_$(H).jld2" n_atoms Lx Ly H atoms info energy_ewald
end