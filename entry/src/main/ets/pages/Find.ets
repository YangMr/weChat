@Preview
@Component
struct Find {
  @Builder
  getRenderItem(left: string, rightClick?: () => void) {
    Row() {
      Text(left)
      Image(
        $r("app.media.ic_public_right"))
        .width(16)
        .height(16)
    }
    .width('100%')
    .padding({
      left: 20,
      right: 20
    })
    .backgroundColor($r("app.color.white"))
    .height(60)
    .justifyContent(FlexAlign.SpaceBetween)
    .border({
      color: $r("app.color.border_color"),
      width: {
        bottom: 0.5
      }
    })
  }

  build() {
    Column() {
      Row() {
        Text("发现")
      }
      .justifyContent(FlexAlign.Center)
      .height(40)
      .width('100%')

      Scroll() {
        Column() {
          // 顶部
          this.getRenderItem("朋友圈")
          Row().height(10)
          this.getRenderItem("视频号")
          this.getRenderItem("直播")
          Row().height(10)
          this.getRenderItem("扫一扫")
          this.getRenderItem("摇一摇")
          Row().height(10)
          this.getRenderItem("看一看")
          this.getRenderItem("搜一搜")
          Row().height(10)
          this.getRenderItem("附近")
          Row().height(10)
          this.getRenderItem("购物")
          this.getRenderItem("游戏")
          Row().height(10)
          this.getRenderItem("小程序")
          Row().height(10)
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.back_color'))
  }
}

export default Find