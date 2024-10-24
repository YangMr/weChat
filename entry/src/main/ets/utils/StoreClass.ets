import { preferences } from '@kit.ArkData'
import { MessageInfoModel } from '../models/message'

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
  }


  // 获取某个人的所有数据

  // 移除某个人的一条数据

  // 移除某个人的所有数据

  // 获取所有人的最后一条数据
}

