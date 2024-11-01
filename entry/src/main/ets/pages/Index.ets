import { TabBarClass } from '../models/tab'
import Connect from './Connect'
import Find from './Find'
import My from './My'
import WeChat from './WeChat'


@Entry
@Component
struct Index {
  @State
  tabBarList: TabBarClass[] = [
    {
      icon: $r('app.media.ic_public_message'),
      name: 'wechat',
      title: '微信',
      selectIcon: $r('app.media.ic_public_message_filled')
    },
    {
      icon: $r('app.media.ic_public_contacts_group'),
      name: 'connect',
      title: '联系人',
      selectIcon: $r('app.media.ic_public_contacts_group_filled')
    },
    {
      icon: $r('app.media.ic_gallery_discover'),
      name: 'discover',
      title: '发现',
      selectIcon: $r('app.media.ic_gallery_discover_filled')
    },
    {
      icon: $r('app.media.ic_public_contacts'),
      name: 'my',
      title: '我的',
      selectIcon: $r('app.media.ic_public_contacts_filled')
    }
  ]
  @State
  currentIndex: number = 0

  @Builder
  CommonTabBar(item: TabBarClass) {
    Column() {
      Image(this.tabBarList[this.currentIndex].name === item.name ? item.selectIcon : item.icon)
        .width(20)
        .height(20)

      Text(item.title)
        .fontSize(12)
        .fontColor(this.tabBarList[this.currentIndex].name == item.name ? $r("app.color.primary") :
        $r("app.color.text_primary"))
        .margin({
          top: 5
        })
    }
  }

  build() {
    Column() {
      Tabs({ index: $$this.currentIndex }) {
        ForEach(this.tabBarList, (item: TabBarClass) => {
          TabContent() {
            if (item.name === "wechat") {
              WeChat()
            } else if (item.name === "connect") {
              Connect()
            } else if (item.name === "discover") {
              Find()
            } else if (item.name === "my") {
              My()
            }
          }.tabBar(this.CommonTabBar(item))
        })
      }
      .barPosition(BarPosition.End)
      .animationDuration(300)
    }
    .width("100%")
    .height("100%")

  }
}