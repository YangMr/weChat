import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../models/message'
import { PopupItem } from '../../models/popup'
import { currentUser } from '../../models/users'
import { StoreClass } from '../../utils/StoreClass'

@Component
struct message {
  @Prop
  currentMessage: MessageInfoModel = new MessageInfoModel({} as MessageInfo)
  // 控制弹层的显示与隐藏 true 显示 false 隐藏
  @State
  showPopup: boolean = false
  // 弹层菜单的数据
  @State
  popupList: PopupItem[] = [
    {
      title: '听筒播放',
      icon: $r("app.media.ic_public_ears"),

    },
    {
      title: '收藏',
      icon: $r("app.media.ic_public_cube"),

    },
    {
      title: '转文字',
      icon: $r("app.media.ic_public_trans_text"),

    },
    {
      title: '删除',
      icon: $r("app.media.ic_public_cancel"),
      itemClick: async () => {
        // 删除首选项的数据
        await StoreClass.removeChatMessage(this.currentMessage.connectUser.user_id, this.currentMessage.id)
        // 删除UI界面的数据
        this.delMessage(this.currentMessage.id)
      }
    },
    {
      title: '多选',
      icon: $r("app.media.ic_public_multi_select"),
    },
    {
      title: '引用',
      icon: $r("app.media.ic_public_link"),
    },
    {
      title: '提醒',
      icon: $r("app.media.ic_public_warin"),
    }
  ]
  videoController: VideoController = new VideoController()

  // 动态计算语音条的宽度
  getAudioWidth() {
    const min = 20
    const max = 90

    // 100 * 60 == 600 / 60 = 10 + 20 = 30
    const calcWidth = min + (100 * this.currentMessage.sourceDuration / 60)

    return (calcWidth > max ? max : calcWidth) + "%"
  }

  delMessage: (messageId: string) => void = () => {
  }
  openCustomImageDialog: (filePath: string, type?: MessageTypeEnum) => void = () => {
  }

  @Builder
  getContent() {
    GridRow({ columns: 5 }) {
      ForEach(this.popupList, (item: PopupItem) => {
        GridCol() {
          Column({ space: 6 }) {
            Image(item.icon)
              .width(18)
              .aspectRatio(1)
              .fillColor($r("app.color.white"))
            Text(item.title)
              .fontSize(14)
              .fontColor($r("app.color.white"))
          }
          .height(60)
          .onClick(() => {
            item.itemClick && item.itemClick()
          })
        }
      })

    }
    .width(300)
    .padding({
      left: 10,
      top: 15,
      bottom: 10
    })
  }

  build() {
    Row() {
      Image(this.currentMessage.sendUser.avatar)
        .width(40)
        .height(40)
        .borderRadius(6)

      Row() {
        Column() {

          if (this.currentMessage.messageType === MessageTypeEnum.IMAGE) {
            // 6. 渲染发送的图片
            Column() {
              Image("file://" + this.currentMessage.sourceFilePath)
                .width("100%")
                .borderRadius(4)
            }
            .width("40%")
            .margin({
              right: 10,
              left: 10
            })
            .onClick(() => {
              this.openCustomImageDialog(this.currentMessage.sourceFilePath, this.currentMessage.messageType)
            })

          } else if (this.currentMessage.messageType === MessageTypeEnum.VIDEO) {
            Column() {
              Stack() {
                Video({
                  src: "file://" + this.currentMessage.sourceFilePath,
                  controller: this.videoController
                })
                  .controls(false)
                  .width(100)
                  .height(150)
                  .borderRadius(4)
                  .id(this.currentMessage.id)
                  .onPrepared(async () => {
                    await this.videoController.setCurrentTime(1) // 拨到0.1秒
                  })

                Image($r("app.media.ic_public_play"))
                  .width(30)
                  .height(30)
                  .fillColor($r("app.color.back_color"))
                  .onClick(() => {
                    this.openCustomImageDialog(this.currentMessage.sourceFilePath, this.currentMessage.messageType)
                  })
              }
            }
            .margin({
              left: 10,
              right: 10
            })

          } else if (this.currentMessage.messageType === MessageTypeEnum.TEXT) {
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
              .bindPopup(this.showPopup, {
                builder: this.getContent,
                popupColor: $r("app.color.popup_back"),
                backgroundBlurStyle: BlurStyle.NONE,
                onStateChange: (event) => {
                  this.showPopup = event.isVisible
                }
              })
              .gesture(LongPressGesture().onAction(() => {
                // 绑定长按的手势
                this.showPopup = true
              }))
          } else if (this.currentMessage.messageType === MessageTypeEnum.AUDIO) {
            Row({ space: 6 }) {
              Text(this.currentMessage.sourceDuration + "'")
                .textAlign(TextAlign.Center)

              Image($r("app.media.ic_public_recorder"))
                .width(20)
                .height(20)
                .rotate({
                  angle: currentUser.user_id === this.currentMessage.sendUser.user_id ? 180 : 0
                })

            }
            .width(this.getAudioWidth())
            .height(40)
            .padding({
              left: 10,
              right: 10
            })
            .margin({
              right: 10,
              left: 10
            })
            .backgroundColor(currentUser.user_id === this.currentMessage.sendUser.user_id ?
            $r('app.color.chat_primary') :
            $r("app.color.white"))
            .borderRadius(5)
          }


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