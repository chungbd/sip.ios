import Foundation
import CoreData

class CompanyController: UITableViewController{
    
    var contacts: [Contact] = []
    
    let authentication: Authentication = Authentication()
    
    var sipNumber = "0702126175"

    override func viewDidLoad() {
        NSLog("CompanyController.viewDidLoad()")
        
        //Init Microsoft Graph
        MSGraphClient.setAuthenticationProvider(authentication.authenticationProvider)
    
        modifyTableStyle()
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            let fetchRequest = NSFetchRequest(entityName: "Contact")
            do {
                contacts = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: Style
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let contact = self.contacts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("company", forIndexPath: indexPath)as! ContactCell

        cell.nameLabel.text = "\(contact.name ?? "No name")"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        NSLog("Row: \(row)")
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    // MARK: Style
    private func modifyTableStyle(){
        // Set tableView padding
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        self.navigationController?.navigationBar.barStyle = .Black
    }
    
    // MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("prepareForSegue: \(segue.identifier)")
        
        if(segue.identifier == "makeCall"){
            
            let controller = segue.destinationViewController as! OutgoingCallController
            controller.sipNumber = sipNumber
            
        }
    }
}

