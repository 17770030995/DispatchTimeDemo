//
//  ViewController.m
//  DispatchTimeDemo
//
//  Created by 李传熔 on 2021/5/25.
//

#import "ViewController.h"

@interface ViewController ()
{
    int timeOut;
}

@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    timeOut = 10;
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%d",timeOut] forState:UIControlStateNormal];
    
}

- (IBAction)btnTap:(id)sender {
    
    dispatch_queue_t globalQ = dispatch_get_global_queue(0, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQ);
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        if (self->timeOut <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeBtn.enabled = YES;
                self->timeOut = 10;
                [self.timeBtn setTitle:[NSString stringWithFormat:@"%d",self->timeOut] forState:UIControlStateNormal];
            });
        }else{
            self->timeOut --;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeBtn.enabled = NO;
                [self.timeBtn setTitle:[NSString stringWithFormat:@"%d",self->timeOut] forState:UIControlStateNormal];
            });
        }
        
    });
    
    //开始执行dispatch 源
    dispatch_resume(timer);
}

@end
