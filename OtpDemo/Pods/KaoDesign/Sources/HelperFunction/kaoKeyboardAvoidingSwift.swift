// MARK: - TableView
class kaoKeyboardAvoidingTableView:UITableView,UITextFieldDelegate, UITextViewDelegate {
    
    override var frame:CGRect{
        willSet{
            super.frame = frame
        }
        
        didSet{
            if hasAutomaticKeyboardAvoidingBehaviour() {return}
            kaoKeyboardAvoiding_updateContentInset()
        }
    }
    
    override var contentSize:CGSize{
        willSet(newValue){
            if hasAutomaticKeyboardAvoidingBehaviour() {
                super.contentSize = newValue
                return
            }
            
            if newValue.equalTo(self.contentSize)
            {
                return
            }
            
            super.contentSize = newValue
            self.kaoKeyboardAvoiding_updateContentInset()
        }
        
        //        didSet{
        //            self.kaoKeyboardAvoiding_updateContentInset()
        //        }
    }
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func hasAutomaticKeyboardAvoidingBehaviour()->Bool
    {
        if #available(iOS 8.3, *) {
            if self.delegate is UITableViewController
            {
                return true
            }
        }
        
        return false
    }
    
    func focusNextTextField()->Bool
    {
        return self.kaoKeyboardAvoiding_focusNextTextField()
    }
    
    @objc func scrollToActiveTextField()
    {
        return self.kaoKeyboardAvoiding_scrollToActiveTextField()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(kaoKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.kaoKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
        super.touchesEnded(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !self.focusNextTextField()
        {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(kaoKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(kaoKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
    }
}

private extension kaoKeyboardAvoidingTableView
{
    func setup()
    {
        if self.hasAutomaticKeyboardAvoidingBehaviour() { return }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kaoKeyboardAvoiding_keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kaoKeyboardAvoiding_keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollToActiveTextField),
                                               name: UITextView.textDidBeginEditingNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollToActiveTextField),
                                               name: UITextField.textDidBeginEditingNotification,
                                               object: nil)
    }
}

// MARK: - CollectionView
class kaoKeyboardAvoidingCollectionView:UICollectionView,UITextViewDelegate {
    
    override var contentSize:CGSize{
        willSet(newValue){
            if newValue.equalTo(self.contentSize)
            {
                return
            }
            
            super.contentSize = newValue
            self.kaoKeyboardAvoiding_updateContentInset()
        }
        
    }
    
    
    override var frame:CGRect{
        willSet{
            super.frame = frame
        }
        
        didSet{
            self.kaoKeyboardAvoiding_updateContentInset()
        }
    }
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.setup()
        
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func focusNextTextField()->Bool
    {
        return self.kaoKeyboardAvoiding_focusNextTextField()
    }
    
    @objc func scrollToActiveTextField()
    {
        return self.kaoKeyboardAvoiding_scrollToActiveTextField()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(kaoKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.kaoKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
        super.touchesEnded(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !self.focusNextTextField()
        {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(kaoKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(kaoKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
    }
}

private extension kaoKeyboardAvoidingCollectionView
{
    func setup()
    {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kaoKeyboardAvoiding_keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kaoKeyboardAvoiding_keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollToActiveTextField),
                                               name: UITextView.textDidBeginEditingNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollToActiveTextField),
                                               name: UITextField.textDidBeginEditingNotification,
                                               object: nil)
    }
}

// MARK: - ScrollView
class kaoKeyboardAvoidingScrollView:UIScrollView,UITextFieldDelegate,UITextViewDelegate
{
    override var contentSize:CGSize{
        didSet{
            self.kaoKeyboardAvoiding_updateFromContentSizeChange()
        }
    }
    
    
    override var frame:CGRect{
        didSet{
            self.kaoKeyboardAvoiding_updateContentInset()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    func contentSizeToFit()
    {
        self.contentSize = self.kaoKeyboardAvoiding_calculatedContentSizeFromSubviewFrames()
    }
    
    func focusNextTextField() ->Bool
    {
        return self.kaoKeyboardAvoiding_focusNextTextField()
    }
    
    @objc func scrollToActiveTextField()
    {
        return self.kaoKeyboardAvoiding_scrollToActiveTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(kaoKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.kaoKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
        super.touchesEnded(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !self.focusNextTextField()
        {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(kaoKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), object: self)
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(kaoKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
    }
}

private extension kaoKeyboardAvoidingScrollView
{
    func setup()
    {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kaoKeyboardAvoiding_keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kaoKeyboardAvoiding_keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollToActiveTextField),
                                               name: UITextView.textDidBeginEditingNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollToActiveTextField),
                                               name: UITextField.textDidBeginEditingNotification,
                                               object: nil)
    }
}

// MARK: - Process Event
let kCalculatedContentPadding:CGFloat = 10;
let kMinimumScrollOffsetPadding:CGFloat = 20;

extension UIScrollView
{
    @objc func kaoKeyboardAvoiding_keyboardWillShow(_ notification:Notification)
    {
        guard let userInfo = notification.userInfo else { return }
        guard let rectNotification = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else
        {
            return
        }
        
        let keyboardRect = self.convert(rectNotification.cgRectValue , from: nil)
        if keyboardRect.isEmpty
        {
            return
        }
        
        let state = self.keyboardAvoidingState()
        
        guard let firstResponder = self.kaoKeyboardAvoiding_findFirstResponderBeneathView(self) else { return}
        state.keyboardRect = keyboardRect
        if !state.keyboardVisible
        {
            state.priorInset = self.contentInset
            state.priorScrollIndicatorInsets = self.scrollIndicatorInsets
            state.priorPagingEnabled = self.isPagingEnabled
        }
        
        state.keyboardVisible = true
        self.isPagingEnabled = false
        
        if self is kaoKeyboardAvoidingScrollView
        {
            state.priorContentSize = self.contentSize
            if self.contentSize.equalTo(CGSize.zero)
            {
                self.contentSize = self.kaoKeyboardAvoiding_calculatedContentSizeFromSubviewFrames()
            }
        }
        
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let options = UIView.AnimationOptions(rawValue: UInt(curve))
        
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0,
                       options: options,
                       animations: { [weak self]() -> Void in
                        if let actualSelf = self
                        {
                            actualSelf.contentInset = actualSelf.kaoKeyboardAvoiding_contentInsetForKeyboard()
                            let viewableHeight = actualSelf.bounds.size.height - actualSelf.contentInset.top - actualSelf.contentInset.bottom
                            let point = CGPoint(x: actualSelf.contentOffset.x, y: actualSelf.kaoKeyboardAvoiding_idealOffsetForView(firstResponder, viewAreaHeight: viewableHeight))
                            actualSelf.setContentOffset(point, animated: false)
                            
                            actualSelf.scrollIndicatorInsets = actualSelf.contentInset
                            actualSelf.layoutIfNeeded()
                        }
                        
        }) { (finished) -> Void in
            
        }
    }
    
    @objc func kaoKeyboardAvoiding_keyboardWillHide(_ notification:Notification)
    {
        guard let userInfo = notification.userInfo else { return }
        
        guard let rectNotification = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else
        {
            return
        }
        let keyboardRect = self.convert(rectNotification.cgRectValue , from: nil)
        if keyboardRect.isEmpty
        {
            return
        }
        let state = self.keyboardAvoidingState()
        
        if !state.keyboardVisible
        {
            return
        }
        state.keyboardRect = CGRect.zero
        state.keyboardVisible = false
        
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let options = UIView.AnimationOptions(rawValue: UInt(curve))
        
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0,
                       options: options,
                       animations: { [weak self]() -> Void in
                        if let actualSelf = self
                        {
                            if actualSelf is kaoKeyboardAvoidingScrollView {
                                actualSelf.contentSize = state.priorContentSize
                                actualSelf.contentInset = state.priorInset
                                actualSelf.scrollIndicatorInsets = state.priorScrollIndicatorInsets
                                actualSelf.isPagingEnabled = state.priorPagingEnabled
                                actualSelf.layoutIfNeeded()
                            }
                        }
                        
        }) { (finished) -> Void in
            
        }
    }
    
    func kaoKeyboardAvoiding_updateFromContentSizeChange()
    {
        let state = self.keyboardAvoidingState()
        if state.keyboardVisible
        {
            state.priorContentSize = self.contentSize
        }
    }
    
    func kaoKeyboardAvoiding_focusNextTextField() ->Bool
    {
        guard let firstResponder = self.kaoKeyboardAvoiding_findFirstResponderBeneathView(self) else { return false}
        guard let view = self.kaoKeyboardAvoiding_findNextInputViewAfterView(firstResponder, beneathView: self) else { return false}
        Timer.scheduledTimer(timeInterval: 0.1, target: view, selector: #selector(becomeFirstResponder), userInfo: nil, repeats: false)
        
        return true
        
    }
    
    func kaoKeyboardAvoiding_scrollToActiveTextField()
    {
        let state = self.keyboardAvoidingState()
        
        if !state.keyboardVisible { return }
        
        let visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
        
        let idealOffset = CGPoint(x: 0,
                                  y: self.kaoKeyboardAvoiding_idealOffsetForView(self.kaoKeyboardAvoiding_findFirstResponderBeneathView(self),
                                                                                viewAreaHeight: visibleSpace))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {[weak self] () -> Void in
            self?.setContentOffset(idealOffset, animated: true)
        }
    }
    
    //Helper
    func kaoKeyboardAvoiding_findFirstResponderBeneathView(_ view:UIView) -> UIView?
    {
        for childView in view.subviews
        {
            if childView.responds(to: #selector(getter: isFirstResponder)) && childView.isFirstResponder
            {
                return childView
            }
            let result = kaoKeyboardAvoiding_findFirstResponderBeneathView(childView)
            if result != nil
            {
                return result
            }
        }
        return nil
    }
    
    func kaoKeyboardAvoiding_updateContentInset()
    {
        let state = self.keyboardAvoidingState()
        if state.keyboardVisible
        {
            self.contentInset = self.kaoKeyboardAvoiding_contentInsetForKeyboard()
        }
    }
    
    func kaoKeyboardAvoiding_calculatedContentSizeFromSubviewFrames() ->CGSize
    {
        let wasShowingVerticalScrollIndicator = self.showsVerticalScrollIndicator
        let wasShowingHorizontalScrollIndicator = self.showsHorizontalScrollIndicator
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        var rect = CGRect.zero
        
        for view in self.subviews
        {
            rect = rect.union(view.frame)
        }
        
        rect.size.height += kCalculatedContentPadding
        self.showsVerticalScrollIndicator = wasShowingVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = wasShowingHorizontalScrollIndicator
        
        return rect.size
    }
    
    func kaoKeyboardAvoiding_idealOffsetForView(_ view:UIView?,viewAreaHeight:CGFloat) -> CGFloat
    {
        let contentSize = self.contentSize
        
        var offset:CGFloat = 0.0
        let subviewRect =  view != nil ? view!.convert(view!.bounds, to: self) : CGRect.zero
        
        var padding = (viewAreaHeight - subviewRect.height)/2
        if padding < kMinimumScrollOffsetPadding
        {
            padding = kMinimumScrollOffsetPadding
        }
        
        offset = subviewRect.origin.y - padding - self.contentInset.top
        
        if offset > (contentSize.height - viewAreaHeight)
        {
            offset = contentSize.height - viewAreaHeight
        }
        
        if offset < -self.contentInset.top
        {
            offset = -self.contentInset.top
        }
        
        return offset
    }
    
    func kaoKeyboardAvoiding_contentInsetForKeyboard() -> UIEdgeInsets
    {
        let state = self.keyboardAvoidingState()
        var newInset = self.contentInset;
        
        let keyboardRect = state.keyboardRect
        newInset.bottom = keyboardRect.size.height - max(keyboardRect.maxY - self.bounds.maxY, 0)
        
        return newInset
        
    }
    
    func kaoKeyboardAvoiding_viewIsValidKeyViewCandidate(_ view:UIView)->Bool
    {
        if view.isHidden || !view.isUserInteractionEnabled {return false}
        
        if view is UITextField
        {
            if (view as! UITextField).isEnabled {return true}
        }
        
        if view is UITextView
        {
            if (view as! UITextView).isEditable {return true}
        }
        
        return false
    }
    
    func kaoKeyboardAvoiding_findNextInputViewAfterView(_ priorView:UIView,beneathView view:UIView, candidateView bestCandidate: inout UIView?)
    {
        let priorFrame = self.convert(priorView.frame, to: priorView.superview)
        let candidateFrame = bestCandidate == nil ? CGRect.zero : self.convert(bestCandidate!.frame, to: bestCandidate!.superview)
        
        var bestCandidateHeuristic = -sqrt(candidateFrame.origin.x*candidateFrame.origin.x + candidateFrame.origin.y*candidateFrame.origin.y) + ( Float(fabs(candidateFrame.minY - priorFrame.minY))<Float.ulpOfOne ? 1e6 : 0)
        
        for childView in view.subviews
        {
            if kaoKeyboardAvoiding_viewIsValidKeyViewCandidate(childView)
            {
                let frame = self.convert(childView.frame, to: view)
                let heuristic = -sqrt(frame.origin.x*frame.origin.x + frame.origin.y*frame.origin.y)
                    + (Float(fabs(frame.minY - priorFrame.minY)) < Float.ulpOfOne ? 1e6 : 0)
                
                if childView != priorView && (Float(fabs(frame.minY - priorFrame.minY)) < Float.ulpOfOne
                    && frame.minX > priorFrame.minX
                    || frame.minY > priorFrame.minY)
                    && (bestCandidate == nil || heuristic > bestCandidateHeuristic)
                {
                    bestCandidate = childView
                    bestCandidateHeuristic = heuristic
                }
            }else
            {
                self.kaoKeyboardAvoiding_findNextInputViewAfterView(priorView, beneathView: view, candidateView: &bestCandidate)
            }
        }
    }
    
    func kaoKeyboardAvoiding_findNextInputViewAfterView(_ priorView:UIView,beneathView view:UIView) ->UIView?
    {
        var candidate:UIView?
        self.kaoKeyboardAvoiding_findNextInputViewAfterView(priorView, beneathView: view, candidateView: &candidate)
        return candidate
    }
    
    
    @objc func kaoKeyboardAvoiding_assignTextDelegateForViewsBeneathView(_ obj: AnyObject)
    {
        func processWithView(_ view: UIView) {
            for childView in view.subviews
            {
                if childView is UITextField || childView is UITextView
                {
                    self.kaoKeyboardAvoiding_initializeView(childView)
                }else
                {
                    self.kaoKeyboardAvoiding_assignTextDelegateForViewsBeneathView(childView)
                }
            }
        }
        
        if let timer = obj as? Timer, let view = timer.userInfo as? UIView {
            processWithView(view)
        }
        else if let view = obj as? UIView {
            processWithView(view)
        }
    }
    
    func kaoKeyboardAvoiding_initializeView(_ view:UIView)
    {
        if let textField = view as? UITextField,
            let delegate = self as? UITextFieldDelegate, textField.returnKeyType == UIReturnKeyType.default &&
            textField.delegate !== delegate
        {
            textField.delegate = delegate
            let otherView = self.kaoKeyboardAvoiding_findNextInputViewAfterView(view, beneathView: self)
            textField.returnKeyType = otherView != nil ? .next : .done
            
        }
    }
    
    func keyboardAvoidingState()->kaoKeyboardAvoidingState
    {
        var state = objc_getAssociatedObject(self, &AssociatedKeysKeyboard.DescriptiveName) as? kaoKeyboardAvoidingState
        if state == nil
        {
            state = kaoKeyboardAvoidingState()
            self.state = state
        }
        
        return self.state!
    }
    
}

// MARK: - Internal object observer
internal class kaoKeyboardAvoidingState:NSObject
{
    var priorInset = UIEdgeInsets.zero
    var priorScrollIndicatorInsets = UIEdgeInsets.zero
    
    var keyboardVisible = false
    var keyboardRect = CGRect.zero
    var priorContentSize = CGSize.zero
    
    var priorPagingEnabled = false
}

internal extension UIScrollView
{
    fileprivate struct AssociatedKeysKeyboard {
        static var DescriptiveName = "KeyBoard_DescriptiveName"
    }
    
    var state:kaoKeyboardAvoidingState?{
        get{
            let optionalObject:AnyObject? = objc_getAssociatedObject(self, &AssociatedKeysKeyboard.DescriptiveName) as AnyObject?
            if let object:AnyObject = optionalObject {
                return object as? kaoKeyboardAvoidingState
            } else {
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeysKeyboard.DescriptiveName, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
