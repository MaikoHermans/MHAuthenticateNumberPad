
import UIKit

/// 🤖 The base for all the UIView classes. Contains all the required functions.
@IBDesignable
public class BaseView: UIView
{
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewWithXib()
        initLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViewWithXib()
        initLayout()
    }
    
    public override func awakeFromNib() {
        setupLayout()
    }
    
    /// Attach the view to the delegate from the viewcontroller.
    ///
    /// - Parameter controller: The viewcontroller which this view is part of.
    func attachView(presenter: AnyObject, controller: UIViewController) {
        
    }
    
    /**
     Called upon when creating the view. Use for setting up layout objects like color, text etc.
     
     ## Example ##
     ```
     func initLayout() {
        setupLabels()
        setupButtons()
        setupTextFields()
     }
     ```
    */
    func initLayout() {
        
    }
    
    /**
     Called upon to create the layout for the required objects. Use this when you need to set objects after the view properties are available
     
     ## Example ##
     ```
     func setupLayout() {
        setupNewView()
        setupNewScrollView()
        setupNewButton()
     }
     ```
     */
    func setupLayout() {
        
    }
    
}

// MARK: - Private functions
extension BaseView {
    
    /// Setup the view based on the xib that matches the file name.
    fileprivate func setupViewWithXib() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        addSubview(view)
    }
    
    
    /// Get the correct view from the xib.
    ///
    /// - Returns: The view loaded from the matching XIB file.
    fileprivate func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
}
