import { UserInfo } from './users'
import { util } from '@kit.ArkTS'

export enum MessageTypeEnum {
  TEXT, // 文本
  IMAGE, // 图片
  AUDIO, // 音频
  VIDEO, // 视频
  LOCATION, // 定位
  LINK // 链接
}

export interface MessageInfo {
  id: string, // 标识
  sendUser: UserInfo, // 这条消息的发送者
  sendTime: number, // 发送时间
  sourceFilePath: string, // 音频地址 图片地址 视频地址
  sourceDuration: number // 音频或者视频的长度 单位s
  messageType: MessageTypeEnum, // 0表示发送的消息是一个文本 0文本 1 图片 2 音频 3 视频 4 定位 5 链接
  messageContent: string, // 消息内容  文本消息  [图片] [7"语音]
  connectUser: UserInfo // 这条消息的归属者
}


export class MessageInfoModel implements MessageInfo {
  // 标识
  id: string = ""
  // 这条消息的发送者
  sendUser: UserInfo = {} as UserInfo
  // 发送时间
  sendTime: number = 0
  // 音频地址 图片地址 视频地址
  sourceFilePath: string = ""
  // 音频或者视频的长度 单位s
  sourceDuration: number = 0
  // 0表示发送的消息是一个文本 0文本 1 图片 2 音频 3 视频 4 定位 5 链接
  messageType: MessageTypeEnum = MessageTypeEnum.TEXT
  // 消息内容  文本消息  [图片] [7"语音]
  messageContent: string = ""
  // 这条消息的归属者
  connectUser: UserInfo = {} as UserInfo

  constructor(model: MessageInfo) {
    // util.generateRandomUUID() 生成一个id
    this.id = model.id || util.generateRandomUUID()
    this.sendUser = model.sendUser
    this.connectUser = model.connectUser
    this.messageContent = model.messageContent
    this.sendTime = model.sendTime || Date.now()
    this.messageType = model.messageType || MessageTypeEnum.TEXT
    this.sourceFilePath = model.sourceFilePath
    this.sourceDuration = model.sourceDuration
  }
}
