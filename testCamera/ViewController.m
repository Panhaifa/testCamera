//
//  ViewController.m
//  testCamera
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 com.chinaums. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIActionSheetDelegate>
{
    UIButton *button;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClcik:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)buttonClcik:(UIButton *)btn
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [actionSheet showInView:self.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController * _picker = [[UIImagePickerController alloc] init];//初始化
            _picker.delegate = (id)self;
            _picker.allowsEditing = NO;//设置可编辑
            
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_picker animated:YES completion:nil];
           
            
        }
            break;
        case 1:
        {
            //相册
            UIImagePickerController* _picker = [[UIImagePickerController alloc] init];//初始化
            _picker.delegate = (id)self;
            _picker.allowsEditing = NO;//设置可编辑
//            UIColor *color = HEX_RGB(0x343944);
//            UIImage *img = [UIImage imageWithColor: [color colorWithAlphaComponent:0.99]];
//            [_picker.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
//            [[UINavigationBar appearance] setTintColor:[UIColor bgColor_nav]];
            
//            NSDictionary *titleTextDic = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
//                                           NSForegroundColorAttributeName:[UIColor whiteColor],
//                                           UITextAttributeTextShadowColor:[UIColor lightGrayColor]
//                                           };
//            _picker.navigationBar.titleTextAttributes = titleTextDic;
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_picker animated:YES completion:nil];//进入照相界面
        }
            break;
        case 2:
        {
            //取消

        }
            break;
            
        default:
            break;
    }
    
    
}



//点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    //保存


    

    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        //以下是保存文件到Document路径下
        //把图片转成NSData类型的数据来保存文件
        NSData *data = nil;
        //判断图片是不是png格式的文件
        NSString *imagePath;
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
            imagePath =  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"xxx.png"];
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
            imagePath =  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"xxx.jpeg"];
        }
        
        //保存
        //    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:data attributes:nil];
        [data writeToFile:imagePath atomically:NO];
        
      
        
        //判断是否保存成功
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:imagePath]==YES) {
            NSLog(@"File exists");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                //读取图片
                NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"xxx.png"];
                UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
                
                [button setBackgroundImage:savedImage forState:UIControlStateNormal];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            });
        }
        
        
    });
}

//点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)getImageSavePath{
    //获取存放的照片
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
//    //指定新建文件夹路径
//    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"PhotoFile"];
    return documentPath;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
