
//
//  ActivityCardView.m
//  EggplantButton
//
//  Created by Ian Alexander Rahman on 3/31/16.
//  Copyright © 2016 Team Eggplant Button. All rights reserved.
//

#import "ActivityCardView.h"
#import "Event.h"
#import <AFNetworking/AFImageDownloader.h>
#import <AFNetworking/AFNetworking.h>


@interface ActivityCardView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel2;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;



@end

@implementation ActivityCardView


-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

-(void)commonInit {
    
    [[NSBundle mainBundle] loadNibNamed:@"ActivityCard" owner:self options:nil];

    [self addSubview:self.contentView];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView.heightAnchor constraintEqualToAnchor: self.heightAnchor].active = YES;
    [self.contentView.centerYAnchor constraintEqualToAnchor: self.centerYAnchor].active = YES;
    [self.contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20].active = YES;
    
    self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.checkButton.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
    self.checkButton.layer.borderWidth = 3;
}

-(void)setActivity:(Activity *)activity {
    
    _activity = activity;
    [self updateUI];
}


// Add data to activity card view
-(void)updateUI {
    
    self.nameLabel.text = self.activity.name;
    self.addressLabel.text = self.activity.address[0];
    self.addressLabel2.text = self.activity.address[1];
    
    AFImageDownloader *downloader = [[AFImageDownloader alloc] init];
    downloader.downloadPrioritizaton = AFImageDownloadPrioritizationLIFO;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.activity.imageURL];
    
    self.imageView.image = nil;
    Activity *activityWhoseImageWeAreDownloading = self.activity;
    
    [downloader downloadImageForURLRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *responseObject) {
        // since these views are reused, we need to double check that the image we just got is actually the one that's still
        // supposed to be seen in the view.
        
        if(self.activity == activityWhoseImageWeAreDownloading) {
            self.imageView.image = responseObject;
        }
    } failure:nil];
    
    self.detailLabel.text = self.activity.price;
    
}

- (IBAction)cardSelected:(UIButton *)sender {
    
    if([self.contentView.backgroundColor isEqual: [[UIColor blackColor] colorWithAlphaComponent:0.4]]) {
        
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        self.nameLabel.textColor = [UIColor blackColor];
        self.addressLabel.textColor = [UIColor blackColor];
        self.detailLabel.textColor = [UIColor blackColor];
    }
    else {
        
        self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.addressLabel.textColor = [UIColor whiteColor];
        self.detailLabel.textColor = [UIColor whiteColor];
        
    }
    
}



@end
