import router from '@ohos.router';
import Repo from '../Repo';
import { Competition } from '../models/Comptetitions';


@Entry
@Component
struct Index {
  repo: Repo = new Repo()
  @State isLoading: boolean = true
  @State error?: string = undefined
  @State competitions: Competition[] = []
  @State competitionsCount: number = 0

  onDidBuild(): void {
    console.log("did built")
  }

  onPageShow(): void {

  }

  onPageHide(): void {

  }

  async fetchData() {
    this.isLoading = true
    try {
      const competitionResponse = await this.repo.getCompetitions()
      this.competitions = competitionResponse.competitions
      this.competitionsCount = competitionResponse.count
    } catch (e) {
      this.error = e.message || e
    }
    this.isLoading = false
  }

  onLeagueClicked(competition: Competition): void {
    router.pushUrl({
      url: 'pages/Matches',
      params: {
        competition: JSON.stringify(competition)
      }
    })
  }

  build() {
    Stack() {
      Column() {

        Text(`Competitions: (${this.competitionsCount})`)
          .fontSize(14)
          .margin({ bottom: 10 })


        Refresh({ refreshing: $$this.isLoading }) {
          List() {
            ForEach(this.competitions, (item: Competition) => {
              ListItem() {
                Row() {
                  Image(item.emblem)
                    .alt($r("app.media.image_placeholder"))
                    .objectFit(ImageFit.Contain)
                    .width("15%")
                    .margin({ right: 5 })

                  Text(item.name)
                    .width("70%")
                    .fontSize(10)

                  Image($r("app.media.chevron_right"))
                    .width("10%")
                    .height(30)
                    .margin({ right: 20 })
                }
                .width("100%")
                .backgroundColor("#eeeeee")
                .border({ radius: 10 })
                .padding(10)
                .margin({ top: 10 })
                .onClick(() => this.onLeagueClicked(item))
              }
            }, (item: Competition) => item.id.toString())
            ListItem() {
              Row().height(50)
            }
          }
          .width('100%')
          .alignListItem(ListItemAlign.Center)
        }.onRefreshing(() => this.fetchData())

      }.height('100%')
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding(20)


      if (!!this.error) {
        Text(this.error)
          .fontSize(12)
          .textAlign(TextAlign.Center)
          .fontColor("#ffdd1919")
          .width("100%")
          .height("100%")
          .backgroundColor("#6d000000")
          .onClick(() => this.fetchData())
      }

    }.width("100%")
    .height("100%")
  }
}