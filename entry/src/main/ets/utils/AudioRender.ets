// // 1. 创建音频播放的实例对象
// import { audio } from '@kit.AudioKit';
// import { fileIo } from '@kit.CoreFileKit';
//
// // 2. 进行播放方法
// // 3. 停止播放方法
// // 4. 销毁音频播放的实例对象
//
// export class AudioRender {
//   static audioRender: audio.AudioRenderer | null
//   static audioStreamInfo: audio.AudioStreamInfo = {
//     samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率
//     channels: audio.AudioChannel.CHANNEL_2, // 通道
//     sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
//     encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
//   };
//   static audioRendererInfo: audio.AudioRendererInfo = {
//     usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION,
//     rendererFlags: 0
//   };
//   static audioRendererOptions: audio.AudioRendererOptions = {
//     streamInfo: AudioRender.audioStreamInfo,
//     rendererInfo: AudioRender.audioRendererInfo
//   };
//   static renderFile: fileIo.File | null;
//   static maxSize: number = 0
//   static renderSize: number = 0
//
//   //初始化音频播放的实例对象
//   static async init() {
//     if (!AudioRender.audioRender) {
//
//       AudioRender.audioRender = await audio.createAudioRenderer(AudioRender.audioRendererOptions)
//
//       AudioRender.audioRender.on("writeData", (buffer: ArrayBuffer) => {
//         if (AudioRender.renderFile) {
//           fileIo.readSync(AudioRender.renderFile.fd, buffer, {
//             offset: AudioRender.renderSize,
//             length: buffer.byteLength
//           })
//
//           AudioRender.renderSize += buffer.byteLength;
//
//           if (AudioRender.renderSize >= AudioRender.maxSize) {
//             fileIo.closeSync(AudioRender.renderFile.fd)
//             AudioRender.stop()
//           }
//         }
//
//
//       })
//     }
//   }
//
//   // 开始播放
//   static async start(filePath: string) {
//     if (AudioRender.audioRender && filePath) {
//       // 可能有正在播放的语音，手动结束一次（也可以加个标记，但是没必要）
//       await AudioRender.stop()
//
//
//       //获取播放的文件书数据
//       AudioRender.renderFile = fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY)
//
//
//       // 获取播放的文件的体积大小
//       AudioRender.maxSize = fileIo.statSync(AudioRender.renderFile.fd).size
//
//       // 开始播放
//       await AudioRender.audioRender.start()
//     }
//   }
//
//   // 停止播放
//   static async stop() {
//     if (AudioRender.audioRender && AudioRender.audioRender.state === audio.AudioState.STATE_RUNNING) {
//       await AudioRender.audioRender.stop()
//       AudioRender.renderSize = 0
//       AudioRender.maxSize = 0
//     }
//   }
//
//   // 释放资源
//   static async release() {
//     if (AudioRender.audioRender) {
//       await AudioRender.stop()
//       await AudioRender.audioRender.release()
//       AudioRender.audioRender = null
//       AudioRender.renderFile = null
//     }
//   }
// }

//
import { audio } from '@kit.AudioKit';
import { fileIo } from '@kit.CoreFileKit';

export class AudioRender {
  static audioRender: audio.AudioRenderer | null = null
  static audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000,
    channels: audio.AudioChannel.CHANNEL_2,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW,
  };
  static audioRendererInfo: audio.AudioRendererInfo = {
    usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION,
    rendererFlags: 0,
  };
  static audioRendererOptions: audio.AudioRendererOptions = {
    streamInfo: AudioRender.audioStreamInfo,
    rendererInfo: AudioRender.audioRendererInfo,
  };
  static renderFile: fileIo.File | null = null
  static maxSize: number = 0;
  static renderSize: number = 0;

  // 初始化音频播放的实例对象
  static async init() {
    if (!AudioRender.audioRender) {
      AudioRender.audioRender = await audio.createAudioRenderer(
        AudioRender.audioRendererOptions
      );
      AudioRender.audioRender.on("writeData", (buffer: ArrayBuffer) => {
        if (AudioRender.renderFile) {
          try {
            fileIo.readSync(
              AudioRender.renderFile.fd,
              buffer,
              {
                offset: AudioRender.renderSize,
                length: buffer.byteLength,
              }
            );
            AudioRender.renderSize += buffer.byteLength;
            if (AudioRender.renderSize >= AudioRender.maxSize) {
              fileIo.closeSync(AudioRender.renderFile!.fd);
              AudioRender.stop();
            }
          } catch (error) {
            console.error('Error reading file:', error);
          }

        }


      });
    }
  }

  // 开始播放
  static async start(filePath: string) {
    if (AudioRender.audioRender && filePath) {
      await AudioRender.stop();
      try {
        AudioRender.renderFile = fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY);
        AudioRender.maxSize = fileIo.statSync(AudioRender.renderFile.fd).size;
        await AudioRender.audioRender.start();
      } catch (error) {
        console.error('Error starting playback:', error);
      }
    }
  }

  // 停止播放
  static async stop() {
    if (AudioRender.audioRender && AudioRender.audioRender.state === audio.AudioState.STATE_RUNNING) {
      await AudioRender.audioRender.stop();
      AudioRender.renderSize = 0;
      AudioRender.maxSize = 0;
    }
  }

  // 释放资源
  static async release() {
    if (AudioRender.audioRender) {
      await AudioRender.stop();
      await AudioRender.audioRender.release();
      AudioRender.audioRender = null
      AudioRender.renderFile = null
    }
  }
}