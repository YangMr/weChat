import { VoiceRecordEnum } from '../../models/voice'

@Component
struct VoiceInput {
  @Consume
  voiceState: VoiceRecordEnum

  @Builder
  getDisplayContent() {
    if (this.voiceState === VoiceRecordEnum.Cancel) {
      Row() {
      }
      .width(100)
      .height(80)
      .backgroundColor($r("app.color.danger"))
      .borderRadius(20)
      .margin({
        left: 20
      })
    }

    if (this.voiceState === VoiceRecordEnum.RecordIng) {
      Row() {
      }
      .width(180)
      .height(80)
      .backgroundColor($r("app.color.chat_primary"))
      .borderRadius(20)
    }

    if (this.voiceState === VoiceRecordEnum.Transfer) {
      Row() {
      }
      .width(280)
      .height(180)
      .backgroundColor($r("app.color.chat_primary"))
      .borderRadius(20)
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Column() {
          this.getDisplayContent()
        }.width("100%")
        .height(400)
        .justifyContent(FlexAlign.Center)
        .alignItems(this.voiceState === VoiceRecordEnum.Cancel ? HorizontalAlign.Start : HorizontalAlign.Center)


        //显示关闭和文本
        Row() {
          Row() {
            // 当手势进入到左侧区域的时候, 颜色变成绿色 , 离开的时候, 又恢复到原来的颜色
            Image($r("app.media.ic_public_cancel"))
              .width(30)
              .height(30)
              .fillColor($r("app.color.voice_round_font_color"))
          }
          .width(70)
          .aspectRatio(1)
          .borderRadius(35)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(this.voiceState === VoiceRecordEnum.Cancel ? "green" : $r("app.color.voice_round_color"))
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
          // 当手势进入到右侧区域的时候, 颜色变成粉色 , 离开的时候, 又恢复到原来的颜色
          .backgroundColor(this.voiceState === VoiceRecordEnum.Transfer ? Color.Blue :
          $r("app.color.voice_round_color"))
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
          // 当手势进入到录音区域的时候, 颜色变成红色 , 离开的时候, 又恢复到原来的颜色
          Image($r("app.media.ic_public_output"))
            .width("100%")
            .height(120)
            .fillColor(this.voiceState === VoiceRecordEnum.RecordIng ? $r("app.color.bottom_color") :
            $r("app.color.voice_round_color"))
            .scale({
              x: 1.2
            })
          Image($r("app.media.ic_public_recorder"))
            .width(30)
            .height(30)
            .fillColor(this.voiceState === VoiceRecordEnum.RecordIng ? $r("app.color.bottom_voice_color") :
            $r("app.color.bottom_color"))

        }
        .width("100%")
      }

    }
    .width("100%")
    .height("100%")
    .backgroundColor($r("app.color.voice_back_color"))
  }
}

export default VoiceInput