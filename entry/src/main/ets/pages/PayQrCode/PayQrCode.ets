import { router } from '@kit.ArkUI';
import { generateBarcode, scanCore } from '@kit.ScanKit';

@Entry
@Component
struct PayQrCode {
  @State
  payParams: string = Math.random().toString()
  @State
  // 声明一个变量,保存条形码
  barCodeImage: PixelMap | null = null

  // 生成条形码
  async createBarCode() {
    try {
      if (canIUse('SystemCapability.Multimedia.Scan.Core')) {
        if (canIUse('SystemCapability.Multimedia.Scan.GenerateBarcode')) {
          this.barCodeImage = await generateBarcode.createBarcode(this.payParams, {
            scanType: scanCore.ScanType.CODE128_CODE,
            height: 200,
            width: 800
          })
        }
      }
    } catch (e) {
      console.log(e)
    }
  }

  aboutToAppear(): void {
    this.refreshQrCode()

    this.createBarCode()
  }

  // 刷新二维码方法
  refreshQrCode() {
    setInterval(() => {
      this.payParams = Math.random().toString()
    }, 3000)
  }

  build() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.Start }) {
          Image($r("app.media.ic_public_arrow_left"))
            .width(30)
            .height(30)
            .fillColor($r("app.color.white"))
            .zIndex(2)
            .onClick(() => {
              router.back();
            })

          Text("收付款")
            .fontColor($r("app.color.white"))
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .width("100%")

        }
      }
      .width("100%")
      .height(50)

      Column() {
        Column() {
          Row({ space: 10 }) {
            Image($r("app.media.ic_public_scan"))
              .width(20)
              .height(20)
              .fillColor($r("app.color.pay_back"))

            Text("付款码")
              .fontColor($r("app.color.pay_back"))
              .fontSize(16)
          }
          .width("100%")
          .height(60)
          .padding({
            left: 10,
            right: 10
          })
          .border({
            width: {
              bottom: 1
            },
            color: $r("app.color.border_color")
          })

          Column() {
            Text("优先使用xx银行储蓄卡付款")
              .fontColor($r("app.color.text_second"))
              .fontSize(12)
              .margin({
                bottom: 10
              })

            QRCode(this.payParams)
              .width(140)
              .height(140)
              .margin({
                top: 10,
                bottom: 20
              })

            Image(this.barCodeImage)
              .width(280)
              .height(100)
          }
          .margin({
            top: 10,
            bottom: 10
          })

        }
        .width("100%")
        .backgroundColor($r("app.color.white"))
        .borderRadius(4)
      }
      .layoutWeight(1)
      .width("100%")
      .padding(10)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.pay_back"))
  }
}