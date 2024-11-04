import { Match } from '../models/Matches';
import { PL_DATA } from '../sampleData/PL_DATA.ts';
import Repo from '../Repo';
import { MatchCard } from './components/MatchCard';
import router from '@ohos.router';
import { Competition } from '../models/Comptetitions';
import { MatchDetailsResponse } from '../models/MatchDetailsResponse';

interface Stats {
  name: string,
  homeTeam: number,
  awayTeam: number,
  homeIsHigher: boolean,
  awayIsHigher: boolean
}

@Entry
@Component
struct MatchDetails {
  repo: Repo = new Repo()
  //todo: remove
  @State match?: Match = PL_DATA.matches[0]
  @State matchDetails?: MatchDetailsResponse = undefined
  @State isLoading: boolean = false
  @State error?: string = undefined

  onPageShow(): void {
    const matchString = ((router.getParams() || {}) as Record<string, string>)['match']
    try {
      if (!!matchString) {
        this.match = JSON.parse(matchString)
      }
    } catch (e) {
      console.error("Implementation error:" + e.message || e)
      this.error = "Internal Error, please try again"
    }
    this.fetchData()
  }

  onPageHide(): void {
  }

  async fetchData() {

    if (!this.match) {
      return
    }

    this.isLoading = true

    try {

      const matchResponse = await this.repo.getMatchDetails(
        this.match?.id
      )

      this.matchDetails = matchResponse
    } catch (e) {
      this.error = e.message || e
    }


    this.isLoading = false
  }

  getStatistics(): Stats[] {
    const stats: Stats[] = []
    if (!this.matchDetails) {
      return stats
    }

    const keys = Object.keys(this.matchDetails?.homeTeam.statistics)

    for (let key of keys) {
      const homeTeamValue = this.matchDetails.homeTeam.statistics[key]
      const awayTeamValue = this.matchDetails.awayTeam.statistics[key]
      stats.push({
        name: key.replaceAll("_", " "),
        homeTeam: homeTeamValue,
        homeIsHigher: homeTeamValue > awayTeamValue,
        awayTeam: awayTeamValue,
        awayIsHigher: awayTeamValue > homeTeamValue
      })
    }


    console.log("stats:" + JSON.stringify(stats))
    return stats
  }

  @Builder
  StatisticItem(item: Stats) {


    Column() {
      Row() {

        Text(item.homeTeam.toString())
          .fontSize(12)
          .fontColor(item.homeIsHigher ? "#ff59e334" : "#222222")

        Text(item.name)
          .fontSize(12)
          .textAlign(TextAlign.Center)
          .layoutWeight(1)

        Text(item.awayTeam.toString())
          .fontSize(12)
          .fontColor(item.awayIsHigher ? "#ff59e334" : "#222222")

      }.width("100%")

      Row() {
        Progress({ value: item.homeTeam, total: 100, type: ProgressType.Linear })
          .color(item.homeIsHigher ? "#ff59e334" : "#222222")
          .rotate({ angle: 180 })
          .width("49%")

        Progress({ value: item.awayTeam, total: 100, type: ProgressType.Linear })
          .width("49%")
          .color(item.awayIsHigher ? "#ff59e334" : "#222222")
      }
      .margin({ top: 2 })
      .width("100%")
      .justifyContent(FlexAlign.SpaceBetween)

    }.width("100%")
    .padding({
      left: 10,
      right: 10,
      top: 5,
      bottom: 5
    })
  }

  build() {
    Stack() {
      Column() {
        MatchCard({
          match: this.match
        })

        List() {
          ForEach(this.getStatistics(), (item: Stats) => {
            ListItem() {
              this.StatisticItem(item)
            }
          }, (item: Competition) => item.name)
          ListItem() {
            Row().height(50)
          }
        }
        .width('100%')
        .alignListItem(ListItemAlign.Center)

      }.height('100%')
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ top: 20, left: 20, right: 20 })

      if (this.isLoading) {
        LoadingProgress()
          .height(60)
          .width(60)
          .layoutWeight(1)
      }

      if (!!this.error) {
        Text(this.error)
          .fontSize(12)
          .textAlign(TextAlign.Center)
          .fontColor("#ffdd1919")
          .width("100%")
          .height("100%")
          .backgroundColor("#6d000000")
      }

    }.width("100%")
    .height("100%")
  }
}