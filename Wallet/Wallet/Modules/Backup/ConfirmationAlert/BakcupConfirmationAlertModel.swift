import UIKit
import GrouviActionSheet

class BakcupConfirmationAlertModel: BaseAlertModel {

    var confirmItems = [BackupCheckboxItem]()

    override open var cancelButtonTitle: String {
        return "alert.cancel".localized
    }

    override init() {
        super.init()

        var confirmTexts = [NSAttributedString]()

        let confirmPartOne = "backup.confirmation.understand".localized
        let confirmPartTwo = "backup.confirmation.local_token_bold".localized
        let confirm = "\(confirmPartOne)\(confirmPartTwo)"
        let confirmAttributed = NSMutableAttributedString(string: confirm, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)])
        confirmAttributed.addAttribute(NSAttributedStringKey.font, value: BackupConfirmationTheme.regularFont, range: NSMakeRange(0, confirmPartOne.count))
        confirmAttributed.addAttribute(NSAttributedStringKey.font, value: BackupConfirmationTheme.boldFont, range: NSMakeRange(confirmPartOne.count, confirmPartTwo.count))
        confirmTexts.append(confirmAttributed)
        confirmTexts.append(NSAttributedString(string: "backup.confirmation.delete_app_warn".localized, attributes: [NSAttributedStringKey.font: BackupConfirmationTheme.regularFont]))

        let buttonItem = BackupButtonItem(tag: confirmItems.count, required: true, onTap: {
            self.dismiss?(true)
        })
        confirmTexts.enumerated().forEach { (index, string) in
            let item = BackupCheckboxItem(descriptionText: string, tag: index, required: true) { [weak self] view in
                if let view = view as? BackupCheckboxView, let item = view.item {
                    item.checked = !item.checked
                    buttonItem.isActive = (self?.confirmItems.filter { $0.checked == false })?.isEmpty ?? false
                    self?.reload?()
                }
            }
            item.showSeparator = false
            item.height =  BackupCheckboxItem.height(for: string)
            addItemView(item)
            confirmItems.append(item)
        }

        addItemView(buttonItem)
    }

}
