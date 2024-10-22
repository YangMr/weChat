import { DefaultUserList, UserInfo } from '../models/users'
import { router } from '@kit.ArkUI'

@Component
struct Connect {
  @State
  filterList: UserInfo[] = []
  @State
  @Watch("filterName")
  searchName: string = ""

  // 组件开始加载的时候触发
  aboutToAppear(): void {
    // 组件一开始加载的时候, 将自定义的数据赋值给filterList
    this.filterList = DefaultUserList
  }

  // 筛选联系人方法
  filterName() {
    this.filterList = DefaultUserList.filter((user: UserInfo) => {
      // 如果联系人列表数据中,存在输入的联系人名称,则将搜索到的联系人数据返回给filterList
      return user.username.includes(this.searchName)
    })
  }

  build() {
    Column() {
      // 搜索栏
      Row() {
        Search({ placeholder: "搜索", value: $$this.searchName })
          .backgroundColor($r("app.color.white"))
          .height(30)
          .borderRadius(4)
      }
      .width("100%")
      .padding({
        left: 10,
        right: 10
      })

      // 联系人列表
      List() {
        ForEach(this.filterList, (item: UserInfo) => {
          ListItem() {
            Row({ space: 10 }) {
              Image(item.avatar)
                .width(30)
                .height(30)
                .borderRadius(4)

              Column() {
                Text(item.username)
                  .fontSize(14)
                  .fontColor($r("app.color.text_primary"))
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
            }
            .padding({
              left: 10,
              right: 10
            })
            .height(60)
            .width("100%")
            .stateStyles({
              pressed: {
                .backgroundColor($r("app.color.back_color"))
              },
              normal: {
                .backgroundColor($r("app.color.white"))
              }
            })

          }
          .onClick(() => {
            router.pushUrl({
              url: "pages/ChatDetail/ChatDetail",
              params: item
            })
          })
        }, (item: UserInfo) => item.user_id)
      }
      .width("100%")
      .height("100%")
      .padding({
        top: 10,
        bottom: 10
      })
      .divider({
        strokeWidth: 1,
        color: $r("app.color.border_color")
      })
      .layoutWeight(1)
      .backgroundColor($r("app.color.white"))
    }
    .width("100%")
    .height("100%")
    .padding({
      top: 20
    })
    .backgroundColor($r("app.color.back_color"))
  }
}

export default Connect