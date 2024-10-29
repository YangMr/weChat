import { preferences } from '@kit.ArkData'
import { MessageInfoModel } from '../models/message'
import { DefaultUserList, UserInfo } from '../models/users'
import { emitter } from '@kit.BasicServicesKit'

export class StoreClass {
  static context: Context
  static wechat_key: string = "WECHAT_KEY"

  static init(context: Context) {
    StoreClass.context = context
  }


  // 创建/获取仓库
  static getUserStore(userId: string) {
    // 获取仓库, 获取不到就会创建
    return preferences.getPreferencesSync(StoreClass.context, {
      // 仓库的名称
      name: `${StoreClass.wechat_key}_${userId}`
    })
  }

  // 给某个人的仓库添加一条数据
  static async addChatMessage(userId: string, message: MessageInfoModel) {
    // 获取到创建的仓库
    const store = StoreClass.getUserStore(userId)
    // 给仓库添加数据
    store.putSync(message.id, JSON.stringify(message))
    // 写入到磁盘
    await store.flush()

    // 发布消息
    emitter.emit(StoreClass.wechat_key)
  }


  // 获取某个人的所有数据
  static getChatMessage(userId: string) {
    // 获取指定的仓库仓库
    const store = StoreClass.getUserStore(userId)
    // 获取仓库中的所有数据
    const all = store.getAllSync() as object
    // 根据发送的时间对数据进行排序
    if (all) {
      const list = Object.values(all).map((item: string) => JSON.parse(item) as MessageInfoModel)
      list.sort((a, b) => a.sendTime - b.sendTime)
      return list
    }
    return []
  }

  // 移除某个人的一条数据
  static async removeChatMessage(userId: string) {
    // 获取操作的仓库
    const store = StoreClass.getUserStore(userId)
    // 删除仓库指定的数据
    store.deleteSync(userId)
    // 写入到磁盘
    await store.flush()
  }

  // 移除某个人的所有数据
  static removeChatAllMessages(userId: string) {
    preferences.deletePreferences(StoreClass.context, {
      name: `${StoreClass.wechat_key}_${userId}`
    })
  }

  // 获取所有人的最后一条数据
  static getAllChatLastMessage() {
    const lastList: MessageInfoModel[] = []
    DefaultUserList.forEach((user: UserInfo) => {
      const chatList = StoreClass.getChatMessage(user.user_id)
      if (chatList.length) {
        lastList.push(chatList[chatList.length - 1])
      }
    })
    lastList.sort((a, b) => b.sendTime - a.sendTime)
    return lastList

  }
}

