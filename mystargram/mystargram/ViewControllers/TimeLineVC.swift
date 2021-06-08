//
//  TimeLineVC.swift
//  mystargram
//
//  Created by Kim on 2021/06/02.
//

import UIKit

class TimeLineVC: UIViewController {
    @IBOutlet weak var timelineTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timelineTabelView.delegate = self
        timelineTabelView.dataSource = self
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TimeLineVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = timelineTabelView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as? TimelineTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    
}


class TimelineTableViewCell: UITableViewCell {
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var contentTxtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
