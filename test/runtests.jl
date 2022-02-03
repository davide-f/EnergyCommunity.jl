using EnergyCommunity, JuMP, Plots
using Test, FileIO, GLPK, MathOptInterface

ENV["GKSwstype"]="nul"

const MOI = MathOptInterface

# EC groups
const EC_GROUPS = [EnergyCommunity.GroupCO(), EnergyCommunity.GroupNC()]


include("tests.jl")

@testset "EnergyCommunity tests" begin

    # Loop over group types
    for group in EC_GROUPS

        _base_test(GLPK.Optimizer, group)

    end

end
