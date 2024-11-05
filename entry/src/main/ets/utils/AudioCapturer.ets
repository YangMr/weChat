import { audio } from '@kit.AudioKit';
import { fileIo } from '@kit.CoreFileKit';

class Options {
  offset?: number;
  length?: number;
}

export default class AudioCapture {
  static audioCapturer: audio.AudioCapturer
  static audioStreamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000, // 采样率
    channels: audio.AudioChannel.CHANNEL_2, // 通道
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, // 采样格式
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW // 编码格式
  };
  static audioCapturerInfo: audio.AudioCapturerInfo = {
    source: audio.SourceType.SOURCE_TYPE_MIC,
    capturerFlags: 0
  };
  static audioCapturerOptions: audio.AudioCapturerOptions = {
    streamInfo: AudioCapture.audioStreamInfo,
    capturerInfo: AudioCapture.audioCapturerInfo
  };
  // 录制的状态 false 未录制 true录制中
  static recordIng: boolean = false

  // 初始化音频控制器方法
  static async init() {
    AudioCapture.audioCapturer = await audio.createAudioCapturer(AudioCapture.audioCapturerOptions)
  }

  // 开始录音的方法
  static async start(filePath: string) {
    try {
      if (!AudioCapture.audioCapturer) {
        return
      }

      // 把录制的音频数据,存储到创建的音频文件中
      let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
      let fd = file.fd
      let bufferSize: number = fileIo.statSync(fd).size


      // 录音的状态
      AudioCapture.recordIng = true

      //监听录音器读到的数据，不断写入文件中
      // 开始录音
      await AudioCapture.audioCapturer.start()

      while (AudioCapture.recordIng) {
        let size = await AudioCapture.audioCapturer.getBufferSize()
        let buffer = await AudioCapture.audioCapturer.read(size, true)

        if (buffer) {
          let options: Options = {
            offset: bufferSize,
            length: buffer.byteLength
          }
          fileIo.writeSync(file.fd, buffer, options);
          bufferSize += buffer.byteLength;
        }
      }


    } catch (e) {
      console.log(e)
    }
  }

  // 结束录音的方法
  static stop() {
    if (AudioCapture.audioCapturer) {
      AudioCapture.audioCapturer.stop()
      AudioCapture.recordIng = false
    }
  }

  // 释放资源 (销毁音频控制器)
  static release() {
    if (AudioCapture.audioCapturer) {
      AudioCapture.audioCapturer.release()
    }
  }
}