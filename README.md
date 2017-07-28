# 网络请求

对AFNetworking 3.x 与YYCache的二次封装,封装常见的GET、POST、文件上传/下载、断点续传、网络状态监测的功能、方法接口简洁明了,并结合YYCache实现对网络数据的缓存,搞定网络数据的请求与缓存. 控制台可直接打印json中文字符,调试更方便


## Requirements 要求
* iOS 8+
* Xcode 8+

## Installation 安装
### 1.手动安装:
`下载DEMO后,将子文件夹WWNetworkHelper拖入到项目中, 导入头文件WWNetworkHelper.h开始使用
注意: 项目中需要有AFN3.x , YYCache第三方库! 在工程中链接sqlite3依赖库`
### 2.CocoaPods安装:
first
`pod 'WWNetworkHelper'

then
`pod install或pod install --no-repo-update`

如果发现pod search WWNetworkHelper 不是最新版本，在终端执行pod setup命令更新本地spec镜像缓存

### 1. 无自动缓存(GET与POST请求用法相同)
#### 1.1 无缓存
```objc
[WWNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        //请求成功
    } failure:^(NSError *error) {
        //请求失败
}];
```
#### 1.2 无缓存,手动缓存

```objc
[WWNetworkHelper GET:url parameters:nil success:^(id responseObject) {
    //请求成功
        //手动缓存
    [WWNetworkCache setHttpCache:responseObject URL:url parameters:parameters];
    } failure:^(NSError *error) {
    //请求失败
}];
```
### 2. 自动缓存(GET与POST请求用法相同)

```objc
[WWNetworkHelper GET:url parameters:nil responseCache:^(id responseCache) {
        //加载缓存数据
    } success:^(id responseObject) {
        //请求成功
    } failure:^(NSError *error) {
        //请求失败
}];
```
### 3.单/多图片上传

```objc
[WWNetworkHelper uploadImagesWithURL:url
                    	parameters:@{@"参数":@"参数"}
                        	images:@[@"UIImage数组"]
                          name:@"文件对应服务器上的字段"
                      fileNames:@"文件名称数组"
                      imageType:@"图片的类型,png,jpeg" 
                      imageScale:@"图片文件压缩比 范围 (0.f ~ 1.f)"
                      progress:^(NSProgress *progress) {
                          //上传进度
                          NSLog(@"上传进度:%.2f%%",100.0 * progress.completedUnitCount/progress.totalUnitCount);
                      } success:^(id responseObject) {
                         //上传成功
                      } failure:^(NSError *error) {
                        //上传失败
}];

```
### 4.文件上传
```objc
[WWNetworkHelper uploadFileWithURL:url
                    parameters:@{@"参数":@"参数"}
                          name:@"文件对应服务器上的字段"
                      filePath:@"文件本地的沙盒路径"
                      progress:^(NSProgress *progress) {
                          //上传进度
                          NSLog(@"上传进度:%.2f%%",100.0 * progress.completedUnitCount/progress.totalUnitCount);
                      } success:^(id responseObject) {
                         //上传成功
                      } failure:^(NSError *error) {
                        //上传失败
}];

```
### 5.文件下载

```objc
NSURLSessionTask *task = [WWNetworkHelper downloadWithURL:url fileDir:@"下载至沙盒中的制定文件夹(默认为Download)" progress:^(NSProgress *progress) {
        //下载进度,如果要配合UI进度条显示,必须在主线程更新UI
        NSLog(@"下载进度:%.2f%%",100.0 * progress.completedUnitCount/progress.totalUnitCount);
    } success:^(NSString *filePath) {
        //下载成功
    } failure:^(NSError *error) {
        //下载失败
}];
    
//暂停下载
[task suspend];
//开始下载
[task resume];
```

```objc
#pragma mark - 断点续传相关
/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 断点续传：根据传入URL解析出的文件地址，根据已下载进度来下载未下载，取消使用cancelURL即可
 */
+ (NSURLSessionTask *)downFileBySuspendWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(WWHttpProgress)progress
                                       success:(WWHttpRequestSuccess)success
                                       failure:(WWHttpRequestFailed)failure;

```

### 6.网络状态监测

```objc
// 1.实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
[WWNetworkHelper networkStatusWithBlock:^(WWNetworkStatus status) {
   switch (status) {
       case WWNetworkStatusUnknown:          //未知网络
           break;
       case WWNetworkStatusNotReachable:    //无网络
           break;
       case WWNetworkStatusReachableViaWWAN://手机网络
           break;
       case WWNetworkStatusReachableViaWiFi://WIFI
           break;
   }
}];
    
// 2.一次性获取当前网络状态
if (kIsNetwork) {          
   NSLog(@"有网络");
   if (kIsWWANNetwork) {                    
       NSLog(@"手机网络");
   }else if (kIsWiFiNetwork){
       NSLog(@"WiFi网络");
   }
} else {
   NSLog(@"无网络");
}
```
### 7. 网络缓存
#### 7.1 自动缓存的逻辑

**1.从本地获取缓存(不管有无数据) --> 2.请求服务器数据 --> 3.更新本地数据**

#### 7.2 获取缓存总大小
```objc
NSInteger totalBytes = [WWNetworkCache getAllHttpCacheSize];
NSLog(@"网络缓存大小cache = %.2fMB",totalBytes/1024/1024.f);
```
#### 7.3 删除所有缓存

```objc
[WWNetworkCache removeAllHttpCache];
```
### 8.网络参数设置(附说明)

```objc
/*
 **************************************  说明  **********************************************
 *
 * 在一开始设计接口的时候就想着方法接口越少越好,越简单越好,只有GET,POST,上传,下载,监测网络状态就够了.
 *
 *
 * 依个人经验,在项目的开发中,一般都会将网络请求部分封装 2~3 层,第2层配置好网络请求工具的在本项目中的各项
 * 参数,其暴露出的方法接口只需留出请求URL与参数的入口就行,第3层就是对整个项目请求API的封装,其对外暴露出的
 * 的方法接口只留出请求参数的入口.这样如果以后项目要更换网络请求库或者修改请求URL,在单个文件内完成配置就好
 * 了,大大降低了项目的后期维护难度
 *
 * 综上所述,最终还是将设置参数的接口暴露出来,如果通过CocoaPods方式使用WWNetworkHelper,在设置项目网络
 * 请求参数的时候,强烈建议开发者在此基础上再封装一层,通过以下方法配置好各种参数与请求的URL,便于维护
 *
 **************************************  说明  **********************************************
 */

#pragma mark - 重置AFHTTPSessionManager相关属性
/**
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer WWRequestSerializerJSON(JSON格式),WWRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(WWRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer WWResponseSerializerJSON(JSON格式),WWResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(WWResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 *  设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103

 @param cerPath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
        的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
        一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;
```

===
## CocoaPods更新日志

```
• 2016.07.28(tag:0.0.2): 版本修改;
  1.README.md修改
  2.其它文件修改，版本完善

• 2017.07.28(tag:0.0.1): 初始化到CocoaPods;
  1.断点续传方法增加
```

## 联系方式:
* Weibo : [@王家伟](http://weibo.com/u/3193598595?source=blog)
* Email : 542413041@qq.com
* QQ : 542413041
* Blog  : http://blog.sina.com.cn/swift542413041

## 许可证
WWNetworkHelper 使用 MIT 许可证，详情见 LICENSE 文件。

