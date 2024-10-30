import { promptAction } from '@kit.ArkUI'

@Component
struct BottomInput {
  @State
  showVoice: boolean = false
  // 保存的是输入框输入的内容
  @State
  content: string = ""
  // 控制按钮说话按钮的弹层
  @State
  showVoiceCom: boolean = false
  sendTextMessage: (content: string) => void = () => {
  }

  @Builder
  getVoiceCom() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        //显示关闭和文本
        Row() {
          Row() {
            Image($r("app.media.ic_public_cancel"))
              .width(30)
              .height(30)
              .fillColor($r("app.color.voice_round_font_color"))
          }
          .width(70)
          .aspectRatio(1)
          .borderRadius(35)
          .justifyContent(FlexAlign.Center)
          .backgroundColor($r("app.color.voice_round_color"))
          .rotate({
            angle: -10
          })

          Row() {
            Text("文")
              .fontSize(24)
              .textAlign(TextAlign.Center)
              .fontColor($r("app.color.voice_round_font_color"))
          }
          .width(70)
          .aspectRatio(1)
          .borderRadius(35)
          .justifyContent(FlexAlign.Center)
          .backgroundColor($r("app.color.voice_round_color"))
          .rotate({
            angle: 10
          })

        }
        .width("100%")
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          left: 40,
          right: 40
        })
        .margin({
          bottom: 30
        })

        Stack() {
          Image($r("app.media.ic_public_output"))
            .width("100%")
            .height(120)
            .fillColor($r("app.color.bottom_color"))
            .scale({
              x: 1.2
            })
          Image($r("app.media.ic_public_recorder"))
            .width(30)
            .height(30)
            .fillColor($r("app.color.bottom_voice_color"))

        }
        .width("100%")
      }

    }
    .width("100%")
    .height("100%")
    .backgroundColor($r("app.color.voice_back_color"))

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
            .gesture(LongPressGesture()
              .onAction(() => {
                // 手势开始的时候触发
                this.showVoiceCom = true
              })
              .onActionEnd(() => {
                // 手势结束的时候触发
                this.showVoiceCom = false
              })
            )
            .bindContentCover(this.showVoiceCom, this.getVoiceCom, {
              modalTransition: ModalTransition.NONE
            })
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