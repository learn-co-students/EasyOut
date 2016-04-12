
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
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


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
    [self.contentView.widthAnchor constraintEqualToAnchor: self.widthAnchor].active = YES;
    [self.contentView.centerXAnchor constraintEqualToAnchor: self.centerXAnchor].active = YES;
    [self.contentView.centerYAnchor constraintEqualToAnchor: self.centerYAnchor].active = YES;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
}

-(void)setActivity:(Activity *)activity {
    
    _activity = activity;
    [self updateUI];
}


// Add data to activity card view
-(void)updateUI {
    
//    self.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:self.activity.imageURL]];
    self.nameLabel.text = self.activity.name;
    self.addressLabel.text = self.activity.address;
    
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
    
    
    switch (self.activity.activityType) {
        case RestaurantType:
            self.detailLabel.text = ((Restaurant *)self.activity).price;
            break;
        case EventType:
            self.detailLabel.text = ((Event *)self.activity).time;
            break;
        default:
            break;
    }

}

- (IBAction)cardSelected:(UIButton *)sender {
    
    if(self.backgroundColor == [UIColor blackColor]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.nameLabel.textColor = [UIColor blackColor];
        self.addressLabel.textColor = [UIColor blackColor];
        self.detailLabel.textColor = [UIColor blackColor];
    }
    else {
        
        self.backgroundColor = [UIColor blackColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.addressLabel.textColor = [UIColor whiteColor];
        self.detailLabel.textColor = [UIColor whiteColor];
        
    }
    
}



@end
