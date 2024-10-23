import { MessageInfo, MessageInfoModel } from '../../models/message'
import { currentUser } from '../../models/users'

@Component
struct message {
  @Prop
  currentMessage: MessageInfoModel = new MessageInfoModel({} as MessageInfo)

  build() {
    Row() {
      Image(this.currentMessage.sendUser.avatar)
        .width(40)
        .height(40)
        .borderRadius(6)

      Row() {
        Column() {
          Text(this.currentMessage.messageContent)
            .backgroundColor(currentUser.user_id === this.currentMessage.sendUser.user_id ?
            $r("app.color.second_primary") : $r("app.color.white"))
            .fontColor($r("app.color.text_primary"))
            .padding(10)
            .margin({
              left: 10,
              right: 10
            })
            .borderRadius(5)
        }
      }
      .layoutWeight(6)
      .justifyContent(currentUser.user_id === this.currentMessage.sendUser.user_id ? FlexAlign.End : FlexAlign.Start)

      Text()
        .layoutWeight(1)

    }
    .direction(currentUser.user_id === this.currentMessage.sendUser.user_id ? Direction.Rtl : Direction.Ltr)
    .alignItems(VerticalAlign.Top)
    .padding({
      left: 20,
      right: 20
    })
    .width("100%")

  }
}

export default message