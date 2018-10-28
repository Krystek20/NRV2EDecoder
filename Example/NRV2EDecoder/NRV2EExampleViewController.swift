import UIKit

class NRV2EExampleViewController: UITableViewController {

    static let CELL_IDENTIFIER = "NRV2EValueCellIdentifier"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NRV2EExampleViewController.CELL_IDENTIFIER, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func openScannerAction(_ sender: Any) {
        let scannerViewController = NRV2EScannerViewController()
    }
    
}
