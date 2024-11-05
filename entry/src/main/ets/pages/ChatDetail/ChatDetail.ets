import { router } from '@kit.ArkUI'
import { getMessageInfo } from '../../api'
import { MessageInfo, MessageInfoModel, MessageTypeEnum } from '../../models/message'
import { currentUser, UserInfo } from '../../models/users'
import { StoreClass } from '../../utils/StoreClass'
import BottomInput from './BottomInput'
import Message from './Message'
import { emitter } from '@kit.BasicServicesKit'

@Entry
@Component
struct ChatDetail {
  @State
  talker: UserInfo = {} as UserInfo
  // 聊天记录的列表数据
  @State
  messageList: MessageInfoModel[] = [
  // new MessageInfoModel({
  //   id: "1", // 标识
  //   sendUser: currentUser, // 这条消息的发送者
  //   sendTime: 1729666240777, // 发送时间
  //   sourceFilePath: "", // 音频地址 图片地址 视频地址
  //   sourceDuration: 0, // 音频或者视频的长度 单位s
  //   messageType: 0, // 0表示发送的消息是一个文本
  //   messageContent: "hello, 您好",
  //   connectUser: currentUser // 这条消息的归属者
  // }),
  // new MessageInfoModel({
  //   id: "2", // 标识
  //   sendUser: {
  //     username: "刘浩",
  //     avatar: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2Fbb560b27-a0b7-4062-ae40-efe4e5a8a748%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1708069619&t=8605f8477712cf9c5a1159db0cd7dab4",
  //     user_id: "liu"
  //   }, // 这条消息的发送者
  //   sendTime: 1729666240777, // 发送时间
  //   sourceFilePath: "", // 音频地址 图片地址 视频地址
  //   sourceDuration: 0, // 音频或者视频的长度 单位s
  //   messageType: 0, // 0表示发送的消息是一个文本
  //   messageContent: "您好",
  //   connectUser: currentUser // 这条消息的归属者
  // }),
  // new MessageInfoModel({
  //   id: "3", // 标识
  //   sendUser: currentUser, // 这条消息的发送者
  //   sendTime: 1729666240777, // 发送时间
  //   sourceFilePath: "", // 音频地址 图片地址 视频地址
  //   sourceDuration: 0, // 音频或者视频的长度 单位s
  //   messageType: 0, // 0表示发送的消息是一个文本
  //   messageContent: "你吃饭了吗",
  //   connectUser: currentUser // 这条消息的归属者
  // }),
  // new MessageInfoModel({
  //   id: "4", // 标识
  //   sendUser: {
  //     username: "刘浩",
  //     avatar: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2Fbb560b27-a0b7-4062-ae40-efe4e5a8a748%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1708069619&t=8605f8477712cf9c5a1159db0cd7dab4",
  //     user_id: "liu"
  //   }, // 这条消息的发送者
  //   sendTime: 1729666240777, // 发送时间
  //   sourceFilePath: "", // 音频地址 图片地址 视频地址
  //   sourceDuration: 0, // 音频或者视频的长度 单位s
  //   messageType: 0, // 0表示发送的消息是一个文本
  //   messageContent: "没有,你请我吗?",
  //   connectUser: currentUser // 这条消息的归属者
  // }),
  ]
  // 滚动条控件
  scroller: Scroller = new Scroller()
  // 是否是正在输入的状态 false 已完成状态 true正在输入的状态
  @State
  talkerInputIng: boolean = false
  // 定义弹窗的构造器
  dialogController: CustomDialogController = new CustomDialogController({
    builder: this.CustomImageDialog,
    customStyle: true,
    autoCancel: false
  })
  @State
  previewUrl: string = ""
  @State
  previewType: MessageTypeEnum = MessageTypeEnum.TEXT

  // 打开弹窗的方法
  openCustomImageDialog(filePath: string, type?: MessageTypeEnum) {
    this.previewUrl = filePath;


    if (type) {
      this.previewType = type;
    }

    this.dialogController.open()
  }

  // 发送文本数据的方法
  sendTextMessage(content: string) {
    // 把输入框输入的数据添加到messageList中
    let message = new MessageInfoModel({
      messageContent: content,
      sendUser: currentUser,
      connectUser: this.talker
    } as MessageInfo)
    this.messageList.push(message)

    this.getResponseMessage(content)

    // 添加数据
    StoreClass.addChatMessage(this.talker.user_id, message)


    this.scroller.scrollEdge(Edge.Bottom)
  }

  // 定义机器人回复的方法
  async getResponseMessage(content: string) {
    this.talkerInputIng = true
    try {
      const res = await getMessageInfo(content)

      let message = new MessageInfoModel({
        messageContent: res?.info?.text,
        sendUser: this.talker,
        connectUser: this.talker
      } as MessageInfo)

      this.messageList.push(message)

      this.scroller.scrollEdge(Edge.Bottom)

      this.talkerInputIng = false

      // 添加数据
      StoreClass.addChatMessage(this.talker.user_id, message)
    } catch (e) {
      console.log(e)
    }
  }

  // 发送图片数据的方法
  sendImageMessage(filePath: string) {
    // 把输入框输入的数据添加到messageList中
    let message = new MessageInfoModel({
      messageContent: '[图片]',
      sendUser: currentUser,
      connectUser: this.talker,
      sourceFilePath: filePath,
      messageType: MessageTypeEnum.IMAGE
    } as MessageInfo)
    this.messageList.push(message)

    // 添加数据
    StoreClass.addChatMessage(this.talker.user_id, message)

    this.getResponseMessage("file://" + filePath)

    this.scroller.scrollEdge(Edge.Bottom)
  }

  // 发送视频的方法
  sendVideoMessage(filePath: string) {
    // 把输入框输入的数据添加到messageList中
    let message = new MessageInfoModel({
      messageContent: '[视频]',
      sendUser: currentUser,
      connectUser: this.talker,
      sourceFilePath: filePath,
      messageType: MessageTypeEnum.VIDEO
    } as MessageInfo)
    this.messageList.push(message)

    // 添加数据
    StoreClass.addChatMessage(this.talker.user_id, message)
    this.scroller.scrollEdge(Edge.Bottom)
  }

  // 发送语音的数据
  sendAudioMessage(filePath: string, duration: number) {
    // 把输入框输入的数据添加到messageList中
    let message = new MessageInfoModel({
      messageContent: '[语音]',
      sendUser: currentUser,
      connectUser: this.talker,
      sourceFilePath: filePath,
      messageType: MessageTypeEnum.AUDIO,
      sourceDuration: duration
    } as MessageInfo)
    this.messageList.push(message)

    
    // 添加数据
    StoreClass.addChatMessage(this.talker.user_id, message)
    this.scroller.scrollEdge(Edge.Bottom)
  }

  @Builder
  CustomImageDialog() {
    Column() {
      if (this.previewType === MessageTypeEnum.VIDEO) {
        Video({
          src: "file://" + this.previewUrl
        })
          .loop(true)
          .autoPlay(true)
          .controls(false)
          .width("100%")
          .height("100%")
      } else if (this.previewType === MessageTypeEnum.IMAGE) {
        Image("file://" + this.previewUrl)
          .width("100%")
          .height("100%")
      }
    }
    .width("100%")
    .height("100%")
    .onClick(() => {
      this.dialogController.close()
    })
  }

  aboutToAppear(): void {
    // 接受其他通过路由页面传递过来的参数
    this.talker = router.getParams() as UserInfo

    // 获取存储在首选项当中的某个人(当前传入的用户id)的数据
    this.messageList = StoreClass.getChatMessage(this.talker.user_id)
  }

  // 删除UI界面数据的方法
  delMessage(id: string) {
    const index = this.messageList.findIndex((item: MessageInfoModel) => item.id === id)
    this.messageList.splice(index, 1)
    emitter.emit(StoreClass.wechat_key)
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Stack({ alignContent: Alignment.Start }) {
          Text(this.talkerInputIng ? "对方正在输入中" : this.talker.username)
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
      List({ space: 20, scroller: this.scroller }) {
        ForEach(this.messageList, (item: MessageInfoModel) => {
          ListItem() {
            //
            Message({
              currentMessage: item,
              delMessage: (id: string) => {
                this.delMessage(id)
              },
              openCustomImageDialog: (filePath: string, type?: MessageTypeEnum) => {
                this.openCustomImageDialog(filePath, type)
              }
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
        },
        sendImageMessage: (filePath: string) => {
          this.sendImageMessage(filePath)
        },
        sendVideoMessage: (filePath: string) => {
          this.sendVideoMessage(filePath)
        },
        sendAudioMessage: (filePath: string, duration: number) => {
          this.sendAudioMessage(filePath, duration)
        },
        talker: this.talker
      })
    }
    .height('100%')
    .width('100%')
  }
}