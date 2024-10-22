import { router } from '@kit.ArkUI'
import { UserInfo } from '../../models/users'

@Entry
@Component
struct ChatDetail {
  @State
  talker: UserInfo = {} as UserInfo

  aboutToAppear(): void {
    this.talker = router.getParams() as UserInfo
  }

  build() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.Start }) {
          Text(this.talker.username)
            .width("100%")
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontColor($r("app.color.text_primary"))

          Image($r("app.media.ic_public_arrow_left"))
            .width(30)
            .height(30)
            .onClick(() => {
              router.back()
            })
        }
      }
      .height(50)
    }
    .height('100%')
    .width('100%')
  }
}