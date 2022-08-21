import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Int "mo:base/Int";
import Time "mo:base/Time";

import Principal "mo:base/Principal";
import Result "mo:base/Result";


import Types "types";
import State "state";
import Card "game/card";
import Player "game/player";

actor MemoryCardGame {

    type Response<Ok> = Result.Result<Ok, Types.Error>;
    var state : State.State = State.empty();


    // Card---------------------------------------------------------------------------
    public shared({caller}) func createCard(card : Types.Card) : async Response<Text> {
        if(Principal.toText(caller) == "2vxsx-fae") {
            return #err(#NotAuthorized);//isNotAuthorized
        };
        let rsCard = state.cards.get(card.data);
        switch (rsCard) {
            case (?V) { #err(#AlreadyExisting); };
            case null {
                Card.create(card,state);
                #ok("Success");
            };
        };
    };

    public shared({caller}) func updateCard(card: Types.Card) : async Response<Text> {
        if(Principal.toText(caller) == "2vxsx-fae") {
            return #err(#NotAuthorized);//isNotAuthorized
        };
        let rsCard = state.cards.get(card.data);
        switch (rsCard) {
            case null { #err(#NotFound); };
            case (?V) {
                Card.update(card, state);
                #ok("Success");
            };
        };
    };

    public shared({caller}) func deleteCard(card: Types.Card) : async Response<Text> {
        if(Principal.toText(caller) == "2vxsx-fae") {
            return #err(#NotAuthorized);//isNotAuthorized
        };
        let rsCard = state.cards.get(card.data);
        switch (rsCard) {
            case null { #err(#NotFound); };
            case (?V) {
                let deleted = state.cards.remove(card.data);
                #ok("Success");
            };
        };
    };

    public shared query({caller}) func listCards() : async Response<[Types.Card]> {
        var list : [Types.Card] = [];
        // if(Principal.toText(caller) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);//isNotAuthorized
        // };
        for((_,card) in state.cards.entries()) {
            list := Array.append<Types.Card>(list, [card]);
        };
        #ok((list));
    };

    public shared ({caller}) func duplicateCards() : async Response<[Types.Card]> {
        var list : [Types.Card] = [];
        // if(Principal.toText(caller) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);//isNotAuthorized
        // };

        for((_,card) in state.cards.entries()) {
            list := Array.append<Types.Card>(list, [card]);
            list := Array.append<Types.Card>(list, [card]);
        };
        #ok((list));

        // var shuffleList : [var Types.Card] = Array.thaw(list);
        // let size = list.size();
        // let iter = Array.tabulate(size, func (n : Nat) : Types.Card {list[size - 1 - n];}).keys();
        // for (i in iter) {
        //     let j = Int.abs(await Random.randomNumber(0,i+1));
        //     let temp = shuffleList[i];
        //     shuffleList[i] := shuffleList[j];
        //     shuffleList[j] := temp;
        // };
        // #ok((Array.freeze(shuffleList)));
    };


    // GameProgress---------------------------------------------------------------------------
    public shared ({caller}) func checkCardPair(cardPair : (Types.Card, Types.Card), timeAmount : Int ) : async Response<Text> {
        // if(Principal.toText(caller) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);//isNotAuthorized
        // };

        // if card data input from player is not in the database, return error
        if (Card.findCard(cardPair.0,state) == false or Card.findCard(cardPair.1,state) == false)
        {
            return #err(#NotFound);
        };
        let rsPlayer = state.players.get(caller);
        switch (rsPlayer) {
            case null { // if a player doesnt exists, create a data for them 
                let player = Player.create(caller,state);
                Player.createGameProgress(player,cardPair,state);
            };
            case (?V) { // if player exists, create or update a progress based on isPlaying field
                if (V.isPlaying==false) {
                    Player.createGameProgress(V,cardPair,state);
                }
                else {
                    Player.updateGameProgress(V,cardPair,state,timeAmount);
                };
            };
        };
        #ok("Success");

    };

    public shared query({caller}) func isValidGameProgress(clientSequence : [(Types.Card, Types.Card)] ) : async Response<Bool> {
        // if(Principal.toText(caller) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);//isNotAuthorized
        // };
        let rsPlayer = state.players.get(caller);
        switch (rsPlayer) {
            case null { #err(#NotFound); };
            case (?V) {
                if (V.isPlaying==false and V.gameProgresses[ V.gameProgresses.size() - 1 ].chosenSequence == clientSequence)
                {
                    return #ok(true);
                };
                return #ok(false);
            };
        };
    };

    public shared query({caller}) func listPlayers() : async Response<[Types.Player]> {
        var list : [Types.Player] = [];
        // if(Principal.toText(caller) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);//isNotAuthorized
        // };
        for((_,player) in state.players.entries()) {
            list := Array.append<Types.Player>(list, [player]);
        };
        #ok((list));
    };

};
