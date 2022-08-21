export const idlFactory = ({ IDL }) => {
  const Card = IDL.Record({ 'data' : IDL.Text });
  const Error = IDL.Variant({
    'AlreadyExisting' : IDL.Null,
    'NotFound' : IDL.Null,
    'NotAuthorized' : IDL.Null,
  });
  const Response = IDL.Variant({ 'ok' : IDL.Text, 'err' : Error });
  const Response_2 = IDL.Variant({ 'ok' : IDL.Vec(Card), 'err' : Error });
  const Response_3 = IDL.Variant({ 'ok' : IDL.Bool, 'err' : Error });
  const GameProgress = IDL.Record({
    'startTime' : IDL.Int,
    'chosenSequence' : IDL.Vec(IDL.Tuple(Card, Card)),
    'score' : IDL.Int,
    'matchedPair' : IDL.Int,
  });
  const Player = IDL.Record({
    'gameProgresses' : IDL.Vec(GameProgress),
    'userid' : IDL.Principal,
    'isPlaying' : IDL.Bool,
  });
  const Response_1 = IDL.Variant({ 'ok' : IDL.Vec(Player), 'err' : Error });
  return IDL.Service({
    'checkCardPair' : IDL.Func(
        [IDL.Tuple(Card, Card), IDL.Int],
        [Response],
        [],
      ),
    'createCard' : IDL.Func([Card], [Response], []),
    'deleteCard' : IDL.Func([Card], [Response], []),
    'duplicateCards' : IDL.Func([], [Response_2], []),
    'isValidGameProgress' : IDL.Func(
        [IDL.Vec(IDL.Tuple(Card, Card))],
        [Response_3],
        ['query'],
      ),
    'listCards' : IDL.Func([], [Response_2], ['query']),
    'listPlayers' : IDL.Func([], [Response_1], ['query']),
    'updateCard' : IDL.Func([Card], [Response], []),
  });
};
export const init = ({ IDL }) => { return []; };
