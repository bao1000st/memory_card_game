import Text "mo:base/Text";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";
import Types "types";

module {

    public type State = {
        cards : TrieMap.TrieMap<Text,Types.Card>;
        players : TrieMap.TrieMap<Principal,Types.Player>;
    };

    public func empty() : State {
        {
            cards = TrieMap.TrieMap<Text, Types.Card>(Text.equal, Text.hash);
            players = TrieMap.TrieMap<Principal, Types.Player>(Principal.equal, Principal.hash);
        };
    };
};