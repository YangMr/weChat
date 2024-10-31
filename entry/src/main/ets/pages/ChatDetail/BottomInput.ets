import { display, promptAction } from '@kit.ArkUI'
import { PopupItem } from '../../models/popup'
import { VoiceRecordEnum } from '../../models/voice'
import VoiceInput from './VoiceInput'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { fileIo } from '@kit.CoreFileKit'
import { camera, cameraPicker as picker } from '@kit.CameraKit'
import { BusinessError } from '@kit.BasicServicesKit'

@Component
struct BottomInput {
  @State
  showVoice: boolean = false
  // 保存的是输入框输入的内容
  @State
  content: string = ""
  // 控制按钮说话按钮的弹层
  @State
  showVoiceCom: boolean = false
  // 记录屏幕整体的宽度
  @State
  screenWidth: number = 0
  // 记录屏幕整体的高度
  screenHeight: number = 0
  // 保存当前的状态
  @Provide
  voiceState: VoiceRecordEnum = VoiceRecordEnum.RecordIng
  // 定义底部菜单的数据
  @State
  bottomList: PopupItem[] = [
    {
      icon: $r('app.media.ic_public_photo'),
      title: '照片',
      itemClick: () => {
        this.sendPhoto()
      }
    },
    {
      icon: $r('app.media.ic_public_carema'),
      title: '拍摄',
      itemClick: () => {
        // 唤醒相机
        this.openCamera()
      }
    },
    {
      icon: $r('app.media.ic_statusbar_gps'),
      title: '位置',

    },
    {
      icon: $r('app.media.ic_public_voice'),
      title: '语音输入',

    },
    {
      icon: $r("app.media.ic_public_collect"),
      title: '收藏',

    },
    {
      icon: $r("app.media.ic_public_contacts_filled"),
      title: '个人名片',

    },
    {
      icon: $r("app.media.ic_public_folder_filled"),
      title: '文件',

    },
    {
      icon: $r("app.media.ic_public_music_filled"),
      title: '音乐',
    }
  ]
  // 定义一个变量, 用来控制底部菜单的显示与隐藏
  @State
  showBottomCard: boolean = false

  @Builder
  getBottomCard(item: PopupItem) {
    Column() {
      Column() {
        Image(item.icon)
          .width(30)
          .height(30)
          .fillColor("#4c4c4c")
      }
      .backgroundColor($r("app.color.white"))
      .width(56)
      .aspectRatio(1)
      .borderRadius(10)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)


      Text(item.title)
        .fontSize(12)
        .margin({
          top: 10
        })
        .fontColor($r("app.color.text_second"))
    }
    .layoutWeight(1)
  }

  // 页面加载的时候获取整个屏幕的宽度与高度
  aboutToAppear(): void {
    // px 转化为 vp
    this.screenWidth = px2vp(display.getDefaultDisplaySync().width)
    this.screenHeight = px2vp(display.getDefaultDisplaySync().height)
  }

  sendTextMessage: (content: string) => void = () => {
  }
  sendImageMessage: (filePath: string) => void = () => {
  }

  // 唤醒相机并发送拍摄的照片
  async openCamera() {
    try {
      let pickerProfile: picker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      let pickerResult: picker.PickerResult = await picker.pick(getContext(),
        [picker.PickerMediaType.PHOTO, picker.PickerMediaType.VIDEO], pickerProfile);

      if (pickerResult.mediaType === "photo" && pickerResult.resultUri !== "") {
        //  调用打开文件方法, 如果图片在本地不存在,则进行创建
        const file = fileIo.openSync(pickerResult.resultUri, fileIo.OpenMode.READ_ONLY)
        // 获取本地沙箱的files这个文件夹的对应的图片
        const newFileName = getContext().filesDir + "/" + Date.now() + ".jpg"
        // 将存入到本地沙箱的文件数据拷贝到newFileName文件中
        fileIo.copyFileSync(file.fd, newFileName)
        // 关闭打开
        fileIo.closeSync(file.fd)

        this.sendImageMessage(newFileName)
      }

    } catch (error) {
      let err = error as BusinessError;
      console.error(`the pick call failed. error code: ${err.code}`);
    }
  }

  // 发送图片的方法
  async sendPhoto() {
    // 选择完图片之后发送图片(聊天框)

    // 1. 打开系统相册
    // 2. 选择图片
    // 3. 设置选择图片的数量
    // 4. 获取选择的图片
    const photoViewPicker = new photoAccessHelper.PhotoViewPicker()
    const result = await photoViewPicker.select({
      // 设置选择类型 (图片 / 视频)
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE,
      // 设置选择图片或者视频的数量
      maxSelectNumber: 9
    })


    // 5. 将图片保存沙箱
    // 5.1  定义图片存储的路径
    // 5.2 调用打开文件方法, 在方法内传入打开的文件路径,如果没有当前要打开的文件,这个打开方法会自动创建对应的文件
    // 5.3 拷贝一下打开的文件
    // 5.4 关闭打开文件方法

    if (result.photoUris.length) {
      result.photoUris.forEach((item) => {

        //  调用打开文件方法, 如果图片在本地不存在,则进行创建
        const file = fileIo.openSync(item, fileIo.OpenMode.READ_ONLY)
        // 获取本地沙箱的files这个文件夹的对应的图片
        const newFileName = getContext().filesDir + "/" + Date.now() + ".jpg"
        // 将存入到本地沙箱的文件数据拷贝到newFileName文件中
        fileIo.copyFileSync(file.fd, newFileName)
        // 关闭打开
        fileIo.closeSync(file.fd)

        this.sendImageMessage(newFileName)
      })
    }


  }

  // 1. 获取整个屏幕的宽度与高度
  // 2. 获取当前手指触摸的坐标x - y
  // 3. 手势拖动的时候, 判断当前手指触摸的坐标x - y 是否大于
  // 屏幕高度 -  录音区域的高度
  // 4. 如果大于 屏幕高度 -  录音区域的高度 说明手势拖动录音区域
  // 5. 如果小于 屏幕高度 -  录音区域的高度 说明手势不在拖动录音区域

  // 1. 定义三个状态 0 录音 1 取消 2 语音转文字

  @Builder
  getVoiceCom() {
    Column() {
      VoiceInput()
    }
  }

  build() {
    Column() {
      Row({ space: 10 }) {
        Image(this.showVoice ? $r("app.media.ic_public_keyboard") : $r("app.media.ic_public_sound"))
          .width(25)
          .height(25)
          .onClick(() => {
            this.showVoice = !this.showVoice

            if (this.showVoice) {
              animateTo({ duration: 150 }, () => {
                this.showBottomCard = false
              })
            }
          })


        if (this.showVoice) {
          Button("按住 说话", {
            type: ButtonType.Normal
          })
            .backgroundColor(Color.White)
            .height(35)
            .layoutWeight(1)
            .borderRadius(2)
            .fontColor($r("app.color.text_primary"))// 1. 绑定手势
            .gesture(
              // 2. 设置手势类型 - 组合手势
              // 3. 设置组合手势执行的顺序 - 并发执行
              GestureGroup(
                GestureMode.Parallel,
                // 长按手势
                LongPressGesture()
                  .onAction(() => {
                    // 手势开始的时候触发
                    this.showVoiceCom = true
                  })
                  .onActionEnd(() => {
                    // 手势结束的时候触发
                    this.showVoiceCom = false
                  }),
                // 移动手势
                PanGesture()
                  .onActionUpdate((event) => {
                    if (event.fingerList[0].globalY > this.screenHeight - 120) {
                      // 手势触摸到录音区域

                      this.voiceState = VoiceRecordEnum.RecordIng

                    } else {
                      // 手势不在录音区域


                      if (event.fingerList[0].globalX > this.screenWidth / 2) {
                        // 右侧
                        this.voiceState = VoiceRecordEnum.Transfer


                      } else {
                        // 左侧
                        this.voiceState = VoiceRecordEnum.Cancel


                      }
                    }
                  })
                  .onActionEnd(() => {
                    this.voiceState = VoiceRecordEnum.RecordIng
                  })
              )
            )

            .bindContentCover(this.showVoiceCom, this.getVoiceCom, {
              modalTransition: ModalTransition.NONE
            })
        } else {
          TextInput({ text: $$this.content })
            .layoutWeight(1)
            .height(35)
            .borderRadius(2)
            .backgroundColor(Color.White)
            .id("input")// .focusable(true)// 设置元素是否可以聚焦
              // .defaultFocus(true)// 通过defaultFocus()开启默认聚焦
            .onSubmit(() => {
              if (this.content) {
                // 输入的消息了, 给父组件, 父组件将输入框输入的数据放到messageList
                this.sendTextMessage(this.content)

                this.content = ""

                // 发送完消息之后,输入框可以进行聚焦
                focusControl.requestFocus("input")
              } else {
                promptAction.showToast({
                  message: "内容不能为空"
                })
              }
            })
            .onClick(() => {
              this.showBottomCard = false
            })
        }


        Image($r("app.media.ic_public_add_norm"))
          .width(25)
          .height(25)
          .onClick(() => {
            animateTo({ duration: 150 }, () => {
              this.showBottomCard = !this.showBottomCard
            })
          })
      }
      .width("100%")
      .height(60)
      .padding({
        left: 10,
        right: 10
      })


      if (this.showBottomCard) {
        GridRow({ columns: 4 }) {
          ForEach(this.bottomList, (item: PopupItem) => {
            GridCol() {
              this.getBottomCard(item)
            }
            .height(100)
            .onClick(() => {
              item.itemClick && item.itemClick()
            })
          })
        }
        .width("100%")
      }

    }
    .backgroundColor($r("app.color.second_back_color"))
  }
}

export default BottomInput