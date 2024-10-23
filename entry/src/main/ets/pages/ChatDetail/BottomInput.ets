import { promptAction } from '@kit.ArkUI'

@Component
struct BottomInput {
  @State
  showVoice: boolean = false
  // 保存的是输入框输入的内容
  @State
  content: string = ""
  sendTextMessage: (content: string) => void = () => {
  }

  build() {
    Column() {
      Row({ space: 10 }) {
        Image(this.showVoice ? $r("app.media.ic_public_keyboard") : $r("app.media.ic_public_sound"))
          .width(25)
          .height(25)
          .onClick(() => {
            this.showVoice = !this.showVoice
          })


        if (this.showVoice) {
          Button("按住 说话", {
            type: ButtonType.Normal
          })
            .backgroundColor(Color.White)
            .height(35)
            .layoutWeight(1)
            .borderRadius(2)
            .fontColor($r("app.color.text_primary"))
        } else {
          TextInput({ text: $$this.content })
            .layoutWeight(1)
            .height(35)
            .borderRadius(2)
            .backgroundColor(Color.White)
            .id("input")// .focusable(true)// 设置元素是否可以聚焦
              // .defaultFocus(true)// 通过defaultFocus()开启默认聚焦
            .onSubmit(() => {
              if (this.content) {
                // 输入的消息了, 给父组件, 父组件将输入框输入的数据放到messageList
                this.sendTextMessage(this.content)

                this.content = ""

                // 发送完消息之后,输入框可以进行聚焦
                focusControl.requestFocus("input")
              } else {
                promptAction.showToast({
                  message: "内容不能为空"
                })
              }
            })
        }


        Image($r("app.media.ic_public_add_norm"))
          .width(25)
          .height(25)
          .onClick(() => {
            AlertDialog.show({
              message: this.content
            })
          })
      }
      .width("100%")
      .height(60)
      .padding({
        left: 10,
        right: 10
      })
    }
    .backgroundColor($r("app.color.second_back_color"))
  }
}

export default BottomInput