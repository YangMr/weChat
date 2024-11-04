import { display, promptAction } from '@kit.ArkUI'
import { PopupItem } from '../../models/popup'
import { VoiceRecordEnum } from '../../models/voice'
import VoiceInput from './VoiceInput'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { fileIo } from '@kit.CoreFileKit'
import { camera, cameraPicker as picker } from '@kit.CameraKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { abilityAccessCtrl, bundleManager, common } from '@kit.AbilityKit'

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
  @State
  duration: number = 0
  // 保存定时器
  @State
  timer: number = -1

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
  sendVideoMessage: (filePath: string) => void = () => {
  }

  // 唤醒相机并发送拍摄的照片
  async openCamera() {
    try {
      // 1. 唤醒相机
      let pickerProfile: picker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      let pickerResult: picker.PickerResult = await picker.pick(getContext(),
        [picker.PickerMediaType.PHOTO, picker.PickerMediaType.VIDEO], pickerProfile);

      // 2.选择拍照
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
      } else { // 2. 选择拍视频
        //  调用打开文件方法, 如果视频在本地不存在,则进行创建
        const file = fileIo.openSync(pickerResult.resultUri, fileIo.OpenMode.READ_ONLY)
        // 获取本地沙箱的files这个文件夹的对应的图片
        const newFileName = getContext().filesDir + "/" + Date.now() + ".mp4"
        // 将存入到本地沙箱的文件数据拷贝到newFileName文件中
        fileIo.copyFileSync(file.fd, newFileName)
        // 关闭打开
        fileIo.closeSync(file.fd)

        this.sendVideoMessage(newFileName)
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

  // 检测麦克风权限
  checkMicroPhonePermission() {
    // 创建程序控制管理器
    const manager = abilityAccessCtrl.createAtManager()
    //获取当前的应用信息
    const bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    // 检测麦克风权限
    const status = manager.checkAccessTokenSync(bundleInfo.appInfo.accessTokenId, "ohos.permission.MICROPHONE")
    // 判断是否有录音权限
    if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
      // 没有权限 -- 跳转到开启权限页面
      (getContext() as common.UIAbilityContext).startAbility({
        bundleName: "com.huawei.hmos.settings",
        abilityName: "com.huawei.hmos.settings.MainAbility",
        uri: "application_info_entry",
        parameters: {
          pushParams: bundleInfo.name
        }
      })
    } else {

      // 显示那个绿色的盒子
      this.showVoiceCom = true

      // 开始录音
      this.collectVoice()
    }
  }

  // 开始录音方法
  collectVoice() {
    // 进行计时
    this.startTime()

    // 正式录音


  }

  // 开启计时
  startTime() {
    this.timer = setInterval(() => {
      this.duration++

      promptAction.showToast({
        message: `当前语音:${this.duration}秒`
      })
    }, 1000)
  }

  // 结束计时
  endTime() {
    clearInterval(this.timer)


  }

  // 手势结束时触发的方法
  releaseFinger() {
    // 让绿色的盒子消失
    this.showVoiceCom = false

    // 调用结束计时方法
    this.endTime()

    if (this.voiceState === VoiceRecordEnum.RecordIng) {
      if (this.duration < 1) {
        return promptAction.showToast({
          message: "内容时间不足一秒！"
        })
      }
      this.duration = 0
    } else if (this.voiceState === VoiceRecordEnum.Cancel) {
      this.duration = 0
    } else if (this.voiceState === VoiceRecordEnum.Transfer) {
      this.duration = 0
    }
  }

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
                  .onAction(() => { // 手势开始的时候触发

                    // 检测麦克风权限? 没有权限 -> 展示一个弹层: 权限界面
                    this.checkMicroPhonePermission()
                  })
                  .onActionEnd(() => {


                    // 手势结束时触发的方法
                    this.releaseFinger()
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