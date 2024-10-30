import { display, promptAction } from '@kit.ArkUI'
import { VoiceRecordEnum } from '../../models/voice'
import VoiceInput from './VoiceInput'

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
  // 记录屏幕整体的宽度
  @State
  screenWidth: number = 0
  // 记录屏幕整体的高度
  screenHeight: number = 0
  // 保存当前的状态
  @Provide
  voiceState: VoiceRecordEnum = VoiceRecordEnum.RecordIng

  // 页面加载的时候获取整个屏幕的宽度与高度
  aboutToAppear(): void {
    // px 转化为 vp
    this.screenWidth = px2vp(display.getDefaultDisplaySync().width)
    this.screenHeight = px2vp(display.getDefaultDisplaySync().height)
  }

  sendTextMessage: (content: string) => void = () => {
  }

  // 1. 获取整个屏幕的宽度与高度
  // 2. 获取当前手指触摸的坐标x - y
  // 3. 手势拖动的时候, 判断当前手指触摸的坐标x - y 是否大于
  // 屏幕高度 -  录音区域的高度
  // 4. 如果大于 屏幕高度 -  录音区域的高度 说明手势拖动录音区域
  // 5. 如果小于 屏幕高度 -  录音区域的高度 说明手势不在拖动录音区域

  // 1. 定义三个状态 0 录音 1 取消 2 语音转文字

  @Builder
  getVoiceCom() {
    Column() {
      VoiceInput()
    }
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
            .fontColor($r("app.color.text_primary"))// 1. 绑定手势
            .gesture(
              // 2. 设置手势类型 - 组合手势
              // 3. 设置组合手势执行的顺序 - 并发执行
              GestureGroup(
                GestureMode.Parallel,
                // 长按手势
                LongPressGesture()
                  .onAction(() => {
                    // 手势开始的时候触发
                    this.showVoiceCom = true
                  })
                  .onActionEnd(() => {
                    // 手势结束的时候触发
                    this.showVoiceCom = false
                  }),
                // 移动手势
                PanGesture()
                  .onActionUpdate((event) => {
                    if (event.fingerList[0].globalY > this.screenHeight - 120) {
                      // 手势触摸到录音区域

                      this.voiceState = VoiceRecordEnum.RecordIng

                    } else {
                      // 手势不在录音区域
               

                      if (event.fingerList[0].globalX > this.screenWidth / 2) {
                        // 右侧
                        this.voiceState = VoiceRecordEnum.Transfer


                      } else {
                        // 左侧
                        this.voiceState = VoiceRecordEnum.Cancel


                      }
                    }
                  })
                  .onActionEnd(() => {
                    this.voiceState = VoiceRecordEnum.RecordIng
                  })
              )
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