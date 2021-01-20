//
//  ManagimentShift.swift
//  ShiftSmart
//
//  Created by 大島友陽 on 2021/01/01.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import Firebase
import FirebaseFirestore

class GuestShiftViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance {
    
    private var events = [Event]()
    var group: Group?
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var workShiftTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
        self.workShiftTableView.dataSource = self
        self.workShiftTableView.delegate = self
        
        setupCalendar()
        fetchEventsInfoFromFirestore()
        
    }
    
    private func setupCalendar() {
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        // calendarの曜日部分の色を変更
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .systemRed
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .systemBlue
        
        let myDate = Date()
        let tempCalendar = Calendar.current
        let nowYear = tempCalendar.component(.year, from: myDate)
        let nowMonth = tempCalendar.component(.month, from: myDate)
        let nowDay = tempCalendar.component(.day, from: myDate)
        let selectDate = tempCalendar.date(from: DateComponents(year: nowYear, month: nowMonth, day: nowDay))
        calendar.select(selectDate)
        dateLabel.text = "\(nowYear)年\(nowMonth)月\(nowDay)日"
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func judgeHoliday(_ date: Date) -> Bool {
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    func getDay(_ date: Date) -> String {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        let date = "\(year)年\(month)月\(day)日"
        return date
    }
    
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        
        return nil
    }
    
    @IBAction func pushAddShiftButton(_ sender: Any) {
        
        pushAddViewController()
    }
    
    private func pushAddViewController() {
        let storyboard = UIStoryboard(name: "editDateInfomation", bundle: nil)
        let editDateInformationViewController = storyboard.instantiateViewController(withIdentifier: "editDateInfomationViewController") as! editDateInfomationViewController
        let nav = UINavigationController(rootViewController: editDateInformationViewController)
        editDateInformationViewController.date = dateLabel.text
        editDateInformationViewController.group = self.group
        self.present(nav, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let selectedDate = getDay(date)
        dateLabel.text = selectedDate
        
        fetchEventsInfoFromFirestore()
    }
    
    private func fetchEventsInfoFromFirestore() {
        guard let date = dateLabel.text else { return }
        guard let groupId = self.group?.documentId else { return }
        
        Firestore.firestore().collection("Groups").document(groupId).collection("Events").document(date).collection("shifts").addSnapshotListener { (snapshots, err) in
                
                if let err = err {
                    print("eventの情報の取得に失敗しました\(err)")
                    return
                }
                
                self.events.removeAll()
                snapshots?.documentChanges.forEach({ (DocumentChange) in
                    switch DocumentChange.type {
                    case .added:
                        
                        let dic = DocumentChange.document.data()
                        let event = Event.init(dic: dic)
                            
                        self.events.append(event)
                            
                    case .modified, .removed:
                        print("nothing to do")
                    }
                })
                
                self.workShiftTableView.reloadData()
            }
    }
    
}

extension GuestShiftViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = workShiftTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorkShiftTableViewCell
        cell.event = events[indexPath.row]
        return cell
    }
    
    
    
}

class WorkShiftTableViewCell: UITableViewCell {
    
    var event: Event? {
        didSet {
            memberNameLabel.text = event?.memberName
            guard let startTime = event?.startTime else { return }
            guard let finishTime = event?.finishTime else { return }
            workShiftTimeLabel.text = "\(startTime)  ~  \(finishTime)"
        }
    }
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var workShiftTimeLabel: UILabel!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

