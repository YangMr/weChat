import { Http } from '../utils/Http'

export interface ChatData {
  type: number,
  info: ChatDataInfo
}

export interface ChatDataInfo {
  text: string
}


export const getMessageInfo = (keyword: string): Promise<ChatData> => {
  return Http.get<ChatData>(`/bot?userid=${Date.now()}&spoken=${keyword}`)
  // return Http.get<ChatData>(`/bot?userid=${Date.now()}&spoken=${keyword}`)
  // return Http.get<ChatData>("/bot", params)
}