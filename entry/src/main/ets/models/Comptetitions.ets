export interface Competitions {
  count: number,
  filters: Filters
  competitions: Competition[]
}


export interface Filters {
  client: string
}

export interface Competition {
  id: number
  name: string
  code: string
  type: string
  emblem: string
  area?: Area
  plan?: string
  currentSeason?: CurrentSeason
  numberOfAvailableSeasons?: number
  lastUpdated?: string
}

export interface Area {
  id: number
  name: string
  code: string
  flag?: string
}

export interface CurrentSeason {
  id: number
  startDate: string
  endDate: string
  currentMatchday: number
  winner?: Winner
}

export interface Winner {
  id: number
  name: string
  shortName: string
  tla: string
  crest: string
  address: string
  website: string
  founded: number
  clubColors: string
  venue?: string
  lastUpdated: string
}
