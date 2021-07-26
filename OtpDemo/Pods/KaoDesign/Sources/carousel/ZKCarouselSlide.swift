
public struct ZKCarouselSlide {
    public var imageUrl : String?
    public var image : UIImage?
    public var title : String?
    public var description: String?
    public var index: Int
    
    public init(index: Int, image: UIImage? = nil, title: String? = nil, description: String? = nil,imageUrl : String? = nil) {
        self.index = index
        self.image = image
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
    }
}
