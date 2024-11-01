import http from '@ohos.net.http';
import { Competitions } from './models/Comptetitions';
import { ApiErrorResponse } from './models/ApiErrorResponse';
import { Matches } from './models/Matches';
import { COMPETITION_SAMPLE_DATA } from './COMPTETITIONS_DATA';
import { PL_DATA } from './PL_DATA.ts';
import { MATCH_DATA } from './MATCH_DATA';
import { MatchDetailsResponse } from './models/MatchDetailsResponse';


export default class Repo {
  /**
   * TODO: get your api key from here: https://www.football-data.org/
   */
  API_KEY = "ae80a02f254946a8b2af6be56cf63649"
  BASE_URL = "https://api.football-data.org/v4/"
  //use sample data while developing to avoid rate limit of free tier (100 calls / day)
  USE_SAMPLE_DATA = true

  async getCompetitions(includeOnlyTierOne: boolean = true): Promise<Competitions> {
    if (this.USE_SAMPLE_DATA) {
      return COMPETITION_SAMPLE_DATA
    }

    const url = `${this.BASE_URL}competitions?areas=2077`

    const jsonResp = await this.fetch(url)

    const competitionsResponse = JSON.parse(jsonResp) as Competitions
    if (includeOnlyTierOne) {
      competitionsResponse.competitions =
        competitionsResponse.competitions.filter(competition => competition.plan == 'TIER_ONE')
      competitionsResponse.count = competitionsResponse.competitions.length
    }

    return competitionsResponse
  }

  async getMatches(
    competitionId: string = 'PL',
    startDate: string = '2024-10-30',
    endDate: string = '2024-11-05'): Promise<Matches> {
    if (this.USE_SAMPLE_DATA) {
      return PL_DATA
    }

    const url = `${this.BASE_URL}competitions/${competitionId}/matches?dateFrom=${startDate}&dateTo=${endDate}`

    const jsonResp = await this.fetch(url)

    const matchesResponse = JSON.parse(jsonResp) as Matches

    return matchesResponse
  }


  async getMatchDetails(matchId: number): Promise<MatchDetailsResponse> {
    if (this.USE_SAMPLE_DATA) {
      return MATCH_DATA
    }

    const url = `${this.BASE_URL}matches/${matchId}`

    const jsonResp = await this.fetch(url)

    const matchDetailsResponse = JSON.parse(jsonResp) as MatchDetailsResponse

    return matchDetailsResponse
  }


  /******* internal ************/

  private async fetch(url: string): Promise<string> {

    console.log('>>>> ' + url)
    const response = await http.createHttp()
      .request(url, {
        header: {
          'X-Auth-Token': this.API_KEY
        }
      })
    console.log(" <<<< " + response.responseCode + " : " + response.result)
    if (response.responseCode != 200) {
      if (typeof response.result == 'string') {
        const errorResponse = JSON.parse(response.result as string) as ApiErrorResponse
        if (!!errorResponse && !!errorResponse.message) {
          throw new Error(errorResponse.message + `(${response.responseCode})`)
        }
      }
      throw Error(`Fetch failed (${response.responseCode})`)
    }

    return response.result as string
  }
}