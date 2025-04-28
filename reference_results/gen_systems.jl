using ExTinyMD, EwaldSummations
using JLD2
using Random

Lx = 10.0
Ly = 10.0
Hs = [0.1, 0.5, 1.0, 5.0, 10.0]

s = 7.0

for H in Hs
    for i in 1:10
        n_atoms = 39
        Random.seed!(i)

        boundary = ExTinyMD.Q2dBoundary(Lx, Ly, H)

        atoms = Vector{Atom{Float64}}()
        for i in 1:13
            push!(atoms, Atom(type = 1, mass = 1.0, charge = 2.0))
        end
        for i in 14:39
            push!(atoms, Atom(type = 2, mass = 1.0, charge = - 1.0))
        end

        info = SimulationInfo(n_atoms, atoms, (0.0, Lx, 0.0, Ly, 0.0, H), boundary; min_r = 0.1, temp = 1.0)

        @save "reference_results/Lx_$(Lx)_Ly_$(Ly)_H_$(H)_n_$(n_atoms)_seed_$(i).jld2" n_atoms Lx Ly H atoms info
    end

    for i in 1:10
        n_atoms = 2
        Random.seed!(i)
        boundary = ExTinyMD.Q2dBoundary(Lx, Ly, H)
        
        atoms = Vector{Atom{Float64}}()
        push!(atoms, Atom(type = 1, mass = 1.0, charge = 1.0))
        push!(atoms, Atom(type = 2, mass = 1.0, charge = - 1.0))

        info = SimulationInfo(n_atoms, atoms, (0.0, Lx, 0.0, Ly, 0.0, H), boundary; min_r = 0.1, temp = 1.0)

        @save "reference_results/Lx_$(Lx)_Ly_$(Ly)_H_$(H)_n_2_seed_$(i).jld2" n_atoms Lx Ly H atoms info
    end
end