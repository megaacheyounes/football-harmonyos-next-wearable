import { Team, Match } from '../../models/Matches'
import { MatchStatus } from '../../models/MatchStatus'

@Component
struct TeamIcon {
  @Prop team: Team

  build() {
    Column() {
      Image(this.team.crest)
        .objectFit(ImageFit.Contain)
        .width("40%")

      Text(this.team.shortName)
        .fontSize(8)
        .width("90%")
        .textAlign(TextAlign.Center)
        .margin({ top: 3 })

    }
  }
}

@Component
export struct MatchCard {
  @Prop match: Match

  @Builder
  matchScore() {
    Row() {
      Text(this.match.score.fullTime.home?.toString())
        .fontSize(14)
        .textAlign(TextAlign.Center)
        .margin({ top: 3 })

      Text("|").margin({ left: 10, right: 10 })

      Text(this.match.score.fullTime.away?.toString())
        .fontSize(14)
        .textAlign(TextAlign.Center)
        .margin({ top: 3 })
    }
  }

  @Builder
  matchTime(){

    Text(this.match.score.fullTime.away?.toString())
      .fontSize(14)
      .textAlign(TextAlign.Center)
      .margin({ top: 3 })
  }

  build() {

    Row() {

      TeamIcon({ team: this.match.homeTeam })
        .width('30%')

      Column() {

        if (this.match.status == MatchStatus.FINISHED.toString() ||
          this.match.status == MatchStatus.IN_PLAY.toString()) {
          this.matchScore()
        } else
          this.matchTime()

        Text(this.match.status)
          .fontSize(8)
          .padding(2)
          .margin({ top: 5 })
          .backgroundColor("#ff868686")
          .fontColor('#fff')
          .borderRadius('10%')
          .textAlign(TextAlign.Center)

      }.width("40%").padding({ left: 5, right: 5 })

      TeamIcon({ team: this.match.awayTeam })
        .width('30%')

    }
    .width("100%")
    .backgroundColor("#eeeeee")
    .border({ radius: 10 })
    .padding(10)
    .margin({ top: 10 })
  }
}