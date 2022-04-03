function _base_test(input_file, group, optimizer)

    ## Parameters

    output_file_isolated = joinpath(@__DIR__, "./results/output_file_NC.xlsx")  # Output file - model users alone
    output_plot_isolated = joinpath(@__DIR__, "./results/Img/plot_user_{:s}_NC.png")  # Output png file of plot - model users alone

    output_file_combined = joinpath(@__DIR__, "./results/output_file_EC.xlsx")  # Output file - model Energy community
    output_plot_combined = joinpath(@__DIR__, "./results/Img/plot_user_{:s}_EC.png")  # Output png file of plot - model energy community

    output_plot_sankey_agg = joinpath(@__DIR__, "./results/Img/sankey_EC.png")  # Output plot of the sankey plot related to the aggregator case
    output_plot_sankey_noagg = joinpath(@__DIR__, "./results/Img/sankey_NC.png")  # Output plot of the sankey plot related to the no aggregator case


    ## Model CO

    ## Initialization

    # Read data from excel file
    ECModel = ModelEC(input_file, group, optimizer)

    # set_group_type!(ECModel, GroupNC())

    build_model!(ECModel)

    optimize!(ECModel)

    @test termination_status(ECModel) in [MOI.OPTIMAL, MOI.LOCALLY_SOLVED]

    plot(ECModel, output_plot_combined)

    print_summary(ECModel)

    save_summary(ECModel, output_file_combined)

    grid_shares_EC = calculate_grid_import(ECModel)
    energy_shares_EC = calculate_production_shares(ECModel)
    
    @test_reference "refs/group_$(string(group)).png" plot_sankey(ECModel)

end

function _callback_test(input_file, optimizer)

    ## Model CO

    ## Initialization

    # Read data from excel file
    ECModel = ModelEC(input_file, EnergyCommunity.GroupCO(), optimizer)

    # set_group_type!(ECModel, GroupNC())

    callback = to_utility_callback_by_subgroup(ECModel)

    dist_base = callback([EC_CODE, get_user_set(ECModel)[1]])

    @test dist_base ≈ 0.0

    dist_base = callback([EC_CODE; get_user_set(ECModel)])

    @test !isnothing(dist_base)

end