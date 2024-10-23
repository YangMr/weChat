import { router } from '@kit.ArkUI'
import { MessageInfo, MessageInfoModel } from '../../models/message'
import { currentUser, UserInfo } from '../../models/users'
import BottomInput from './BottomInput'
import Message from './Message'

@Entry
@Component
struct ChatDetail {
  @State
  talker: UserInfo = {} as UserInfo
  // 聊天记录的列表数据
  @State
  messageList: MessageInfoModel[] = [
    new MessageInfoModel({
      id: "1", // 标识
      sendUser: currentUser, // 这条消息的发送者
      sendTime: 1729666240777, // 发送时间
      sourceFilePath: "", // 音频地址 图片地址 视频地址
      sourceDuration: 0, // 音频或者视频的长度 单位s
      messageType: 0, // 0表示发送的消息是一个文本
      messageContent: "hello, 您好",
      connectUser: currentUser // 这条消息的归属者
    }),
    new MessageInfoModel({
      id: "2", // 标识
      sendUser: {
        username: "刘浩",
        avatar: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2Fbb560b27-a0b7-4062-ae40-efe4e5a8a748%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1708069619&t=8605f8477712cf9c5a1159db0cd7dab4",
        user_id: "liu"
      }, // 这条消息的发送者
      sendTime: 1729666240777, // 发送时间
      sourceFilePath: "", // 音频地址 图片地址 视频地址
      sourceDuration: 0, // 音频或者视频的长度 单位s
      messageType: 0, // 0表示发送的消息是一个文本
      messageContent: "您好",
      connectUser: currentUser // 这条消息的归属者
    }),
    new MessageInfoModel({
      id: "3", // 标识
      sendUser: currentUser, // 这条消息的发送者
      sendTime: 1729666240777, // 发送时间
      sourceFilePath: "", // 音频地址 图片地址 视频地址
      sourceDuration: 0, // 音频或者视频的长度 单位s
      messageType: 0, // 0表示发送的消息是一个文本
      messageContent: "你吃饭了吗",
      connectUser: currentUser // 这条消息的归属者
    }),
    new MessageInfoModel({
      id: "4", // 标识
      sendUser: {
        username: "刘浩",
        avatar: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2Fbb560b27-a0b7-4062-ae40-efe4e5a8a748%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1708069619&t=8605f8477712cf9c5a1159db0cd7dab4",
        user_id: "liu"
      }, // 这条消息的发送者
      sendTime: 1729666240777, // 发送时间
      sourceFilePath: "", // 音频地址 图片地址 视频地址
      sourceDuration: 0, // 音频或者视频的长度 单位s
      messageType: 0, // 0表示发送的消息是一个文本
      messageContent: "没有,你请我吗?",
      connectUser: currentUser // 这条消息的归属者
    }),

  ]

  // 发送数据的数据
  sendTextMessage(content: string) {
    // 把输入框输入的数据添加到messageList中
    let message = new MessageInfoModel({
      messageContent: content,
      sendUser: currentUser,
      connectUser: this.talker
    } as MessageInfo)
    this.messageList.push(message)

  }

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
      List({ space: 20 }) {
        ForEach(this.messageList, (item: MessageInfoModel) => {
          ListItem() {
            Message({
              currentMessage: item,
            })
          }
        })
      }
      .padding({
        top: 20,
        bottom: 10
      })
      .width("100%")
      .height("100%")
      .layoutWeight(1)
      .backgroundColor($r("app.color.back_color"))


      // 底部输入框
      BottomInput({
        sendTextMessage: (content: string) => {
          this.sendTextMessage(content)
        }
      })
    }
    .height('100%')
    .width('100%')
  }
}