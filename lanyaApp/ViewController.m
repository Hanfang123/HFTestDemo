//
//  ViewController.m
//  lanyaApp
//
//  Created by zlkj on 2018/7/5.
//  Copyright © 2018年 nqkj. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#define ServiceUUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,strong)CBCentralManager *centralManager;
@property (nonatomic,strong)CBPeripheral     * peripheral;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
}

//
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {

    if (central.state == CBManagerStatePoweredOn) {
        NSLog(@"成功");
        //
        [central scanForPeripheralsWithServices:nil options:nil];
    }
    if(central.state==CBManagerStateUnsupported) {
        NSLog(@"不支持");
    }
    if (central.state==CBManagerStatePoweredOff) {
        NSLog(@"未打开");
    }
}



- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"%@",peripheral.name);
    
    NSLog(@"===%@",peripheral);
//    for (CBService *service in peripheral.services) {
//        NSLog(@"所有的服务：%@",service);
//    }
//
    // 这里仅有一个服务，所以直接获取
//    CBService *service = peripheral.services.lastObject;
//    // 根据UUID寻找服务中的特征
//    [peripheral discoverCharacteristics:nil forService:service];
//
//    // 连接外设
//    [central connectPeripheral:peripheral options:nil];
}

/** 连接成功 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    // 可以停止扫描
    [self.centralManager stopScan];
    // 设置代理
    peripheral.delegate = self;
    // 根据UUID来寻找服务
    [peripheral discoverServices:@[[CBUUID UUIDWithString:@""]]];
    NSLog(@"连接成功");
}

/** 连接失败的回调 */
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"连接失败");
}

/** 断开连接 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"断开连接");
    // 断开连接可以设置重新连接
    [central connectPeripheral:peripheral options:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
