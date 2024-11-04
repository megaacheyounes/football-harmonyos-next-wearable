export interface MatchDetailsResponse {
  area: Area;
  competition: Competition;
  season: Season;
  id: number;
  utcDate: string;
  status: string;
  minute: number;
  injuryTime: number;
  attendance: number;
  venue: string;
  matchday: number;
  stage: string;
  group: null;
  lastUpdated: string;
  homeTeam: Team;
  awayTeam: Team;
  score: Score;
  goals: Goal[];
  penalties: Penalty[];
  bookings: Booking[];
  substitutions: Substitution[];
  odds: Odds;
  referees: Coach[];
}

export interface Area {
  id: number;
  name: string;
  code: string;
  flag: string;
}

export interface Team {
  id: number;
  name: string;
  shortName: string;
  tla: string;
  crest: string;
  coach: Coach;
  leagueRank: null;
  formation: string;
  lineup: Bench[];
  bench: Bench[];
  statistics: Record<string, number>;
}

export interface Bench {
  id: number;
  name: string;
  position: null | string;
  shirtNumber: number;
}

export interface Coach {
  id: number;
  name: string;
  nationality: null | string;
  type?: string;
}

export interface Booking {
  minute: number;
  team: Player;
  player: Player;
  card: string;
}

export interface Player {
  id: number | null;
  name: null | string;
}

export interface Competition {
  id: number;
  name: string;
  code: string;
  type: string;
  emblem: string;
}

export interface Goal {
  minute: number;
  injuryTime: null;
  type: string;
  team: Player;
  scorer: Player;
  assist: Player | null;
  score: FullTime;
}

export interface FullTime {
  home: number;
  away: number;
}

export interface Odds {
  homeWin: number;
  draw: number;
  awayWin: number;
}

export interface Penalty {
  player: Player;
  team: Player;
  scored: boolean;
}

export interface Score {
  winner: string;
  duration: string;
  fullTime: FullTime;
  halfTime: FullTime;
}

export interface Season {
  id: number;
  startDate: string;
  endDate: string;
  currentMatchday: number;
  winner: null;
  stages: string[];
}

export interface Substitution {
  minute: number;
  team: Player;
  playerOut: Player;
  playerIn: Player;
}
