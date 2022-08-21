import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Card { 'data' : string }
export type Error = { 'AlreadyExisting' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null };
export interface GameProgress {
  'startTime' : bigint,
  'chosenSequence' : Array<[Card, Card]>,
  'score' : bigint,
  'matchedPair' : bigint,
}
export interface Player {
  'gameProgresses' : Array<GameProgress>,
  'userid' : Principal,
  'isPlaying' : boolean,
}
export type Response = { 'ok' : string } |
  { 'err' : Error };
export type Response_1 = { 'ok' : Array<Player> } |
  { 'err' : Error };
export type Response_2 = { 'ok' : Array<Card> } |
  { 'err' : Error };
export type Response_3 = { 'ok' : boolean } |
  { 'err' : Error };
export interface _SERVICE {
  'checkCardPair' : ActorMethod<[[Card, Card], bigint], Response>,
  'createCard' : ActorMethod<[Card], Response>,
  'deleteCard' : ActorMethod<[Card], Response>,
  'duplicateCards' : ActorMethod<[], Response_2>,
  'isValidGameProgress' : ActorMethod<[Array<[Card, Card]>], Response_3>,
  'listCards' : ActorMethod<[], Response_2>,
  'listPlayers' : ActorMethod<[], Response_1>,
  'updateCard' : ActorMethod<[Card], Response>,
}
