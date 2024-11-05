import { media } from '@kit.MediaKit'

export class AvPlayerClass {
  static player: media.AVPlayer
  static context: Context

  // 初始化实例对象

  static async play(src: string) {
    await AvPlayerClass.player.reset()

    const fileDescriptor = AvPlayerClass.context.resourceManager.getRawFdSync(src + ".wav")
    AvPlayerClass.player.fdSrc = fileDescriptor
    // AvPlayerClass.player.url = 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/5.mp3'
  }

  static async init(context: Context) {
    AvPlayerClass.player = await media.createAVPlayer()
    AvPlayerClass.context = context

    AvPlayerClass.player.on('stateChange', (state) => {
      if (state === "initialized") {
        AvPlayerClass.player.prepare()
      } else if (state === "prepared") {
        AvPlayerClass.player.play()
      }
    })
  }
}