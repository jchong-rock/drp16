//
//  FestivalViewController.h
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import <UIKit/UIKit.h>

@interface FestivalViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UILabel * titleLabel;
}

@property (retain, nonatomic) UILabel * titleLabel;
@property (retain, nonatomic) IBOutlet UIButton * settingsButton;
@property (weak, nonatomic) IBOutlet UITableView * paragraphTable;

@end
