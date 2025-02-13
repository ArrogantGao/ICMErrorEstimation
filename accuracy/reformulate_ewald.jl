using ExTinyMD, EwaldSummations
using CSV, DataFrames
using Random
Random.seed!(1234)

n_atoms = 39
Lxy = 15.0

atoms = Vector{Atom{Float64}}()
for i in 1:26
    push!(atoms, Atom(type = 1, mass = 1.0, charge = 1.0))
end

for i in 1:13
    push!(atoms, Atom(type = 2, mass = 1.0, charge = - 2.0))
end

N_slabs = [1:10...]

data_file = "data/reformulate_ewald.csv"
df0 = DataFrame(Lz = Float64[], N_slab = Int64[], E_exact = Float64[], E_ewald = Float64[], error_r = Float64[])
CSV.write(data_file, df0)

for Lz in [1.0, 3.0, 5.0]
    L = (Lxy, Lxy, Lz)
    boundary = ExTinyMD.Q2dBoundary(Lxy, Lxy, Lz)
    info = SimulationInfo(n_atoms, atoms, (0.0, Lxy, 0.0, Lxy, 0.0, Lz), boundary; min_r = 0.5, temp = 1.0)
    coords = [p_info.position for p_info in info.particle_info]
    charge = [atoms[p_info.id].charge for p_info in info.particle_info]

    γ = (0.0, 0.0)

    ICMEwald2D_Interaction = IcmEwald2DInteraction(n_atoms, 6.0, 1.0, γ, L, 0)
    energy_exact = ICM_Ewald2D_energy(ICMEwald2D_Interaction, coords, charge)

    N_img = 0

    for n_slab in N_slabs
        ICMEwald3D_interaction = IcmEwald3DInteraction(n_atoms, 4.0, 1.0, γ, L, N_img, n_slab)
        energy_ewald = ICM_Ewald3D_energy(ICMEwald3D_interaction, coords, charge)
        er = abs(energy_ewald - energy_exact) / abs(energy_exact)
        @show N_img, n_slab, γ, er, Lz
        df = DataFrame(Lz = Lz, N_slab = n_slab, E_exact = energy_exact, E_ewald = energy_ewald, error_r = er)
        CSV.write(data_file, df, append = true)
    end
end