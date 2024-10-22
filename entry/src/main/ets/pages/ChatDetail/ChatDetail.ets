import { router } from '@kit.ArkUI'
import { UserInfo } from '../../models/users'
import BottomInput from './BottomInput'

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
      // 标题栏
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

      // 聊天内容区
      Blank()

      // 底部输入框
      BottomInput()
    }
    .height('100%')
    .width('100%')
  }
}