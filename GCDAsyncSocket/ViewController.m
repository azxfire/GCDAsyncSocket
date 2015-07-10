//
//  ViewController.m
//  GCDAsyncSocket
//
//  Created by taowang on 15/7/10.
//  Copyright © 2015年 Plague. All rights reserved.
//

#import "ViewController.h"
#import <GCDAsyncSocket.h>
@interface ViewController ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *socket;
    UITextField *nameTextField;
    UIButton *submitNameButton;
    UITextField *contentField;
    UIButton    *submitContentButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self connectToServer];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)loadView
{
    self.view = [[UIView alloc]init];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //nameTestField
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 20, 100, 30)];
    nameTextField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:nameTextField];
    submitNameButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    submitNameButton.frame = CGRectMake(130, 20, 20, 20);
    [submitNameButton addTarget:self action:@selector(submitNameButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitNameButton];
    //contentTextField
    
    contentField = [[UITextField alloc]initWithFrame:CGRectMake(20, 60, 100, 30)];
    contentField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:contentField];
    
    submitContentButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    submitContentButton.frame = CGRectMake(130, 60, 20, 20);
    [self.view addSubview:submitContentButton];
    [submitContentButton addTarget:self action:@selector(submitContentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)submitNameButtonClick
{
    NSString *writeString = [NSString stringWithFormat:@"iam:%@",nameTextField.text];
    NSData *data = [[NSData alloc]initWithData:[writeString dataUsingEncoding:NSASCIIStringEncoding]];
    if ([socket isConnected]) {
        [socket writeData:data withTimeout:5 tag:1];
    }
}
-(void)submitContentButtonClick
{
    NSString *response2 = [NSString stringWithFormat:@"msg:%@",contentField.text];
    NSData *data2 = [[NSData alloc]initWithData:[response2 dataUsingEncoding:NSASCIIStringEncoding]];
    [socket writeData:data2 withTimeout:5 tag:2];

}
-(void)connectToServer
{
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err;
    [socket connectToHost:@"localhost" onPort:80 error:&err];
    if (err != nil) {
        NSLog(@"%@",err);
    }
    
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%@",host);
    
//    NSString *response  = [NSString stringWithFormat:@"iam:%@", @"xubaobao"];
//    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
//    [socket writeData:data  withTimeout:5 tag:1];
//    
//    
//    NSString *response2 = [NSString stringWithFormat:@"msg:%@",@"i Love you"];
//    NSData *data2 = [[NSData alloc]initWithData:[response2 dataUsingEncoding:NSASCIIStringEncoding]];
//    [socket writeData:data2 withTimeout:5 tag:2];
    //设置连接一直不超时
    [socket readDataWithTimeout:-1 tag:0];
}
//完成写之后调用
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    uint8_t buffer[1024];
    int len;
    NSInputStream *writeStream = (NSInputStream *)socket.writeStream;
    while ([writeStream hasBytesAvailable]) {
        //获取长度
        len = (int)[writeStream read:buffer maxLength:sizeof(buffer)];
        if (len > 0) {
            //转化成string
            NSString *output = [[NSString alloc]initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];;
            if (nil != output) {
                NSLog(@"server said: %@", output);
                
            }
        }
    }
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *outPutStr = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%@",outPutStr);
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
