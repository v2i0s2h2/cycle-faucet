import PT "publicType";
import RB "mo:base/RBTree";
import P "mo:base/Principal";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import List "mo:base/List";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Nat32 "mo:base/Nat32";


actor Cycles {

  
    public type User = {
        principal : Principal;
        username : Text;
        balance : Nat;
    };

  type ManagementCanisterInterface = PT.ManagementCanister;

  let ManagementCanister = actor ("aaaaa-aa") : ManagementCanisterInterface;

  func get_cycles() : async Nat {
    let status = await ManagementCanister.canister_status({
      canister_id = P.fromActor(Cycles);
    });
    return status.cycles;
  };

  // cycle test in array data structure //////////////////////////////////////////////////////

  var array : [var User] = [var];

  public func array_size() : async Nat {
    array.size();
  };

  public shared ({caller}) func test_array(n : Nat) : async Nat {

    // get cycles balance before creating new users
    let before = await get_cycles();

    for (i in Iter.range(1, n)) {
      array := Array.init<User>(
        i,
        {
          principal = caller;
          username = "name";
          balance = 0;
        },
      );
    };
    // get cycles balance after creating new users
    let after = await get_cycles();

    // return cycle difference
    (before - after);
  };

// cycle test in hashmap data structure //////////////////////////////////////////////////////

let myMap = HashMap.HashMap<Nat, User>(1000, Nat.equal, func x = Nat32.fromNat(x));

  public func hashmap_size() : async Nat {
    myMap.size();
  };

   public shared ({caller}) func test_hashmap(n : Nat) : async (Nat) {

    // get cycles balance before creating new users
    let before = await get_cycles();

    for (i in Iter.range(1, n)) {
      myMap.put(
        i,
        {
          principal = caller;
          username = "name";
          balance = 0;
        },
      );
    };

    // get cycles balance after creating new users
    let after = await get_cycles();

    // return cycle difference
    (before - after)

  };

//// cycle test in list data structure //////////////////////////////////////////////////////

type List<T> = ?(T, List<T>);

  let myList : ?(User, List<User>) = List.nil();

  public func isNil() : async Bool {
    List.isNil(myList);
  };

  public func list_size() : async Nat {
    List.size(myList);
  };

  public shared ({caller}) func test_list(n : Nat) : async (Nat) {

    // get cycles balance before creating new users
    let before = await get_cycles();

    var array : [var User] = Array.init<User>(
      n,
      {
        principal = caller;
        username = "name";
        balance = 0;
      },
    );

    for (user in array.vals()) {
      let newlist = List.push<User>(user, myList);
    };

    // get cycles balance after creating new users
    let after = await get_cycles();

    // return cycle difference
    (before - after)

  };

// cycle test in buffer data structure //////////////////////////////////////////////////////

let userStorage = Buffer.Buffer<User>(10000);

  public func buffer_size() : async Nat {
    userStorage.size();
  };

   public shared ({caller}) func test_Buffer(n : Nat) : async (Nat) {

    // get cycles balance before creating new users
    let before = await get_cycles();

    for (i in Iter.range(0, n-1)) {
      userStorage.put(
        i,
        {
          principal = caller;
          username = "name";
          balance = 0;
        },
      );
    };

    // get cycles balance after creating new users
    let after = await get_cycles();

    // return cycle difference
    (before - after)

  };

  public func write_test() : async (Nat, Nat, Nat) {
    (
      await test_array(10),
      await test_list(10),
      //await test_Buffer(10),
      await test_hashmap(10),
    );
  };

};
