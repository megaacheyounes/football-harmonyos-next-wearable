import { Match } from '../models/Matches';
import Repo from '../Repo';
import { MatchCard } from './components/MatchCard';
import router from '@ohos.router';
import { Competition } from '../models/Comptetitions';
import { DateUtils } from '../DateUtils';
import { MatchStatus } from '../models/MatchStatus';

@Entry
@Component
struct Matches {
  repo: Repo = new Repo()
  @State competition?: Competition = undefined
  @State isLoading: boolean = false
  @State error?: string = undefined
  @State matches: Match[] = []

  onPageShow(): void {
    const competitionString = ((router.getParams() || {}) as Record<string, string>)['competition']
    try {
      if (!!competitionString) {
        this.competition = JSON.parse(competitionString)
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
    this.isLoading = true

    try {

      const matchesResponse = await this.repo.getMatches(
        this.competition?.code,
        DateUtils.getTodayDate(),
        DateUtils.getFutureDate(30)
      )

      this.matches = matchesResponse.matches
    } catch (e) {
      this.error = e.message || e
    }
    this.isLoading = false
  }

  onMatchClicked(match: Match) {
    if (match.status == MatchStatus.TIMED) {
      return;
    }

    router.pushUrl({
      url: 'pages/MatchDetails',
      params: {
        match: JSON.stringify(match)
      }
    })

  }

  build() {
    Stack() {


      Column() {

        Text(this.competition?.name)
          .width("80%")
          .fontSize(10)
          .textAlign(TextAlign.Center)


        if (this.isLoading) {
          LoadingProgress()
            .height(60)
            .width(60)
            .layoutWeight(1)
        } else {
          List() {
            ForEach(this.matches, (item: Match) => {
              ListItem() {
                MatchCard({ match: item })
              }
              .onClick(() => this.onMatchClicked(item))

            }, (item: Competition) => item.id.toString())
            ListItem() {
              Row().height(50)
            }
          }
          .width('100%')
          .alignListItem(ListItemAlign.Center)
        }
      }.height('100%')
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ top: 20, left: 20, right: 20 })

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