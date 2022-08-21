import Array "mo:base/Array";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Debug "mo:base/Debug";

import Card "card";
import Types "../types";
import State "../state";

module Player {
    public func init(userid : Principal) : Types.Player {
        let newPlayer : Types.Player = {
            userid = userid;
            isPlaying = false;
            gameProgresses = [];
        };
        return newPlayer;
    };

    public func create(userid : Principal, state : State.State) : Types.Player {
        let newPlayer = init(userid);
        state.players.put(userid, newPlayer );
        return newPlayer;
    };

    public func update(player : Types.Player, state : State.State) {
       let updated = state.players.replace(player.userid, player);
    };
    
    public func createGameProgress(player : Types.Player, cardPair : (Types.Card, Types.Card), state: State.State) {
        let gameProgress : Types.GameProgress = {
            startTime = Time.now()/1000_000_000;
            chosenSequence = [cardPair];
            matchedPair = Card.isMatchedCardPair(cardPair);
            score = 1;
        };
        let updatePlayer : Types.Player = {
            userid = player.userid;
            isPlaying = true;
            gameProgresses = Array.append(player.gameProgresses,[gameProgress]);
        };
        let updated = update(updatePlayer,state);
    };

    public func updateGameProgress(player : Types.Player, cardPair : (Types.Card, Types.Card), state: State.State, timeAmount : Int) {

        var lastestGameProgress = player.gameProgresses[ player.gameProgresses.size() - 1 ];
        // if the player choose a matched pair which have already been in the chosenSequence, return;
        if (Card.isMatchedCardPair(cardPair)==1) {
            if (Card.findCardPair(cardPair,lastestGameProgress.chosenSequence)==true) {
                Debug.print("invalid card");
                return;
            };
        };
        // check if the current gameprogress of player is completed, if yes then add amountTime to score to get the final score.
        let isCompletedProgress = ( lastestGameProgress.matchedPair + Card.isMatchedCardPair(cardPair) == state.cards.size() );
        // update the lastest gameprogress, leave the others the same.
        //// get mutable element array of current gameprogress, and update the lastest gameprogress.
        var newGameProgresses : [ var Types.GameProgress] = Array.thaw(player.gameProgresses);
        newGameProgresses [ newGameProgresses.size() - 1 ] := {
                    startTime =  lastestGameProgress.startTime;
                    chosenSequence = Array.append(lastestGameProgress.chosenSequence,[cardPair]);
                    matchedPair  = lastestGameProgress.matchedPair + Card.isMatchedCardPair(cardPair);
                    score = lastestGameProgress.score + 1 + (if (isCompletedProgress) {timeAmount} else {0}) ;
                };
        let updatePlayer : Types.Player = {
            userid = player.userid;
            isPlaying = not ( isCompletedProgress );
            gameProgresses = Array.freeze(newGameProgresses);
        };
        let updated = update(updatePlayer,state);
    };



};
