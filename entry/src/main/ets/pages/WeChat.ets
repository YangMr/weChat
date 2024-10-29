import { MessageInfoModel } from '../models/message'
import { StoreClass } from '../utils/StoreClass'
import { formatTime } from '../utils/Util'
import { emitter } from '@kit.BasicServicesKit'
import { router } from '@kit.ArkUI'


@Component
struct WeChat {
  @State
  list: MessageInfoModel[] = []

  aboutToAppear(): void {
    this.list = StoreClass.getAllChatLastMessage()

    // 订阅
    emitter.on(StoreClass.wechat_key, () => {
      this.list = StoreClass.getAllChatLastMessage()
    })
  }

  // 格式化时间 -> 基础版业务
  // 不是今年：2023-11-11
  // 今年：11-11
  // 这个月：12天前
  // 这1周：星期五
  // 当天：20:52
  // 这1小时内：50分钟前
  // 这1分钟内:刚刚

  // monent.js
  // dayjs
  transTime(time: number) {
    // 把时间戳转化utc时间
    const dateObj = new Date(time)
    // 获取年
    const year = dateObj.getFullYear()
    // 获取月
    const month = dateObj.getMonth() // 0 - 11
    // 获取日
    const date = dateObj.getDate()
    // 获取时
    const hours = dateObj.getHours()
    // 获取分
    const minutes = dateObj.getMinutes()
    // 是不是今年发送的
    if (year === new Date().getFullYear()) {
      // 是不是这个月发送的
      if (month === new Date().getMonth()) {
        // 是不是今天发送的
        if (date === new Date().getDate()) {
          return hours.toString().padStart(2, "0") + ":" + minutes.toString().padStart(2, "0")
        } else {
          return `${new Date().getDate() - date}天前`
        }
      } else {
        return `${month}月${date}日` + ""
      }
    } else {
      return `${year}年${month}月${date}日` + ""
    }

  }

  build() {
    Column() {
      List() {
        ForEach(this.list, (item: MessageInfoModel) => {
          ListItem() {
            Row({ space: 10 }) {
              Image(item.connectUser.avatar)
                .width(50)
                .height(50)
                .borderRadius(5)

              Column({ space: 10 }) {
                Row() {
                  Text(item.connectUser.username)
                    .fontSize(16)
                    .fontColor($r("app.color.text_primary"))

                  Text(formatTime(item.sendTime))
                    .fontSize(12)
                    .fontColor($r("app.color.text_primary"))
                    .margin({ top: 10 })
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width("100%")

                Text(item.messageContent)
                  .maxLines(1)
                  .fontSize(14)
                  .fontColor($r("app.color.text_second"))
              }
              .layoutWeight(1)
              .height(50)
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                top: 3,
                bottom: 3
              })
            }
            .onClick(() => {
              router.pushUrl({
                url: "pages/ChatDetail/ChatDetail",
                params: item.connectUser
              })
            })
          }
          .padding({
            top: 10,
            bottom: 10
          })
          .stateStyles({
            normal: {
              .backgroundColor($r("app.color.white"))
            },
            pressed: {
              .backgroundColor($r("app.color.back_color"))
            }
          })
        })

      }
      .width("100%")
      .height("100%")
      .layoutWeight(1)
      .divider({
        strokeWidth: 1,
        color: $r("app.color.border_color")
      })
      .padding({
        left: 10,
        right: 10
      })
    }
    .width("100%")
    .height("100%")
    .backgroundColor("#fff")
  }
}

export default WeChat