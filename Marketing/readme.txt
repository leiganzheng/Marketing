

/**********************************************
// ******* 本文件对该项目做一个简单的说明 ******* //
#pragma mark - 支持ReactiveCocoa和Pods
1、工程支持ReactiveCocoa 框架。
    ReactiveCocoa框架概览：http://blog.csdn.net/xdrt81y/article/details/30624469
    Github地址：https://github.com/ReactiveCocoa/ReactiveCocoa
说明:
ReactiveCocoa使用例子：
//标准按钮事件处理方式
    [UIButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
//使用ReavtiveCocoa 按钮事件处理方式 针对UIControlEventTouchUpInside事件 以及循环引用处理方式
    @weakify(self);
    UIButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(self);
        //something to do ;
        return [RACSignal empty];
    }];

2、使用CocoaPods管理第三方库。
    教程地址：http://code4app.com/article/cocoapods-install-usage


#pragma mark - 开发注意：
·· AppID 和 SKU 已经有定义好的宏，不允许直接使用 @"...", 有用到的地方，必须用宏定义 APP_ID APP_SKU
·· 有需要用到App前缀的地方 请使用 M**** ；
·· 数据模型使用统一的前缀 M_**** ;
·· 资源要分类存储，最好是能分模块放在不同的文件夹中，并有统一的前缀(避免模块间的重名)；
·· 在 storyboard 中新建Scene时，StoryboardID 必须与 类名想同；
·· 新建的 ViewController 应该继承 QNBaseViewController 或者 QNBaseTableViewController

#pragma mark - Class文件夹下的目录说明：
·· Constents: 通用的宏定义，（必看）
·· QNShareDatas: App中共享的数据都在此单例中
·· Tools/: 工具类
·· DataModel/: 数据模型
·· Extension/: 扩展。。 待续... ...
·· Base/: 基类


#pragma mark - Library 文件夹下的目录说明：(只记录被我们修改的库）
··


#pragma mark - Resources 文件夹下的目录说明：
·· Fonts/: 项目中引入的字体文件
·· Images/: 项目中的图片资源
·· Sounds/: 项目中的声音资源
·· CSS/: 项目中的CSS文件


#pragma mark - 主UI框架类介绍:



**********************************************/










