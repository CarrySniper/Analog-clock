//
//  AnalogClock.m
//  绘制模拟时钟
//
//  Created by 陈家庆 on 15-2-10.
//  Copyright (c) 2015年 shikee_Chan. All rights reserved.
//

#import "AnalogClock.h"

@implementation AnalogClock{
    //AnalogClock的半径
    CGFloat _radius;
    
    //半径 时 分 秒
    CGFloat _hourR;
    CGFloat _minR;
    CGFloat _secR;
    
    //表示当前的角度
    CGFloat _hourDegree;
    CGFloat _minDegree;
    CGFloat _secDegree;
    
    //时间label
    UILabel *_timeLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置背景透明
        self.backgroundColor = [UIColor clearColor];
        //以短边为准，取宽高的较小值
        _radius = frame.size.width < frame.size.height ? frame.size.width/2 : frame.size.height/2;
        
        _hourR = _radius-5;
        _minR = _radius - 20;
        _secR = _radius - 35;
        
        //旋转270度
        self.transform = CGAffineTransformRotate(self.transform, 270 * M_PI / 180.0);//顺时针旋转270度

        
        //获取当前时间，转换成角度
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh"];
        float hour = [[dateFormatter stringFromDate:date]floatValue];
        [dateFormatter setDateFormat:@"mm"];
        float min = [[dateFormatter stringFromDate:date]floatValue];
        [dateFormatter setDateFormat:@"ss"];
        float sec = [[dateFormatter stringFromDate:date]floatValue];
        
        _secDegree = sec*360/60;
        _minDegree = min*360/60 + sec*360/60/60;
        _hourDegree = hour*360/12 + min*360/12/60 + sec*360/12/60/60;
        /*
         ***时间角度适配 12小时制
         360度对应60秒，60分，24小时
         所以：每秒钟的角度360/60;因此，每分钟的角度360/60;每小时的角度360/24;
         需求：当前时间转换角度
         _secDegree = sec*360/60;
         _minDegree = min*360/60;
         _hourDegree = hour*360/12;
         
         如若要把分钟、秒钟添加在小时的圆上 则需要知道1分钟对应小时的圆占多少
         一小时的角度为：360/12;
         一分钟的角度为：360/12/60
         一秒钟的角度为：360/12/60/60
         所以最后：
         _secDegree = sec*360/60;
         _minDegree = min*360/60 + sec*360/60/60 = 360/60*(min+sec/60);
         _hourDegree = hour*360/12 + min*360/12/60 +sec*360/12/60/60 = 360/12*(hour+min/60+sec/60/60);
         */
        
        /*
         ***显示当前时间
         */
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _radius-10, 2*_radius, 20)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.highlighted = YES;
        _timeLabel.highlightedTextColor = [UIColor yellowColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.shadowColor = [UIColor redColor];
        [self addSubview:_timeLabel];
        
        _timeLabel.transform = CGAffineTransformRotate(_timeLabel.transform, 90 * M_PI / 180.0);//顺时针旋转90度
        /*
         一秒钟转一圈，由 360次/S 得
         NSTimeInterval=1.0/360
         需求：60秒钟 秒针转一圈,则NSTimeInterval=60*1.0/360
         */
        float time = 60;
        [NSTimer scheduledTimerWithTimeInterval:time*1.0/360.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)timerAction
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];//@"yyyy年MM月dd日 hh:mm:ss"
    _timeLabel.text =[dateFormatter stringFromDate:date];
    /*
     ***三者之间的关系 12小时制
     
     _secDegree = sec*360/60;
     _minDegree = min*360/60;
     _hourDegree = hour*360/12;
     
     _secDegree++;_minDegree、_hourDegree应该加多少？
     时间为60.0/360秒,即60.0/360/60分，即60.0/360/60/60小时
     所以：
     _secDegree++;
     _minDegree = min*360/60  = 60.0/360/60*360/60;
     _hourDegree = hour*360/12 = 60.0/360/60/60*360/12;
     
     */
    
    _secDegree ++;
    _minDegree += 60.0/360/60*360.0/60;
    _hourDegree += 60.0/360/60/60*360.0/12;
    //NSLog(@"%f %f %f",_secDegree,_minDegree,_hourDegree);
    
    if(_secDegree >= 360){//一圈 一分钟校准一次
        _secDegree = 0;
        //NSLog(@"前：%f %f %f",_secDegree,_minDegree,_hourDegree);
        [dateFormatter setDateFormat:@"hh"];
        float hour = [[dateFormatter stringFromDate:date]floatValue];
        [dateFormatter setDateFormat:@"mm"];
        float min = [[dateFormatter stringFromDate:date]floatValue];
        [dateFormatter setDateFormat:@"ss"];
        float sec = [[dateFormatter stringFromDate:date]floatValue];
        _secDegree = sec*360/60;
        _minDegree = min*360/60 + sec*360/60/60;
        _hourDegree = hour*360/12 + min*360/12/60 + sec*360/12/60/60;
        //NSLog(@"后：%f %f %f",_secDegree,_minDegree,_hourDegree);
    }
    
    [self setNeedsDisplay];//会调用自动调用drawRect方法,方便绘图
}

//度转换成弧度
CGFloat degreeToRadian(CGFloat degree)
{
    return  M_PI / 180 * degree;
}

- (void)drawRect:(CGRect)rect
{
    //圆轨迹
    CGContextRef contextSEC1 = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(contextSEC1, 1, 0.5, 0.5, 0.3);//改变画笔颜色
    CGContextSetLineWidth(contextSEC1, 5.0);//线的宽度
    CGContextAddArc(contextSEC1, _radius, _radius, _secR, degreeToRadian(0), degreeToRadian(360), 0);
    CGContextStrokePath(contextSEC1);
    CGContextRef contextMIN1 = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(contextMIN1, 0.5, 0.5, 1, 0.3);//改变画笔颜色
    CGContextSetLineWidth(contextMIN1, 5.0);//线的宽度
    CGContextAddArc(contextMIN1, _radius, _radius, _minR, degreeToRadian(0), degreeToRadian(360), 0);
    CGContextStrokePath(contextMIN1);
    CGContextRef contextHOUR1 = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(contextHOUR1, 0.5, 1, 0.5, 0.3);//改变画笔颜色
    CGContextSetLineWidth(contextHOUR1, 5.0);//线的宽度
    CGContextAddArc(contextHOUR1, _radius, _radius, _hourR, degreeToRadian(0), degreeToRadian(360), 0);
    CGContextStrokePath(contextHOUR1);
    
    
    //时间刻度
    CGContextRef contextRefHOUR = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(contextRefHOUR, 0, 1, 0, 1);//改变画笔颜色
    CGContextSetLineWidth(contextRefHOUR, 7.0);//线的宽度
    //时
    CGContextAddArc(contextRefHOUR, _radius, _radius, _hourR, degreeToRadian(0), degreeToRadian(_hourDegree), 0);
    //绘画路径
    CGContextStrokePath(contextRefHOUR);
    
    //分
    CGContextRef contextMIN = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(contextMIN, 0, 0, 1, 1);//改变画笔颜色
    CGContextSetLineWidth(contextMIN, 7.0);//线的宽度
    CGContextAddArc(contextMIN, _radius, _radius, _minR, degreeToRadian(0), degreeToRadian(_minDegree), 0);
    CGContextStrokePath(contextMIN);
    //秒
    CGContextRef contextSEC = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(contextSEC, 1, 0, 0, 1);//改变画笔颜色
    CGContextSetLineWidth(contextSEC, 7.0);//线的宽度
    CGContextAddArc(contextSEC, _radius, _radius, _secR, degreeToRadian(0), degreeToRadian(_secDegree), 0);
    CGContextStrokePath(contextSEC);
    
    
}
/*
 void CGContextAddArc (
 CGContextRef c,
 CGFloat x,    /圆心的x坐标
 CGFloat y,    //圆心的x坐标
 CGFloat radius,   //圆的半径
 CGFloat startAngle, //开始弧度
 CGFloat endAngle,   //结束弧度
 int clockwise       //0表示顺时针，1表示逆时针
 );
 假如想创建一个完整的圆圈，那么 开始弧度就是0 结束弧度是 2pi， 因为圆周长是 2*pi*r.
 最后，函数执行完后，current point就被重置为(x,y).
 还有一点要注意的是，假如当前path已经存在一个subpath，那么这个函数执行的另外一个效果是
 会有一条直线，从current point到弧的起点
 
 iphone屏的角度
 270度
 
 180度           0度
 
 90度
 顺时针旋转270度，以0为起点则向时钟
 */

@end
