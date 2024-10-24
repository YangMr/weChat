import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';

const service = axios.create({
  baseURL: "https://api.ownthink.com",
  timeout: 10000
})

// 请求拦截器
service.interceptors.request.use((config: InternalAxiosRequestConfig) => {

  return config;
}, (error: AxiosError) => {
  // Do something with the request error.
  return Promise.reject(error);
});


// 响应拦截器
service.interceptors.response.use((response: AxiosResponse) => {
  return response.data.data;
}, (error: AxiosError) => {
  // Do something with the response error.
  return Promise.reject(error);
});

// 自定义的请求
export class Http {
  static get<T>(url: string, params?: object) {
    return service.get<null, T>(url, {
      params
    })
  }

  static post<T>(url: string, data?: object) {
    return service.post<null, T>(url, data)
  }

  static put<T>(url: string, data?: object) {
    return service.put<null, T>(url, data)
  }

  static delete<T>(url: string, data?: object) {
    return service.delete<null, T>(url, data)
  }
}

export default service

// 1. 封装http请求
// 2. 封装api接口
// 3. 发送消息的时候,调用Api接口, 将它返回的数据添加到messageList