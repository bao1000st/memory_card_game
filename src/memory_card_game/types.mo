module {
    public type Card = {
        data : Text;
    };

    public type Player = {
        userid : Principal;
        isPlaying : Bool;
        gameProgresses : [GameProgress];
    };

    public type  GameProgress = {
        startTime : Int;
        chosenSequence : [(Card,Card)];
        matchedPair : Int;
        score : Int;
    };

    public type Error = {
        #NotAuthorized;
        #AlreadyExisting;
        #NotFound;
    };
};