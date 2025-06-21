
//  BaseVC.swift

import UIKit
import DGActivityIndicatorView
import JGProgressHUD
import SDWebImage

class BaseVC: UIViewController
{
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    let defaults = UserDefaults.standard
    var isReload = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBottomSpace(tbleViewMain : UITableView){
           let insets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
           tbleViewMain.contentInset = insets
       }
       
   
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func addTopSpace(tbleViewMain : UITableView){
        tbleViewMain.contentInset = UIEdgeInsets.init(top: 30, left: 0, bottom: 0, right: 0)
    }
    
   

   
    func RegisterXib(tableviewMain :UITableView , RegisterXib : [String]){
        
        for indexObj in RegisterXib {
            tableviewMain.register(UINib.init(nibName: indexObj, bundle: nil), forCellReuseIdentifier: indexObj)
        }
    }
    
    @objc func Back(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func Dismiss(){
        self.dismiss(animated: true) {
            
        }
    }
    
    
    
    func addRightButtonWithtext(selector: Selector , lblText : String , widthValue : Double = 40){
        
        let navigation = self.navigationController as! BaseNavigationController
        navigation.RemoveRightButton(self)
        navigation.addRightButtonWithTitle(self, selector: selector, lblText: lblText , widthValue : widthValue)
    }
    func navigationClear() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    func NavigationHide(status : Bool){
        self.navigationController?.isNavigationBarHidden = status
    }
    
    
    
    func addLeftButtonWithtext(selector: Selector , lblText : String , widthValue : Double = 40){
        
        let navigation = self.navigationController as! BaseNavigationController
        navigation.RemoveLefttButton(self)
        navigation.addLeftButtonWithTitle(self, selector: selector, lblText: lblText , widthValue : widthValue)
    }
    
    
    func addRightButtonWithImage(selector: Selector , imageMain : UIImage){
        
        let navigation = self.navigationController as! BaseNavigationController
        navigation.RemoveRightButton(self)
        navigation.addRightButton(self, selector: selector, image: imageMain)
    }
    
    func addLeftButtonWithImage(selector: Selector , imageMain : UIImage){
        
        let navigation = self.navigationController as! BaseNavigationController
        navigation.addLeftButtonOn(self, selector: selector, image: imageMain)
    }
    
    
    func RemoveRigtButton(){
        
        let navigation = self.navigationController as! BaseNavigationController
        navigation.RemoveRightButton(self)
    }
    
    func RemoveLeftButton(){
        
        let navigation = self.navigationController as! BaseNavigationController
        navigation.RemoveLefttButton(self)
    }
    
    
    
    func OpenShareSheet(textMain : String , imageMain : UIImage){
        // set up activity view controller
        let textToShare = [ textMain ,imageMain] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: Alert Messge
    //MARK:
    
    func ShowAlertWithHandler(title: String = "" , message: String, DismissButton : String = "No", completion: ((_ status: Bool) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DismissButton, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(false)
        })
       
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowAlertWithCompletaion(title: String = "" , message: String, isError: Bool , DismissButton : String = "No" , AcceptButton : String = "Yes", completion: ((_ status: Bool) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DismissButton, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(false)
        })
        alert.addAction(UIAlertAction(title: AcceptButton, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func ShowAlertforPhoto(completion: ((_ status: Int) -> Void)? = nil) {
        
        let alert = UIAlertController(title: "" , message: "Choose source", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(1)
        })
        alert.addAction(UIAlertAction(title: "Phone Gallery", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(2)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            alert.dismiss(animated: true, completion: nil)
            completion!(3)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowErrorAlert(message : String , AlertTitle : String = kErrorTitle) {
        let alert = UIAlertController(title: AlertTitle , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func ShowSuccessAlert(message : String , AlertTitle : String = "") {
        let alert = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
//            _ = self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowSuccessAlertWithDismiss(message : String ) {
        let alert = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: {
                
            })
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowSuccessAlertWithrootView(message : String ) {
        let alert = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowSuccessAlertWithViewRemove(message : String ) {
        let alert = UIAlertController(title: "" , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOKBtnTitle, style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
            self.view.removeFromSuperview()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func TabbarHide(status : Bool){
        self.tabBarController?.tabBar.isHidden = status
    }
    //MARK: Navigation Actions
    //MARK:
    func AddBackButton() {
        let navigation = self.navigationController as! BaseNavigationController
        navigation.RemoveLefttButton(self)
        navigation.addBackButtonOn(self, selector: #selector(BaseVC.Back))
    }
    
  
    
    func GetViewcontrollerWithName(nameViewController : String) -> UIViewController {
        let viewObj = (self.storyboard?.instantiateViewController(withIdentifier: nameViewController))! as UIViewController
        return viewObj
    }
    
    
    func GetNavigationcontrollerWithName(nameViewController : String) -> BaseNavigationController {
        let viewObj = (self.storyboard?.instantiateViewController(withIdentifier: nameViewController))! as! BaseNavigationController
        return viewObj
    }
    
    func PushViewWithIdentifier(name : String ) {
        let viewPush = self.storyboard?.instantiateViewController(withIdentifier: name)
        self.navigationController?.pushViewController(viewPush!, animated: true)
    }
    
    func PushViewWithStoryBoard(name : String , StoryBoard : String ) {
        
        let viewController = self.GetView(nameViewController: name, nameStoryBoard: StoryBoard)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func ShowViewWithIdentifier(name : String ) {
        let viewPush = self.storyboard?.instantiateViewController(withIdentifier: name)
        self.present(viewPush!, animated: true) {
            
        }
    }

    func ShowMainDashBoard(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushMainView"), object: nil)
    }
    
    func UpdateTitle(title : String , color : UIColor) {
        
        let navigation = self.navigationController as? BaseNavigationController
        self.navigationController?.isNavigationBarHidden = false
        navigation?.AddTitle(self, title: title ,color: color)
    }
  
    
    
    
    func deleteFile(filePath: URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
    //MARK:- Custom methods
    func showLoading() {
        
        
        let viewLoader = UIView.init(frame: UIScreen.main.bounds)
        viewLoader.backgroundColor = UIColor.init(red: (0.0), green: (0.0), blue: (0.0), alpha: 0.4)
        viewLoader.tag = -6000

        
        let window = UIApplication.shared.keyWindow
        
        window!.addSubview(viewLoader)

        let hud = JGProgressHUD(style: .extraLight)
        hud.textLabel.text = "Loading"
        hud.show(in: viewLoader)


        self.view.isUserInteractionEnabled = false
        
    }
    
    func hideLoading() {
        self.view.isUserInteractionEnabled = true
        
        let window = UIApplication.shared.keyWindow
        
        window!.viewWithTag(-5000)?.removeFromSuperview()
        window!.viewWithTag(-6000)?.removeFromSuperview()
    }
    
}


// MARK:
// MARK: Project Bottom Cell
extension BaseVC {
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    
    func ShakeView(viewMain : UIView){
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( caTransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
            NSValue( caTransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 7/100
        
        viewMain.layer.add( anim, forKey:nil )
    }
    
    
    func DialNumber(PhoneNumber : String){
        if let url = URL(string: "tel://\(PhoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    func OpenLink(webUrl:String){
        let url = URL(string: webUrl)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func GetView(nameViewController : String , nameStoryBoard : String) -> UIViewController {
        let storyboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: nameViewController)) as UIViewController
        
        return viewObj
    }
    
    
    func CheckNullValue(value : AnyObject) -> String{
        if ((value as? String) != nil) {
            return value as! String
            
        }else if ((value as? Int) != nil) {
            return String(value as! Int)
        }else  if ((value as? Double) != nil)  {
            return String(value as! Double)
        }else {
            return ""
        }
    }
    
    func downloadImage(imgview : UIImageView , URL : String){
        let newURL = (URL).replacingOccurrences(of: " ", with: "%20")
        print("URL ===>")
        print(newURL)
        imgview.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgview.sd_setImage(with: NSURL(string:  newURL)! as URL, placeholderImage: UIImage(named: "PlaceHolder"))
    }

    
    func loadImage(imageName : String) -> (UIImage,Bool) {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName)
            let image    = UIImage(contentsOfFile: imageURL.path)
//            print("Image name ")
//            print(imageName)
            if image == nil {
//                print("Image name Nil")
                return (UIImage.init() , false)
            }else {
//                print("Image name Image")
                return (image! , true)
            }
            
            // Do whatever you want with the image
        }else {
//            print("Image name Image Nill ")
            return (UIImage.init() , false)
        }
        
        
    }
    
    
    func saveImage(imageName : String  ,imageMain : UIImage){
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = imageName
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
//        print("fileURL")
//        print(fileURL)
        if let data = imageMain.jpegData(compressionQuality:  1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    
    func removeImage(imageName : String ){
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let documentDirectoryFileUrl = documentsDirectory.appendingPathComponent(imageName)

        if FileManager.default.fileExists(atPath: documentDirectoryFileUrl.path) {
            do {
                try FileManager.default.removeItem(at: documentDirectoryFileUrl)
            } catch {
                print("Could not delete file: \(error)")
            }
        }
    }

   
}

class ResponseModel: NSObject {
    
    func ReturnValue(value : Any) -> String{
        if let MainValue = value as? Int {
            return String(MainValue)
        }else  if let MainValue = value as? String {
            return MainValue
        }else  if let MainValue = value as? Double {
            return String(MainValue)
        }
        return ""
    }
    
    
}

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }

    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

    func removeSpecialCharacters() -> String {
        let okayChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890 ")
        return String(self.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
    }
    
    func formatTheDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print(self)
        let date = dateFormatter.date(from: self)

        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MM-dd-yyyy"
        if date == nil {
            return ""
        }
        return newDateFormatter.string(from: date!)
        
    }
   

}

extension UITableView {
    
    func setEmptyMessageForTbl(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
    }
    
    func restoreForTbl() {
        self.backgroundView = nil
    }

}


