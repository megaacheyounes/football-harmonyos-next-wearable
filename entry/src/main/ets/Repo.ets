import http from '@ohos.net.http';
import { Competitions } from './models/Comptetitions';
import { ApiErrorResponse } from './models/ApiErrorResponse';
import { Matches } from './models/Matches';
import { COMPETITION_SAMPLE_DATA } from './COMPTETITIONS_DATA';


export default class Repo {
  /**
   * TODO: get your api key from here: https://www.football-data.org/
   */
  API_KEY = "Xae80a02f254946a8b2af6be56cf63649"
  BASE_URL = "https://api.football-data.org/v4/"

  async getCompetitions(includeOnlyTierOne: boolean = true): Promise<Competitions> {
    return COMPETITION_SAMPLE_DATA
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

    const url = `${this.BASE_URL}competitions/${competitionId}/matches?dateFrom=${startDate}&dateTo=${endDate}`

    const jsonResp = await this.fetch(url)

    const matchesResponse = JSON.parse(jsonResp) as Matches

    return matchesResponse
  }


  private async fetch(url: string): Promise<string> {

    console.log('>>>> ' + url)
    const response = await http.createHttp()
      .request(url, {
        header: {
          "User-Agent": "PostmanRuntime/7.42.0"
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