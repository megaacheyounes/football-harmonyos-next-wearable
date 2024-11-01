import { DateUtils } from '../../DateUtils'
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
  matchDateTime = DateUtils.getDisplayMatchTime(this.match.utcDate)
  public matchFinished: LinearGradient =
    new LinearGradient([{ color: "#65EEC9A3", offset: 0 }, { color: "#65EF629F", offset: 1 }])
  public matchTimed: LinearGradient =
    new LinearGradient([{ color: "#65e26709", offset: 0 }, { color: "#65efbd08", offset: 1 }])

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
  matchTime() {
    Column() {

      Text(this.matchDateTime.time)
        .fontSize(10)
        .textAlign(TextAlign.Center)
        .margin({ top: 3 })
        .width(40)
      Text(this.matchDateTime.timezone)
        .fontSize(6)
        .textAlign(TextAlign.Center)
        .margin({ top: 1 })
        .width(40)
      Text(this.matchDateTime.day)
        .fontSize(9)
        .textAlign(TextAlign.Center)
        .margin({ top: 2 })
        .width(40)
    }

  }

  isFinished() {
    return this.match.status == MatchStatus.FINISHED ||
      this.match.status == MatchStatus.IN_PLAY
  }

  showStatus() {
    return this.match.status != MatchStatus.TIMED
  }

  build() {

    Row() {
      TeamIcon({ team: this.match.homeTeam })
        .width('30%')

      Column() {
        if (this.isFinished()) {
          this.matchScore()
        } else {
          this.matchTime()
        }
        if (this.showStatus()) {
          Text(this.match.status)
            .fontSize(8)
            .padding(2)
            .margin({ top: 5 })
            .backgroundColor("#ff7acb45")
            .fontColor('#fff')
            .borderRadius('10%')
            .textAlign(TextAlign.Center)
        }

      }.width("40%").padding({ left: 5, right: 5 })

      TeamIcon({ team: this.match.awayTeam })
        .width('30%')

    }
    .width("100%")
    .backgroundColor(this.isFinished() ? '#ffacf5ae' : '#eeeeee')
    // .linearGradient(this.isFinished() ? this.matchFinished : this.matchTimed)
    .border({ radius: 10 })
    .padding(10)
    .margin({ top: 10 })
  }
}