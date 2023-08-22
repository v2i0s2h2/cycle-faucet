module {


    public type canister_id = Principal;

    public type canister_settings = {
        freezing_threshold : ?Nat;
        controllers : ?[Principal];
        memory_allocation : ?Nat;
        compute_allocation : ?Nat;
    };
    public type definite_canister_settings = {
        freezing_threshold : Nat;
        controllers : [Principal];
        memory_allocation : Nat;
        compute_allocation : Nat;
    };

    public type wasm_module = [Nat8];

    public type ManagementCanister = actor {
        canister_status : shared { canister_id : canister_id } -> async {
            status : { #stopped; #stopping; #running };
            memory_size : Nat;
            cycles : Nat;
            settings : definite_canister_settings;
            idle_cycles_burned_per_day : Nat;
            module_hash : ?[Nat8];
        };
    };
};
