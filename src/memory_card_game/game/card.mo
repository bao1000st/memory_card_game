import Types "../types";
import State "../state";

module Card {
    public func getData(card : Types.Card) : Types.Card {
        let newCard : Types.Card = {
            data = card.data;
        };
        return newCard;
    };

    public func create(card : Types.Card, state : State.State) {
        state.cards.put(card.data, getData(card));
    };

    public func update(card : Types.Card, state : State.State) {
       let updated = state.cards.replace(card.data, card);
    };

    public func findCard(card : Types.Card, state : State.State) : Bool {
        let rsCard = state.cards.get(card.data);
        if (rsCard != null) return true;
        false;
    };

    public func isMatchedCardPair(cardPair: (Types.Card, Types.Card)) : Int {
        if (cardPair.0 == cardPair.1) return 1;
        0;
    };

    public func findCardPair(cardPair: (Types.Card, Types.Card), sequence : [(Types.Card, Types.Card)] ) : Bool {
        for (pair in sequence.vals())
        {
            if (cardPair == pair)
            {
                return true;
            };
        };
        return false;
    };
};