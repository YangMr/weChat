import { fileIo } from '@kit.CoreFileKit'

export class FileOperate {
  // 1. 创建音频文件
  static createAudioFile(userId: string) {
    // 1.1 定义存储音频文件的目录的路径
    const dirPath = getContext().filesDir + "/" + userId

    // 1.2 检测路径是否在沙箱目录在
    const flag = fileIo.accessSync(dirPath)

    // 1.3 如果不存在,则创建对应的目录
    if (!flag) {
      // 1.4 创建对应的目录
      fileIo.mkdirSync(dirPath)
    }

    // 1.5 准备文件的路径
    let filePath = dirPath + "/" + Date.now() + ".wav"

    // 1.6 打开音频文件, 如果没有,则自动创建对饮的音频文件
    const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE)

    // 1.7 关闭文件
    fileIo.closeSync(file)

    // 1.8 将文件的路径返回出去
    return filePath
  }

  // 2. 删除音频文件方法
  static delFilePath(filePath: string) {
    if (filePath) {
      fileIo.unlinkSync(filePath)
    }
  }

  // 3. 删除整个目录的音频文件方法
  static delUserPath(userId: string) {
    if (userId) {
      const dirPath = getContext().filesDir + "/" + userId
      const flag = fileIo.accessSync(dirPath)
      if (flag) {
        fileIo.rmdirSync(dirPath)
      }
    }
  }
}